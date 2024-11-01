os_name                 = "freebsd"
os_version              = "14"
os_arch                 = "x86_64"
iso_url                 = "/osx/Users/Share/Phone/FreeBSD-14.1-RELEASE-amd64-disc1.iso"
iso_checksum            = "file:https://mirror.nju.edu.cn/freebsd/releases/ISO-IMAGES/14.1/CHECKSUM.SHA256-FreeBSD-14.1-RELEASE-amd64"
boot_command            = ["<wait><esc><wait>boot -s<wait><enter><wait><wait10><wait10>/bin/sh<enter><wait>mdmfs -s 100m md1 /tmp<enter><wait>mdmfs -s 100m md2 /mnt<enter><wait>dhclient -p /tmp/dhclient.vtnet0.pid -l /tmp/dhclient.lease.vtnet0 vtnet0<enter><wait><wait5>fetch -o /tmp/installerconfig http://{{ .HTTPIP }}:{{ .HTTPPort }}/common/freebsd.sh && bsdinstall script /tmp/installerconfig<enter><wait>"]