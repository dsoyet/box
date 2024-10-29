os_name                 = "xfce4"
os_version              = "22"
os_arch                 = "x86_64"
iso_url                 = "/home/share/Sync/linuxmint-22-xfce-64bit.iso"
iso_checksum            = "sha256:55e917b99206187564029476f421b98f5a8a0b6e54c49ff6a4cb39dcfeb4bd80"
boot_command            = ["e<down><down><down><leftCtrlOn>k<leftCtrlOff><spacebar><spacebar><spacebar><spacebar><spacebar><spacebar><spacebar><spacebar>linux         /casper/vmlinuz url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/mint/preseed.cfg boot=casper debug-ubiquity automatic-ubiquity quiet splash noprompt --<leftCtrlOn>x<leftCtrlOff>"]
