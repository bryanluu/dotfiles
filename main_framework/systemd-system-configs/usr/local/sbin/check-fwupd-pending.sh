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
