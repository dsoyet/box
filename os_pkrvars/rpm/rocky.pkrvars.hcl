os_name                 = "rocky"
os_version              = "8"
os_arch                 = "x86_64"
iso_url                 = "/osx/Users/Share/Phone/Rocky-8.10-x86_64-minimal.iso"
iso_checksum            = "sha256:2c735d3b0de921bd671a0e2d08461e3593ac84f64cdaef32e3ed56ba01f74f4b"
boot_command            = ["<up>e<down><down><end> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rpm/rocky.cfg<leftCtrlOn>x<leftCtrlOff>"]
