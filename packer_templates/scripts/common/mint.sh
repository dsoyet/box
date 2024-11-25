#!/bin/sh -eux

export DEBIAN_FRONTEND=noninteractive

cat <<EOF > /etc/apt/sources.list.d/official-package-repositories.list
# Do not edit this file manually, use Software Sources instead.

deb https://mirrors.cernet.edu.cn/linuxmint wilma main upstream import backport #id:linuxmint_main

deb https://mirrors.cernet.edu.cn/ubuntu noble main restricted universe multiverse
deb https://mirrors.cernet.edu.cn/ubuntu noble-updates main restricted universe multiverse
deb https://mirrors.cernet.edu.cn/ubuntu noble-backports main restricted universe multiverse

deb https://mirrors.cernet.edu.cn/ubuntu noble-security main restricted universe multiverse
EOF
apt-get update

sed -i 's/timeout=30/timeout=0/g' /boot/grub/grub.cfg
apt-get -y install xrdp chromium
apt-get -y autoremove --purge firefox firefox-locale-en
sed -i 's/#EnableFuseMount=false/EnableFuseMount=false/g' /etc/xrdp/sesman.ini

systemctl enable ssh xrdp
systemctl disable casper-md5check.service