#!/bin/sh -eux

export DEBIAN_FRONTEND=noninteractive

sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub;
sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=true/g' /etc/default/grub
update-grub;

# for default efi boot
# mkdir -p /boot/efi/EFI/Boot
# cp /boot/efi/EFI/kali/grubx64.efi /boot/efi/EFI/Boot/bootx64.efi



# Users
# apt-get -y install xrdp chromium
# apt-get -y autoremove --purge firefox-esr
# systemctl enable ssh xrdp