#!/bin/sh -eux

CONFIG_SCRIPT='/usr/local/bin/arch-config.sh'
if [ -b /dev/vda ]; then
  ROOT_DISK='vda'
  PKGS='base linux openssh sudo'
fi
if [ -b /dev/sda ]; then
  ROOT_DISK='sda'
  PKGS='base linux openssh sudo hyperv'
fi

ROOT_PARTITION="/dev/${ROOT_DISK}2"

# Partition and format disk
parted "/dev/${ROOT_DISK}" ---pretend-input-tty <<EOF
mktable gpt
mkpart ESP fat32 0% 5%
mkpart primary 5% 95%
mkpart primary linux-swap 95% 100%
set 1 esp on
quit
EOF

mkfs.btrfs ${ROOT_PARTITION} 
mkfs.fat -F 32 /dev/${ROOT_DISK}1
mount ${ROOT_PARTITION} /mnt
mkdir /mnt/efi
mount /dev/${ROOT_DISK}1 /mnt/efi

wget -q https://mirrors.nju.edu.cn/gentoo/releases/amd64/autobuilds/current-stage3-amd64-desktop-systemd/stage3-amd64-desktop-systemd-20241117T163407Z.tar.xz
tar xpf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner -C /mnt

mount --bind /run /mnt/run && mount --make-slave /mnt/run
mount --types proc /proc /mnt/proc
mount --rbind /sys /mnt/sys && mount --make-rslave /mnt/sys
mount --rbind /dev /mnt/dev && mount --make-rslave /mnt/dev

# Installation
cat << 'EOF' > /mnt/etc/portage/binrepos.conf/gentoobinhost.conf
[gentoobinhost]
priority = 1
sync-uri = https://mirrors.nju.edu.cn/gentoo/releases/amd64/binpackages/23.0/x86-64
EOF
cat << 'EOF' > /mnt/etc/locale.gen
en_US.UTF-8 UTF-8
EOF
cat << 'EOF' > /mnt/etc/resolv.conf
nameserver 223.5.5.5
EOF
cat << 'EOF' > /mnt/etc/portage/make.conf
COMMON_FLAGS="-O2 -pipe"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"

ACCEPT_LICENSE="-* @FREE @BINARY-REDISTRIBUTABLE"
FEATURES="${FEATURES} getbinpkg"
FEATURES="${FEATURES} binpkg-request-signature"

LC_MESSAGES=C.utf8
GENTOO_MIRRORS="http://mirrors.nju.edu.cn/gentoo/"
EOF
cat << 'EOF' > /mnt/etc/portage/package.accept_keywords/installkernel
sys-kernel/installkernel
sys-boot/uefi-mkconfig
app-emulation/virt-firmware
EOF
cat << 'EOF' > /mnt/etc/portage/package.use/installkernel
sys-kernel/installkernel efistub
EOF
cat << 'EOF' > /mnt/etc/kernel/cmdline
root=/dev/vda2
EOF
cat << 'EOF' > /mnt/etc/portage/package.use/uki
sys-apps/systemd boot ukify
sys-kernel/installkernel dracut ukify uki
EOF

echo sleep...
sleep 3600

# emerge-webrsync
# emerge --ask sys-kernel/installkernel sys-kernel/linux-firmware sys-firmware/intel-microcode
# locale-gen
# ln -sf ../usr/share/zoneinfo/Europe/Brussels /etc/localtime