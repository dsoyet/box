os_name                 = "gentoo"
os_version              = "2024"
os_arch                 = "x86_64"
iso_urls                = ["/osx/Users/Share/Phone/gentoo.iso", ]
iso_checksum            = "sha256:21813bdb67c9ac320984fbbafc7c34df7589ec688cb46a788e857e58f55feeee"
boot_command            = ["<enter><wait5>43<enter><wait10><wait10>lsblk<enter>rc-service sshd start<enter>echo 'CREATE_MAIL_SPOOL=no'>>/etc/default/useradd<enter>useradd -m vagrant<enter>echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/99_vagrant;<enter>echo 'vagrant:vagrant'|chpasswd<enter>"]
