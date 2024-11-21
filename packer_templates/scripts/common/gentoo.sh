#!/bin/sh -eux

STAGE3_URL='https://mirrors.nju.edu.cn/gentoo/releases/amd64/autobuilds/current-stage3-amd64-desktop-systemd/stage3-amd64-desktop-systemd-20241117T163407Z.tar.xz'
CONFIG_SCRIPT='/usr/local/bin/gentoo-config.sh'
ROOT_DISK=$(ls /dev/[sv]da)

# Partition and format disk
parted "${ROOT_DISK}" ---pretend-input-tty <<EOF
mktable gpt
mkpart ESP fat32 0% 5%
mkpart primary 5% 95%
mkpart primary linux-swap 95% 100%
set 1 esp on
quit
EOF

mkfs.btrfs ${ROOT_DISK}2 && mkfs.fat -F 32 ${ROOT_DISK}1
mount --mkdir ${ROOT_DISK}2 /mnt/gentoo
mount --mkdir ${ROOT_DISK}1 /mnt/gentoo/efi

curl -SsLl ${STAGE3_URL} | tar xJp -C /mnt/gentoo --xattrs --numeric-owner

mount --rbind /sys /mnt/gentoo/sys && mount --make-rslave /mnt/gentoo/sys
mount --types proc /proc /mnt/gentoo/proc
mount --bind /run /mnt/gentoo/run && mount --make-slave /mnt/gentoo/run
mount --rbind /dev /mnt/gentoo/dev && mount --make-rslave /mnt/gentoo/dev
cp /etc/resolv.conf /mnt/gentoo/etc/resolv.conf

cat << 'EOF' > /mnt/gentoo/etc/portage/make.conf
EMERGE_DEFAULT_OPTS="--quiet-build --jobs=4 --load-average=4 --autounmask-continue"
ACCEPT_LICENSE="*"
GENTOO_MIRRORS="http://mirrors.nju.edu.cn/gentoo/"
EOF
cat << 'EOF' > /mnt/gentoo/etc/locale.gen
en_GB ISO-8859-1
en_GB.UTF-8 UTF-8
EOF
cat << EOF > /mnt/gentoo/etc/kernel/cmdline
root=${ROOT_DISK}2
EOF
cat > /mnt/gentoo/etc/fstab <<EOF
${ROOT_DISK}1 /efi  vfat noauto,noatime    1 2
${ROOT_DISK}3 none  swap sw                0 0
${ROOT_DISK}2 /     ext4 noauto,noatime    0 1
EOF
mkdir -p /mnt/gentoo/etc/portage/repos.conf
cat << 'EOF' > /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
[DEFAULT]
main-repo = gentoo
[gentoo]
location = /var/db/repos/gentoo
sync-type = rsync
sync-uri = rsync://rsync.mirrors.ustc.edu.cn/gentoo-portage
auto-sync = yes
sync-rsync-verify-jobs = 1
sync-rsync-verify-metamanifest = yes
sync-rsync-verify-max-age = 3
sync-openpgp-key-path = /usr/share/openpgp-keys/gentoo-release.asc
sync-openpgp-keyserver = hkps://keys.gentoo.org
sync-openpgp-key-refresh-retry-count = 40
sync-openpgp-key-refresh-retry-overall-timeout = 1200
sync-openpgp-key-refresh-retry-delay-exp-base = 2
sync-openpgp-key-refresh-retry-delay-max = 60
sync-openpgp-key-refresh-retry-delay-mult = 4
sync-webrsync-verify-signature = yes
EOF

echo sleep...
sleep 3600

# emerge-webrsync
#equery u sys-apps/systemd
# emerge --ask sys-kernel/gentoo-sources app-portage/gentoolkit
# eselect kernel set 1
# emerge --ask sys-kernel/linux-firmware sys-firmware/intel-microcode 
# emerge --ask sys-kernel/installkernel
# emerge --ask sys-kernel/gentoo-kernel
# locale-gen
# ln -sf ../usr/share/zoneinfo/Europe/Brussels /etc/localtime
# umount -R /mnt/gentoo
# default/linux/amd64/23.0/desktop/systemd

# libbpf: failed to find '.BTF' ELF section in vmlinux
# FAILED: load BTF from vmlinux: No data available
