#!/bin/sh -eux

# change quarterly to latest for rolling
mkdir -p /usr/local/etc/pkg/repos
cat >> /usr/local/etc/pkg/repos/FreeBSD.conf << 'EOT'
FreeBSD: {
  url: "http://mirrors.ustc.edu.cn/freebsd-pkg/${ABI}/quarterly",
  mirror_type: "none",
}
EOT

pkg install -y sudo vim xorg xfce xrdp xorgxrdp