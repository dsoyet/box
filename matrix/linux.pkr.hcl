build {
  name        = "linux"
  description = <<EOF
This build creates centos images for centos versions :
* stable
* 8
For the following builders :
* vmware-iso
EOF

  source "source.vmware-iso.uefi" {
    name             = "centos"
    guest_os_type    = "centos8-64"
    vm_name          = source.name
    iso_url          = local.iso_url_centos_stable
    iso_checksum     = "file:${local.iso_checksum_url_centos_stable}"
    output_directory = "${local.artifact_directory}/share/${source.name}"
    boot_command     = local.centos_uefi_boot_command

    shutdown_command               = "echo 'share' | sudo -S /sbin/halt -h -p"
    ssh_password                   = "share"
    ssh_port                       = 22
    ssh_timeout                    = "1h"
    ssh_username                   = "share"
    vmx_remove_ethernet_interfaces = true
  }

  source "source.vmware-iso.uefi" {
    name             = "rhel"
    guest_os_type    = "rhel8-64"
    vm_name          = source.name
    iso_url          = local.iso_url_rhel
    iso_checksum     = local.iso_checksum_url_ubuntu_server
    output_directory = "${local.artifact_directory}/share/${source.name}"
    boot_command     = local.rhel_uefi_boot_command

    shutdown_command               = "echo 'share' | sudo -S /sbin/halt -h -p"
    ssh_password                   = "share"
    ssh_port                       = 22
    ssh_timeout                    = "1h"
    ssh_username                   = "share"
    vmx_remove_ethernet_interfaces = true
  }

  source "source.vmware-iso.uefi" {
    name             = "fedora"
    guest_os_type    = "fedora-64"
    vm_name          = source.name
    iso_url          = local.iso_url_fedora
    iso_checksum     = "file:${local.iso_checksum_url_fedora}"
    output_directory = source.name
    boot_command     = local.fedora_uefi_boot_command

    shutdown_command               = "echo 'share' | sudo -S /sbin/halt -h -p"
    ssh_password                   = "share"
    ssh_port                       = 22
    ssh_timeout                    = "1h"
    ssh_username                   = "share"
    vmx_remove_ethernet_interfaces = true
  }

  source "source.vmware-iso.uefi" {
    name             = "tumbleweed"
    guest_os_type    = "opensuse-64"
    vm_name          = source.name
    iso_url          = local.iso_url_tumbleweed
    iso_checksum     = "file:${local.iso_checksum_url_tumbleweed}"
    output_directory = source.name
    boot_command     = local.tumbleweed_uefi_boot_command

    shutdown_command               = "echo 'share' | sudo -S /sbin/halt -h -p"
    ssh_password                   = "share"
    ssh_port                       = 22
    ssh_timeout                    = "1h"
    ssh_username                   = "share"
    vmx_remove_ethernet_interfaces = true
  }

  source "source.vmware-iso.uefi" {
    name             = "leap"
    guest_os_type    = "opensuse-64"
    vm_name          = source.name
    iso_url          = local.iso_url_opensuse_leap
    iso_checksum     = "file:${local.iso_checksum_url_opensuse_leap}"
    output_directory = source.name
    boot_command     = local.opensuse_leap_uefi_boot_command

    shutdown_command               = "echo 'share' | sudo -S /sbin/halt -h -p"
    ssh_password                   = "share"
    ssh_port                       = 22
    ssh_timeout                    = "1h"
    ssh_username                   = "share"
    vmx_remove_ethernet_interfaces = true
  }

  source "source.vmware-iso.uefi" {
    name             = "kali"
    guest_os_type    = "debian10-64"
    vm_name          = source.name
    iso_url          = local.iso_url_kali
    iso_checksum     = "file:${local.iso_checksum_url_kali}"
    output_directory = source.name
    boot_command     = local.kali_uefi_boot_command

    shutdown_command               = "echo 'share' | sudo -S /sbin/halt -h -p"
    ssh_password                   = "share"
    ssh_port                       = 22
    ssh_timeout                    = "1h"
    ssh_username                   = "share"
    vmx_remove_ethernet_interfaces = true
  }

  source "source.vmware-iso.uefi" {
    name             = "debian"
    guest_os_type    = "debian10-64"
    vm_name          = source.name
    iso_url          = local.iso_url_debian
    iso_checksum     = "file:${local.iso_checksum_url_debian}"
    output_directory = source.name
    boot_command     = local.debian_uefi_boot_command

    shutdown_command               = "echo 'share' | sudo -S /sbin/halt -h -p"
    ssh_password                   = "share"
    ssh_port                       = 22
    ssh_timeout                    = "1h"
    ssh_username                   = "share"
    vmx_remove_ethernet_interfaces = true
  }

  source "source.vmware-iso.uefi" {
    name             = "ubuntu"
    guest_os_type    = "ubuntu-64"
    vm_name          = source.name
    iso_url          = local.iso_url_ubuntu_server
    iso_checksum     = local.iso_checksum_url_ubuntu_server
    output_directory = "${local.artifact_directory}/share/${source.name}"
    boot_command     = local.ubuntu_server_uefi_boot_command

    cd_content = {
      "meta-data" = ""
      "user-data" = templatefile("${local.artifact_directory}/etc/ubuntu/cloudinit", { packages = ["nginx"] })
    }
    cd_label = "CIDATA"

    shutdown_command               = "echo 'share' | sudo -S /sbin/halt -h -p"
    ssh_password                   = "share"
    ssh_port                       = 22
    ssh_timeout                    = "1h"
    ssh_username                   = "share"
    vmx_remove_ethernet_interfaces = true
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    output              = "${local.artifact_directory}/share/${source.name}.box"
  }

  provisioner "shell" {
    environment_vars  = ["HOME_DIR=/home/share"]
    execute_command   = "echo 'share' | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'"
    expect_disconnect = true
    // fileset will list files in etc/scripts sorted in an alphanumerical way.
    scripts = ["${local.artifact_directory}/etc/init/${source.name}.sh"]
  }
}


build {
  name        = "source"
  description = <<EOF
This build creates centos images for centos versions :
* stable
* 8
For the following builders :
* vmware-iso
EOF

  source "source.vmware-iso.uefi" {
    name             = "arch"
    guest_os_type    = "other5xlinux-64"
    vm_name          = source.name
    iso_url          = local.iso_url_arch
    iso_checksum     = "file:${local.iso_checksum_url_arch}"
    output_directory = source.name
    boot_command     = local.arch_uefi_boot_command

    shutdown_command               = "echo 'share' | sudo -S /sbin/halt -h -p"
    ssh_password                   = "root"
    ssh_port                       = 22
    ssh_timeout                    = "1h"
    ssh_username                   = "root"
    vmx_remove_ethernet_interfaces = true
  }

  source "source.vmware-iso.uefi" {
    name             = "gentoo"
    guest_os_type    = "other5xlinux-64"
    vm_name          = source.name
    iso_url          = local.iso_url_gentoo
    iso_checksum     = local.iso_checksum_url_gentoo
    output_directory = source.name
    boot_command     = local.gentoo_uefi_boot_command

    shutdown_command               = "shutdown -hP now"
    ssh_password                   = "root"
    ssh_port                       = 22
    ssh_timeout                    = "1h"
    ssh_username                   = "root"
    vmx_remove_ethernet_interfaces = true
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    output              = "${source.name}.box"
  }

  provisioner "shell" {
    environment_vars  = ["HOME_DIR=/home/share"]
    execute_command   = "echo 'share' | {{.Vars}} sh -eux '{{.Path}}'"
    expect_disconnect = true
    // fileset will list files in etc/scripts sorted in an alphanumerical way.
    scripts = fileset("..", "artifacts/${source.name}.sh")
  }
}


