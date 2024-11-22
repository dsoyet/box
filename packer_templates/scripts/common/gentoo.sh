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
mkswap ${ROOT_DISK}3 && swapon ${ROOT_DISK}3

curl -SsLl ${STAGE3_URL} | tar xJp -C /mnt/gentoo --xattrs --numeric-owner

mount --rbind /sys /mnt/gentoo/sys && mount --make-rslave /mnt/gentoo/sys
mount --types proc /proc /mnt/gentoo/proc
mount --bind /run /mnt/gentoo/run && mount --make-slave /mnt/gentoo/run
mount --rbind /dev /mnt/gentoo/dev && mount --make-rslave /mnt/gentoo/dev
cp /etc/resolv.conf /mnt/gentoo/etc/resolv.conf

cat << 'EOF' > /mnt/gentoo/etc/portage/make.conf
EMERGE_DEFAULT_OPTS="--quiet-build --jobs=4 --load-average=4"
ACCEPT_LICENSE="*"
GENTOO_MIRRORS="http://mirrors.nju.edu.cn/gentoo/"
EOF
cat << 'EOF' > /mnt/gentoo/etc/locale.gen
en_GB ISO-8859-1
en_GB.UTF-8 UTF-8
EOF
cat << 'EOF' > /mnt/gentoo/etc/systemd/network/wired.network
[Match]
Name=e*
[Network]
DHCP=yes
EOF
cat << 'EOF' > /mnt/gentoo/etc/portage/package.use/uki
sys-kernel/installkernel dracut uki -ugrd
sys-apps/systemd boot
sys-kernel/gentoo-kernel-bin generic-uki
EOF
cat > /mnt/gentoo/etc/fstab <<EOF
${ROOT_DISK}1 /efi  vfat noauto,noatime    1 2
${ROOT_DISK}3 none  swap sw                0 0
${ROOT_DISK}2 /     ext4 noauto,noatime    0 1
EOF
mkdir -p /mnt/gentoo/etc/dracut.conf.d
cat << EOF > /mnt/gentoo/etc/dracut.conf.d/uki.conf
uefi="yes"
kernel_cmdline="root=${ROOT_DISK}2"
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

install --mode=0755 /dev/null "/mnt/gentoo${CONFIG_SCRIPT}"
cat <<-EOF > "/mnt/gentoo${CONFIG_SCRIPT}"
    emerge-webrsync
    emerge sys-kernel/gentoo-sources app-portage/gentoolkit
    eselect kernel set 1
    emerge sys-kernel/linux-firmware sys-firmware/intel-microcode 
    emerge sys-kernel/gentoo-kernel-bin

    locale-gen
    ln -sf ../usr/share/zoneinfo/Asia/Shanghai /etc/localtime

    systemctl enable systemd-networkd.service systemd-resolved.service
    systemctl enable sshd.service

    echo 'CREATE_MAIL_SPOOL=no'>>/etc/default/useradd
    useradd --create-home --user-group vagrant
    echo 'root:vagrant' | chpasswd
    echo 'vagrant:vagrant' | chpasswd

    mkdir -p /efi/EFI/Boot
    cp /efi/EFI/Linux/gentoo-*.efi /efi/EFI/Boot/bootx64.efi
    systemd-machine-id-setup

    emerge --depclean
    cd /usr/src/linux && make clean

    rm -rf /root/*
    rm -rf /var/tmp/*
    rm -rf /usr/portage
EOF
chroot /mnt/gentoo ${CONFIG_SCRIPT}

export HOME_DIR=/mnt/gentoo/home/vagrant
mkdir -p $HOME_DIR/.ssh
cat << 'EOF' > $HOME_DIR/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOF

echo 'PROMPT_COLOR="1;31m"; ((UID)) && PROMPT_COLOR="1;32m"; export PS1="\[\033[$PROMPT_COLOR\][\h:\w]\\$\[\033[0m\] "' >> /mnt/gentoo/etc/bash/bashrc.d/99_user.bash

chown -R vagrant $HOME_DIR/.ssh;
chmod -R go-rwsx $HOME_DIR/.ssh;

umount -R /mnt/gentoo
