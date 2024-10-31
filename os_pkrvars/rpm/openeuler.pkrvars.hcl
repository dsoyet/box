os_name                 = "openeuler"
os_version              = "9"
os_arch                 = "x86_64"
iso_url                 = "/osx/Users/Share/Phone/openEuler-22.03-LTS-SP1-x86_64-dvd.iso"
iso_checksum            = "sha256:bdebae1d0b95fc92269ce96da3c57339b9c571a02e11fb7d3d0b336e520072e9"
boot_command            = ["<up>e<down><down><end> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rpm/openeuler.cfg<leftCtrlOn>x<leftCtrlOff>"]
