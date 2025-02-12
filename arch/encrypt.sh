#!/usr/bin/env bash

set -euo pipefail

part="$1"
boot="$2"

e2fsck -f "$part"
resize2fs -p "$part" "$(($(blockdev --getsize64 "$part")/1024/1024/1024-1))G"
cryptsetup reencrypt --encrypt --reduce-device-size 32M "$part"
cryptsetup open "$part" recrypt
resize2fs /dev/mapper/recrypt
mount /dev/mapper/recrypt /mnt
mount "$boot" /mnt/boot

cat > /mnt/etc/mkinitcpio.conf.d/encryption.conf <<EOF
# HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)
HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)
EOF

arch-chroot /mnt mkinitcpio -P

sed -i '$ d' /mnt/boot/loader/entries/arch.conf
echo "options rd.luks.name=$(blkid "$part" -o value -s UUID)=root rd.luks.options=discard,no-read-workqueue,no-write-workqueue root=/dev/mapper/root rw" >> /mnt/boot/loader/entries/arch.conf
umount -R /mnt
cryptsetup close recrypt

