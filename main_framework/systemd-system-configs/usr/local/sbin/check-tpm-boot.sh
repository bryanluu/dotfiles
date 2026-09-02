#!/bin/bash
if journalctl -b 0 --no-pager | grep -q "TPM policy does not match current system state"; then
  /usr/local/sbin/ntfy-notify.sh "TPM auto-unlock failed" \
    "main-framework booted via passphrase fallback, not TPM. Re-enroll with: sudo systemd-cryptenroll /dev/nvme0n1p3 --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=7"
fi
