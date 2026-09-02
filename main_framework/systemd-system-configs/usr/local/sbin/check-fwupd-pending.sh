#!/bin/bash
UPDATES=$(fwupdmgr get-updates 2>&1)
if echo "$UPDATES" | grep -qiE "system firmware|dbx|bios"; then
  /usr/local/sbin/ntfy-notify.sh "Firmware update pending" \
    "A BIOS/firmware update is staged on main-framework and will likely break TPM auto-unlock on next reboot. After rebooting and entering your passphrase, re-enroll with: sudo systemd-cryptenroll /dev/nvme0n1p3 --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=7"
fi
