# TPM2 LUKS Auto-Unlock + Failure Alerts

Documents the setup that lets `main-framework` auto-unlock its LUKS-encrypted
root partition via TPM2 on boot (so it can come back up headless after a
smart-plug power cycle), plus the notification system that pages you when
that auto-unlock is at risk of breaking.

## Background: why this breaks periodically

Auto-unlock works by sealing the LUKS decryption key to the TPM2 chip,
gated on **PCR 7** — the Platform Configuration Register that measures
Secure Boot state (Secure Boot on/off, and the `PK`/`KEK`/`db`/`dbx` UEFI
key databases). If PCR 7's value changes, the TPM correctly refuses to
release the key, and boot falls back to the manual LUKS passphrase prompt.

The most common cause on this hardware is a **BIOS/firmware update** applied
automatically by `fwupd` — these frequently touch Secure Boot state and are
explicitly flagged by fwupd itself: "Full disk encryption secrets may be
invalidated when updating." Less commonly, a UEFI `dbx` (Secure Boot
revocation list) update can do the same.

This is a deliberate security tradeoff, not a bug: PCR 7 verification is
what stops someone from booting a live USB (bypassing Secure Boot) to mount
the drive directly without your OS login or LUKS passphrase. We keep it
bound rather than drop it, and instead built tooling to make the periodic
breakage low-friction.

## One-time setup: enrolling the TPM2 keyslot

```bash
# Check current LUKS keyslots/tokens on the encrypted partition
sudo cryptsetup luksDump /dev/nvme0n1p3

# Enroll (or re-enroll) a TPM2-sealed keyslot bound to PCR 7
sudo systemd-cryptenroll /dev/nvme0n1p3 --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=7
```

- `--wipe-slot=tpm2` removes any existing (possibly stale) TPM2 keyslot
  first, so you don't accumulate dead slots across re-enrollments.
- `--tpm2-device=auto` lets systemd auto-detect the TPM chip.
- `--tpm2-pcrs=7` binds the seal to Secure Boot state only.
- You'll be prompted for the current LUKS passphrase to authorize this.
- No `/etc/crypttab` edits or `dracut -f`/initramfs rebuild needed — on this
  systemd version (259.8), the TPM2 token is auto-discovered from the LUKS2
  header metadata at boot, independent of crypttab.

## Recovery when locked out (stuck at passphrase prompt)

If a smart-plug reboot leaves the machine stuck at the LUKS passphrase
prompt and unreachable over Tailscale/SSH:

1. Get physical access, enter your LUKS passphrase to boot normally.
2. Confirm what happened:
   ```bash
   journalctl -b 0 | grep -iE "cryptsetup|tpm2|luks"
   ```
   Look for: `TPM policy does not match current system state.` — this
   confirms a PCR 7 mismatch (as opposed to some other failure).
3. Re-run the enrollment command above to reseal against the *current*
   PCR 7 state.
4. Reboot via the smart plug again to confirm auto-unlock now works.

## Diagnostic commands used to trace this issue

Kept here for reference in case of a similar future mystery:

```bash
# Full LUKS header + keyslot/token metadata
sudo cryptsetup luksDump /dev/nvme0n1p3

# What crypttab looked like at the time the current initramfs was built
# (compare against the live /etc/crypttab to spot drift)
sudo lsinitrd -f etc/crypttab

# Recent kernel installs (correlate timing with breakage)
rpm -q kernel --last

# Firmware/dbx update history — the actual root cause here was a BIOS
# update (0.0.3.5 -> 0.0.3.6) applied 2026-08-22, which explicitly carries
# the "Full disk encryption secrets may be invalidated when updating" flag
sudo fwupdmgr get-history

# Boot-time TPM2 unlock attempt/failure messages for the current boot
journalctl -b 0 | grep -iE "cryptsetup|tpm2|luks"
```

## Failure-alert system

Two independent systemd-managed checks, both notifying via
[ntfy.sh](https://ntfy.sh) push notifications. No auto-healing — every
alert requires you to manually re-enroll (see Recovery section above)
after confirming the situation, by design (avoids storing the LUKS
passphrase on disk for unattended re-authentication).

### ntfy topic

The actual topic string is a random secret and is **intentionally not
committed to this repo** (the repo is public). It lives locally at:

```
/etc/ntfy-topic
```

To recreate on a fresh install:
```bash
openssl rand -hex 12 | sudo tee /etc/ntfy-topic > /dev/null
sudo chmod 600 /etc/ntfy-topic
```
Then subscribe to that exact topic string in the ntfy mobile app
(server: `ntfy.sh`).

### Files installed (mirrored under `systemd-system-configs/` in this repo)

| Real path | Purpose |
|---|---|
| `/usr/local/sbin/ntfy-notify.sh` | Shared helper: sends a push notification via ntfy.sh, reading the topic from `/etc/ntfy-topic` |
| `/usr/local/sbin/check-tpm-boot.sh` | Reactive check: did *this* boot fall back to the LUKS passphrase instead of TPM2? |
| `/usr/local/sbin/check-fwupd-pending.sh` | Proactive check: is a pending firmware/dbx update staged that will likely break TPM2 unlock on next reboot? Deduplicated via a state file so it only re-alerts when the pending-update list actually changes. |
| `/etc/systemd/system/tpm-boot-check.service` | Runs `check-tpm-boot.sh` once per boot, after networking is up |
| `/etc/systemd/system/fwupd-fde-warn.service` | Runs `check-fwupd-pending.sh` |
| `/etc/systemd/system/fwupd-fde-warn.timer` | Triggers the above 10 min after boot, then every 6 hours |

### Reactive check: `check-tpm-boot.sh`

```bash
#!/bin/bash
if journalctl -b 0 --no-pager | grep -q "TPM policy does not match current system state"; then
  /usr/local/sbin/ntfy-notify.sh "TPM auto-unlock failed" \
    "main-framework booted via passphrase fallback, not TPM. Re-enroll with: sudo systemd-cryptenroll /dev/nvme0n1p3 --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=7"
fi
```

Wired to run once per boot via `tpm-boot-check.service`
(`WantedBy=multi-user.target`, `After=network-online.target`).

### Proactive check: `check-fwupd-pending.sh`

```bash
#!/bin/bash
STATE_DIR="/var/lib/fwupd-fde-warn"
STATE_FILE="$STATE_DIR/last-notified"
UPDATES=$(fwupdmgr get-updates 2>&1)

if echo "$UPDATES" | grep -qiE "system firmware|dbx|bios"; then
  CURRENT_HASH=$(echo "$UPDATES" | sha256sum | cut -d' ' -f1)
  mkdir -p "$STATE_DIR"
  LAST_HASH=""
  [ -f "$STATE_FILE" ] && LAST_HASH=$(cat "$STATE_FILE")

  if [ "$CURRENT_HASH" != "$LAST_HASH" ]; then
    /usr/local/sbin/ntfy-notify.sh "Firmware update pending" \
      "A BIOS/firmware update is staged on main-framework and will likely break TPM auto-unlock on next reboot. After rebooting and entering your passphrase, re-enroll with: sudo systemd-cryptenroll /dev/nvme0n1p3 --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=7"
    echo "$CURRENT_HASH" > "$STATE_FILE"
  fi
else
  rm -f "$STATE_FILE"
fi
```

Intentionally broad matching (`system firmware|dbx|bios`) rather than
trying to parse fwupd's exact FDE-impact flag — prefers occasional
unnecessary alerts over missing a real one. State file is cleared once
`fwupdmgr get-updates` reports nothing pending, so a future unrelated
update always triggers a fresh alert.

### Reinstall checklist

On a fresh Fedora install, to restore this whole system:

1. Confirm TPM2 is visible: `sudo systemd-cryptenroll --tpm2-device=list`
2. Enroll the TPM2 keyslot (see "One-time setup" above)
3. Recreate `/etc/ntfy-topic` (see "ntfy topic" above) and subscribe on
   your phone
4. Copy the three scripts from
   `main_framework/systemd-system-configs/usr/local/sbin/` to
   `/usr/local/sbin/`, `chmod 755` each
5. Copy the three unit files from
   `main_framework/systemd-system-configs/etc/systemd/system/` to
   `/etc/systemd/system/`
6. `sudo systemctl daemon-reload`
7. `sudo systemctl enable tpm-boot-check.service`
8. `sudo systemctl enable --now fwupd-fde-warn.timer`
9. Test: `sudo /usr/local/sbin/ntfy-notify.sh "Test" "still working"`
