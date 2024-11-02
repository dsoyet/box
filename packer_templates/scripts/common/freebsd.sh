#!/bin/sh -eux

# change quarterly to latest for rolling
mkdir -p /usr/local/etc/pkg/repos
cat >> /usr/local/etc/pkg/repos/FreeBSD.conf << 'EOT'
FreeBSD: {
  url: "http://mirrors.ustc.edu.cn/freebsd-pkg/${ABI}/quarterly",
  mirror_type: "none",
}
EOT

pkg install -y sudo bash vim xorg xfce xrdp

pw usermod vagrant -s /usr/local/bin/bash
sysrc xrdp_enable="YES"
sysrc xrdp_sesman_enable="YES"
cat >> /usr/local/etc/X11/xorg.conf.d/driver.conf << 'EOT'
Section "Device"
    Identifier "Card0"
    Driver     "scfb"
EndSection
EOT

sed -i '' 's/# exec startxfce4/exec startxfce4/g' /usr/local/etc/xrdp/startwm.sh
sed -i '' 's/exec xterm/# exec xterm/g' /usr/local/etc/xrdp/startwm.sh
sed -i '' 's/#EnableFuseMount=false/EnableFuseMount=false/g' /usr/local/etc/xrdp/sesman.ini

pkg autoremove --yes && pkg clean --yes --all
rm -rf /var/db/pkg/repos/FreeBSD