variable "unattend_path" {
  type    = string
  default = "centos.cfg"
}

variable "headless" {
  type    = bool
  default = true
}

locals {
  // fileset lists all files in the http directory as a set, we convert that
  // set to a list of strings and we then take the directory of the first
  // value. This validates that the http directory exists even before starting
  // any builder/provisioner.
  artifact_directory = "D:/Ventoy/SC"
  windows_configset_directory = "D:/Image"
  http_directory_content = {
    "/tumbleweed.xml" = file("${local.artifact_directory}/http/tumbleweed.xml"),
    "/leap.xml"       = file("${local.artifact_directory}/http/leap.xml"),
    "/kali.cfg"       = file("${local.artifact_directory}/http/kali.cfg"),
    "/debian.cfg"     = file("${local.artifact_directory}/http/debian.cfg"),
    "/rhel.cfg"       = file("${local.artifact_directory}/http/rhel.cfg"),
    "/fedora.cfg"     = file("${local.artifact_directory}/http/fedora.cfg"),
    "/centos.cfg"     = file("${local.artifact_directory}/http/centos.cfg"),
  }
}

locals {
  iso_url_centos_stable          = "http://mirrors.nju.edu.cn/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-2009.iso"
  iso_checksum_url_centos_stable = "http://mirrors.nju.edu.cn/centos/7/isos/x86_64/sha256sum.txt"
  centos_bios_boot_command = [
    "<up><wait><tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/http/centos.cfg<enter><wait>"
  ]
  centos_uefi_boot_command = [
    "<up>e<down><down><end><bs><bs><bs><bs><bs>inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/http/centos.cfg<leftCtrlOn>x<leftCtrlOff>"
  ]
}

locals {
  iso_url_desktop_22h2          = "${local.artifact_directory}/boot/19045.1949.220822-1642.22H2_RELEASE_SVC_PROD3_CLIENTENTERPRISE_VOL_X64FRE_EN-US.ISO"
  iso_checksum_url_desktop_22h2 = "none"
  desktop_uefi_boot_command = [
    "CD"
  ]
}

locals {
  iso_url_outlook_22h2          = "${local.artifact_directory}/boot/22621.755.221019-1136.NI_RELEASE_SVC_PROD3_CLIENTMULTI_X64FRE_EN-US.ISO"
  iso_checksum_url_outlook_22h2 = "none"
  outlook_uefi_boot_command = [
    "CD"
  ]
}

locals {
  // iso_url_ubuntu_server          = "http://mirrors.nju.edu.cn/ubuntu-releases/jammy/ubuntu-22.04.1-live-server-amd64.iso"
  // iso_checksum_url_ubuntu_server = "http://mirrors.nju.edu.cn/ubuntu-releases/jammy/SHA256SUMS"
  iso_url_ubuntu_server          = "http://mirrors.nju.edu.cn/ubuntu-releases/kinetic/ubuntu-22.10-live-server-amd64.iso"
  iso_checksum_url_ubuntu_server = "http://mirrors.nju.edu.cn/ubuntu-releases/kinetic/SHA256SUMS"
  ubuntu_server_uefi_boot_command = [
    "<wait><wait><wait><wait><wait>c<wait>set gfxpayload=keep<enter><wait>linux /casper/vmlinuz quiet<wait> autoinstall<wait> ---<enter><wait>initrd /casper/initrd<wait><enter><wait>boot<enter><wait>"
  ]
}

locals {
  iso_url_opensuse_leap          = "http://mirrors.nju.edu.cn/opensuse/distribution/leap/15.4/iso/openSUSE-Leap-15.4-NET-x86_64-Media.iso"
  iso_checksum_url_opensuse_leap = "http://mirrors.nju.edu.cn/opensuse/distribution/leap/15.4/iso/openSUSE-Leap-15.4-NET-x86_64-Media.iso.sha256"
  opensuse_leap_uefi_boot_command = [
    "e<down><down><down><down><leftCtrlOn>e<leftCtrlOff><spacebar>textmode=1 autoyast=http://{{ .HTTPIP }}:{{ .HTTPPort }}/autoinst.xml<leftCtrlOn>x<leftCtrlOff>"
  ]
}

locals {
  iso_url_kali          = "http://mirrors.nju.edu.cn/kali-images/current/kali-linux-2022.3-installer-netinst-amd64.iso"
  iso_checksum_url_kali = "http://mirrors.nju.edu.cn/kali-images/current/SHA256SUMS"
  kali_uefi_boot_command = [
    "<wait>e<down><down><down><leftCtrlOn>k<leftCtrlOff>    linux    /install.amd/vmlinuz net.ifnames=0 console-setup/ask_detect=false auto console-setup/layoutcode=us console-setup/modelcode=pc105 debconf/frontend=noninteractive debian-installer=en_US fb=false preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/http/kali.cfg auto=true priority=critical --- quiet<leftCtrlOn>x<leftCtrlOff>"
  ]
}

locals {
  iso_url_rhel          = "${local.artifact_directory}/boot/rhel-8.6-x86_64-dvd.iso"
  iso_checksum_url_rhel = "none"
  rhel_uefi_boot_command = [
    "<up>e<down><down><end><bs><bs><bs><bs><bs>inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/http/rhel.cfg<leftCtrlOn>x<leftCtrlOff>"
  ]
}

locals {
  iso_url_debian          = "http://mirrors.nju.edu.cn/debian-cd/current/amd64/iso-cd/debian-11.5.0-amd64-netinst.iso"
  iso_checksum_url_debian = "http://mirrors.nju.edu.cn/debian-cd/current/amd64/iso-cd/SHA256SUMS"
  debian_uefi_boot_command = [
    "<down>e<down><down><down><leftCtrlOn>e<leftCtrlOff><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>auto=true url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/init.seed interface=auto hostname=debian domain=example priority=critical --- quiet<leftCtrlOn>x<leftCtrlOff>"
  ]
}

locals {
  iso_url_arch          = "http://mirrors.nju.edu.cn/archlinux/iso/latest/archlinux-x86_64.iso"
  iso_checksum_url_arch = "http://mirrors.nju.edu.cn/archlinux/iso/latest/sha256sums.txt"
  arch_uefi_boot_command = [
    "<enter><wait10><wait10><wait5>passwd root<enter>root<enter>root<enter>"
  ]
}

locals {
  iso_url_gentoo          = "http://mirrors.nju.edu.cn/gentoo/releases/amd64/autobuilds/current-install-amd64-minimal/install-amd64-minimal-20220911T170535Z.iso"
  iso_checksum_url_gentoo = "none"
  gentoo_uefi_boot_command = [
    "<enter><wait5>43<enter><wait10><wait5>sed -i 's/min=.*/min=1,1,1,1,1/g;s/enforce=everyone/enforce=none/g' /etc/security/passwdqc.conf<enter><wait>curl -O 'http://mirrors.nju.edu.cn/gentoo/releases/amd64/autobuilds/current-install-amd64-minimal/stage3-amd64-openrc-20220911T170535Z.tar.xz'<enter><wait>printf 'root\\nroot\\n'|passwd root<enter><wait>/etc/init.d/sshd start<enter><wait>"
  ]
}


locals {
  iso_url_fedora          = "http://mirrors.nju.edu.cn/fedora/development/rawhide/Server/x86_64/iso/Fedora-Server-netinst-x86_64-Rawhide-20220913.n.0.iso"
  iso_checksum_url_fedora = "http://mirrors.nju.edu.cn/fedora/development/rawhide/Server/x86_64/iso/Fedora-Server-Rawhide-x86_64-20220913.n.0-CHECKSUM"
  fedora_uefi_boot_command = [
    "<up>e<down><down><leftCtrlOn>e<leftCtrlOff><spacebar>text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/fedora.cfg<leftCtrlOn>x<leftCtrlOff>"
  ]
}


locals {
  iso_url_tumbleweed          = "http://mirrors.nju.edu.cn/opensuse/tumbleweed/iso/openSUSE-Tumbleweed-DVD-x86_64-Snapshot20220912-Media.iso"
  iso_checksum_url_tumbleweed = "http://mirrors.nju.edu.cn/opensuse/tumbleweed/iso/openSUSE-Tumbleweed-DVD-x86_64-Snapshot20220912-Media.iso.sha256"
  tumbleweed_uefi_boot_command = [
    "e<down><down><down><down><leftCtrlOn>e<leftCtrlOff><spacebar>textmode=1 autoyast=http://{{ .HTTPIP }}:{{ .HTTPPort }}/tumbleweed.xml<leftCtrlOn>x<leftCtrlOff>"
  ]
}

