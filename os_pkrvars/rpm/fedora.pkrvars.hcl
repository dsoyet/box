os_name                 = "fedora"
os_version              = "41"
os_arch                 = "x86_64"
iso_url                 = "https://mirrors.nju.edu.cn/fedora/development/rawhide/Server/x86_64/iso/Fedora-Server-netinst-x86_64-Rawhide-20241030.n.0.iso"
iso_checksum            = "file:https://mirrors.nju.edu.cn/fedora/development/rawhide/Server/x86_64/iso/Fedora-Server-iso-Rawhide-x86_64-20241030.n.0-CHECKSUM"
boot_command            = ["<up>e<down><down><leftCtrlOn>e<leftCtrlOff><spacebar>text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rpm/fedora.cfg<leftCtrlOn>x<leftCtrlOff>"]
