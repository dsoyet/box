os_name                 = "mint"
os_version              = "22"
os_arch                 = "x86_64"
iso_url                 = "/home/share/Sync/linuxmint-22-cinnamon-64bit.iso"
iso_checksum            = "sha256:7a04b54830004e945c1eda6ed6ec8c57ff4b249de4b331bd021a849694f29b8f"
boot_command            = ["e<down><down><down><leftCtrlOn>k<leftCtrlOff><spacebar><spacebar><spacebar><spacebar><spacebar><spacebar><spacebar><spacebar>linux         /casper/vmlinuz url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/mint/preseed.cfg boot=casper debug-ubiquity automatic-ubiquity quiet splash noprompt --<leftCtrlOn>x<leftCtrlOff>"]
