os_name                 = "rocky"
os_version              = "9"
os_arch                 = "x86_64"
iso_url                 = "/osx/Users/Share/Phone/Rocky-9.4-x86_64-minimal.iso"
iso_checksum            = "sha256:ee3ac97fdffab58652421941599902012179c37535aece76824673105169c4a2"
boot_command            = ["<up>e<down><down><end> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rpm/rocky.cfg<leftCtrlOn>x<leftCtrlOff>"]
