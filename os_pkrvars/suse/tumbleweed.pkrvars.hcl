os_name                 = "tumbleweed"
os_version              = "2024"
os_arch                 = "x86_64"
iso_url                 = "/osx/Users/Share/Phone/openSUSE-Tumbleweed-DVD-x86_64-Current.iso"
iso_checksum            = "sha256:26c1b2c94bcdfa4ce751aafa9b3306b8003c286f747f732aacfd4a8dd255f034"
boot_command            = ["e<down><down><down><down><leftCtrlOn>e<leftCtrlOff><spacebar>textmode=1 autoyast=http://{{ .HTTPIP }}:{{ .HTTPPort }}/windows/0010.xml<leftCtrlOn>x<leftCtrlOff>"]
