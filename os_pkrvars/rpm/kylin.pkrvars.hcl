os_name                 = "kylin"
os_version              = "8"
os_arch                 = "x86_64"
iso_url                 = "/osx/Users/Share/Phone/Kylin-Server-V10-SP3-2403-Release-20240426-x86_64.iso"
iso_checksum            = "sha256:6f0d388af9f8e0aba70825aae69ab36bd39849c5cd9dcf05696528203e7a22d0"
boot_command            = ["<up>e<down><down><end> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rpm/kylin.cfg<leftCtrlOn>x<leftCtrlOff>"]
