os_name                 = "black"
os_version              = "2024"
os_arch                 = "x86_64"
iso_url                 = "kali-linux-2024-W42-installer-netinst-amd64"
iso_directory           = "http://mirrors.bfsu.edu.cn/kali-images/kali-weekly"
iso_checksum            = "file:http://mirrors.bfsu.edu.cn/kali-images/kali-weekly/SHA256SUMS"
boot_command            = ["<wait>e<down><down><down><leftCtrlOn>k<leftCtrlOff>    linux    /install.amd/vmlinuz net.ifnames=0 console-setup/ask_detect=false auto console-setup/layoutcode=us console-setup/modelcode=pc105 debconf/frontend=noninteractive debian-installer=en_US fb=false preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/black/preseed.cfg  auto=true priority=critical --- quiet<leftCtrlOn>x<leftCtrlOff>"]
