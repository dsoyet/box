os_name                 = "freebsd"
os_version              = "14"
os_arch                 = "x86_64"
iso_urls                = ["/osx/Users/Share/Phone/FreeBSD-14.1-RELEASE-amd64-disc1.iso", "https://download.freebsd.org/releases/ISO-IMAGES/14.1/FreeBSD-14.1-RELEASE-amd64-disc1.iso"]
iso_checksum            = "file:https://download.freebsd.org/releases/ISO-IMAGES/14.1/CHECKSUM.SHA256-FreeBSD-14.1-RELEASE-amd64"
boot_command            = ["<wait><esc><wait>boot -s<wait><enter><wait5>/bin/sh<enter><wait>mdmfs -s 100m md1 /tmp<enter><wait>mdmfs -s 100m md2 /mnt<enter><wait>dhclient -p /tmp/dhclient.vtnet0.pid -l /tmp/dhclient.lease.vtnet0 vtnet0<enter><wait><wait5>fetch -o /tmp/config http://{{ .HTTPIP }}:{{ .HTTPPort }}/common/freebsd.sh && bsdinstall script /tmp/config<enter><wait>"]