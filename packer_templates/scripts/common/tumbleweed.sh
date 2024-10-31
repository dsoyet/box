#!/bin/sh -eux

sudo zypper mr -da
sudo zypper ar -p 64 -cfg 'https://mirror.nju.edu.cn/opensuse/tumbleweed/repo/oss/' mirror-oss
sudo zypper ar -p 64 -cfg 'https://mirror.nju.edu.cn/opensuse/tumbleweed/repo/non-oss/' mirror-non-oss
sudo zypper ar -p 64 -cfg 'https://mirror.nju.edu.cn/opensuse/update/tumbleweed/' mirror-factory-update

# for default efi boot
mkdir -p /boot/efi/EFI/Boot
cp /boot/efi/EFI/opensuse/grubx64.efi /boot/efi/EFI/Boot/bootx64.efi