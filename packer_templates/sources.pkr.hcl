locals {
  # Source block provider specific
  # hyperv-iso
  hyperv_enable_dynamic_memory = var.hyperv_enable_dynamic_memory == null ? (
    var.hyperv_generation == 2 && var.is_windows ? true : false
  ) : var.hyperv_enable_dynamic_memory
  hyperv_enable_secure_boot = var.hyperv_enable_secure_boot == null ? (
    var.hyperv_generation == 2 && var.is_windows ? true : false
  ) : var.hyperv_enable_secure_boot

  # qemu
  qemu_binary = var.qemu_binary == null ? "qemu-system-${var.os_arch}" : var.qemu_binary
  qemu_use_default_display = var.qemu_use_default_display == null ? (
    var.os_arch == "aarch64" ? true : false
  ) : var.qemu_use_default_display
  qemu_machine_type = var.qemu_machine_type == null ? (
    var.os_arch == "aarch64" ? "virt" : "q35"
  ) : var.qemu_machine_type
  qemuargs = var.qemuargs == null ? (
    var.is_windows ? [
      ["-cdrom", "${var.odt_url}"]
      ] : (
      var.os_arch == "aarch64" ? [
        ["-boot", "strict=off"]
        # ["-cpu", "host"],
        # ["-monitor", "stdio"]
      ] : null
    )
  ) : var.qemuargs


  # Source block common
  default_boot_wait = var.default_boot_wait == null ? (
    var.is_windows ? "-1s" : (
      var.os_name == "macos" ? "8m" : "3s"
    )
  ) : var.default_boot_wait
  cd_files = var.cd_files == null ? (
    var.is_windows ? (
      var.hyperv_generation == 2 ? [
        "/usb/$OEM$",
        "/usb/pkg",
        "/usb/virtio",
        "/usb/OpenSSH-Win64-v9.5.0.0.msi",
        ] : (
        var.os_arch == "x86_64" ? [
          "${path.root}/win_answer_files/${var.os_version}/Autounattend.xml",
          ] : [
          "${path.root}/win_answer_files/${var.os_version}/arm64/Autounattend.xml",
        ]
      )
    ) : null
  ) : var.cd_files
  cd_content = var.cd_content == null ? (
    var.is_windows ? (
      var.hyperv_generation == 2 ? {
        "AutoUnattend.xml" = templatefile("http/windows/${var.os_version}.xml", { image = var.os_image, lang = var.os_lang })
        } : (
        var.os_arch == "x86_64" ? {
        "AutoUnattend.xml" = templatefile("http/windows/${var.os_version}.xml", { image = var.os_image, lang = var.os_lang })
        } : {
        "AutoUnattend.xml" = templatefile("http/windows/${var.os_version}.xml", { image = var.os_image, lang = var.os_lang })
        }
      )
    ) : null
  ) : var.cd_content
  communicator = var.communicator == null ? (
    var.is_windows ? "winrm" : "ssh"
  ) : var.communicator
  floppy_files = var.floppy_files == null ? (
    var.is_windows ? (
      var.os_arch == "x86_64" ? [
        "${path.root}/win_answer_files/${var.os_version}/Autounattend.xml",
        ] : [
        "${path.root}/win_answer_files/${var.os_version}/arm64/Autounattend.xml",
      ]
    ) : null
  ) : var.floppy_files
  http_directory = var.http_directory == null ? "${path.root}/http" : var.http_directory
  memory = var.memory == null ? (
    var.is_windows || var.os_name == "macos" ? 10240 : 6144
  ) : var.memory
  output_directory = var.output_directory == null ? "/home/share/Downloads/${var.os_version}-${var.os_arch}" : var.output_directory
  shutdown_command = var.shutdown_command == null ? (
    var.is_windows ? "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\"" : (
      var.os_name == "macos" ? "echo 'vagrant' | sudo -S shutdown -h now" : (
        var.os_name == "freebsd" ? "echo 'vagrant' | su -m root -c 'shutdown -p now'" : "echo 'vagrant' | sudo -S /sbin/halt -h -p"
      )
    )
  ) : var.shutdown_command
  vm_name = var.vm_name == null ? (
    var.os_arch == "x86_64" ? "${var.os_name}-${var.os_version}-amd64" : "${var.os_name}-${var.os_version}-${var.os_arch}"
  ) : var.vm_name
}

# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "hyperv-iso" "vm" {
  # Hyper-v specific options
  enable_dynamic_memory = local.hyperv_enable_dynamic_memory
  enable_secure_boot    = local.hyperv_enable_secure_boot
  generation            = var.hyperv_generation
  guest_additions_mode  = var.hyperv_guest_additions_mode
  switch_name           = var.hyperv_switch_name
  # Source block common options
  boot_command     = var.boot_command
  boot_wait        = var.hyperv_boot_wait == null ? local.default_boot_wait : var.hyperv_boot_wait
  cd_files         = var.hyperv_generation == 2 ? local.cd_files : null
  cd_content       = var.hyperv_generation == 2 ? local.cd_content : null
  cpus             = var.cpus
  communicator     = local.communicator
  disk_size        = var.disk_size
  floppy_files     = var.hyperv_generation == 2 ? null : local.floppy_files
  headless         = var.headless
  http_directory   = local.http_directory
  iso_checksum     = var.iso_checksum
  iso_url          = var.iso_url
  memory           = local.memory
  output_directory = "${local.output_directory}-hyperv"
  shutdown_command = local.shutdown_command
  shutdown_timeout = var.shutdown_timeout
  ssh_password     = var.ssh_password
  ssh_port         = var.ssh_port
  ssh_timeout      = var.ssh_timeout
  ssh_username     = var.ssh_username
  winrm_password   = var.winrm_password
  winrm_timeout    = var.winrm_timeout
  winrm_username   = var.winrm_username
  vm_name          = local.vm_name
}
source "qemu" "vm" {
  # QEMU specific options
  accelerator         = var.qemu_accelerator
  display             = var.qemu_display
  use_default_display = local.qemu_use_default_display
  disk_image          = var.qemu_disk_image
  efi_boot            = var.qemu_efi_boot
  efi_firmware_code   = var.qemu_efi_firmware_code
  efi_firmware_vars   = var.qemu_efi_firmware_vars
  efi_drop_efivars    = var.qemu_efi_drop_efivars
  format              = var.qemu_format
  machine_type        = local.qemu_machine_type
  qemu_binary         = local.qemu_binary
  qemuargs            = local.qemuargs
  # Source block common options
  boot_command     = var.boot_command
  boot_wait        = var.qemu_boot_wait == null ? local.default_boot_wait : var.qemu_boot_wait
  cd_files         = var.hyperv_generation == 2 ? local.cd_files : null
  cd_content       = var.hyperv_generation == 2 ? local.cd_content : null
  cpus             = var.cpus
  cpu_model        = var.cpu_model
  communicator     = local.communicator
  disk_size        = var.disk_size
  floppy_files     = var.hyperv_generation == 2 ? null : local.floppy_files
  headless         = var.headless
  http_directory   = local.http_directory
  iso_checksum     = var.iso_checksum
  iso_url          = var.iso_url
  memory           = local.memory
  output_directory = "${local.output_directory}-qemu"
  shutdown_command = local.shutdown_command
  shutdown_timeout = var.shutdown_timeout
  ssh_password     = var.ssh_password
  ssh_port         = var.ssh_port
  ssh_timeout      = var.ssh_timeout
  ssh_username     = var.ssh_username
  winrm_password   = var.winrm_password
  winrm_timeout    = var.winrm_timeout
  winrm_username   = var.winrm_username
  vm_name          = local.vm_name
}
