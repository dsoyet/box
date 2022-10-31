build {
  name        = "windows"
  description = <<EOF
This build creates images for windows versions :
* 10
* 11
For the following builders :
* vmware-iso
EOF

  source "source.vmware-iso.uefi" {
    name              = "desktop"
    guest_os_type     = "windows9-64"
    vm_name           = source.name
    disk_adapter_type = "nvme"
    iso_url           = local.iso_url_desktop_22h2
    iso_checksum      = local.iso_checksum_url_desktop_22h2
    output_directory  = "${local.artifact_directory}/share/${source.name}"
    boot_command      = local.desktop_uefi_boot_command

    shutdown_command = "shutdown /s /t 1 /f /d p:4:1 /c \"Packer Shutdown\""
    cd_files = [
      "${local.artifact_directory}/etc/${source.name}/*"
    ]
    cd_label       = "X64FRE"
    communicator   = "winrm"
    winrm_password = "Share"
    winrm_timeout  = "1h"
    winrm_username = "Share"
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    output              = "${local.artifact_directory}/share/${source.name}.box"
  }

  provisioner "powershell" {
    elevated_password = "Share"
    elevated_user     = "Share"
    scripts           = ["${local.artifact_directory}/etc/init/${source.name}.ps1"]
  }
}