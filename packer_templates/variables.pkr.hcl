# General variables
variable "os_name" {
  type        = string
  description = "OS Brand Name"
}
variable "os_version" {
  type        = string
  default     = "2025"
  description = "OS version number"
}
variable "os_image" {
  type        = string
  default     = "Windows Server 2025 ServerDatacenter"
  description = "Name of wim image"
}
variable "os_lang" {
  type        = string
  default     = "en-US"
  description = "OS lang"
}
variable "os_arch" {
  type = string
  validation {
    condition     = var.os_arch == "x86_64" || var.os_arch == "aarch64"
    error_message = "The OS architecture type should be either x86_64 or aarch64."
  }
  description = "OS architecture type, x86_64 or aarch64"
}
variable "is_windows" {
  type        = bool
  default     = false
  description = "Determines to set setting for Windows or Linux"
}
variable "http_proxy" {
  type        = string
  default     = env("http_proxy")
  description = "Http proxy url to connect to the internet"
}
variable "https_proxy" {
  type        = string
  default     = env("https_proxy")
  description = "Https proxy url to connect to the internet"
}
variable "no_proxy" {
  type        = string
  default     = env("no_proxy")
  description = "No Proxy"
}
variable "sources_enabled" {
  type = list(string)
  default = [
    "source.hyperv-iso.vm",
    "source.qemu.vm"
  ]
  description = "Build Sources to use for building vagrant boxes"
}

# Source block provider specific variables
# hyperv-iso
variable "hyperv_boot_wait" {
  type    = string
  default = null
}
variable "hyperv_enable_dynamic_memory" {
  type    = bool
  default = null
}
variable "hyperv_enable_secure_boot" {
  type    = bool
  default = null
}
variable "hyperv_generation" {
  type        = number
  default     = 2
  description = "Hyper-v generation version"
}
variable "hyperv_guest_additions_mode" {
  type    = string
  default = "disable"
}
variable "hyperv_switch_name" {
  type    = string
  default = "hyperv"
}

# qemu
variable "qemu_accelerator" {
  type    = string
  default = null
}
variable "qemu_binary" {
  type    = string
  default = null
}
variable "qemu_boot_wait" {
  type    = string
  default = null
}
variable "qemu_display" {
  type        = string
  default     = "sdl"
  description = "What QEMU -display option to use. Defaults to gtk, use none to not pass the -display option allowing QEMU to choose the default"
}
variable "qemu_use_default_display" {
  type        = bool
  default     = null
  description = "If true, do not pass a -display option to qemu, allowing it to choose the default"
}
variable "qemu_disk_image" {
  type        = bool
  default     = null
  description = "Whether iso_url is a bootable qcow2 disk image"
}
variable "qemu_efi_boot" {
  type        = bool
  default     = true
  description = "Enable EFI boot"
}
variable "qemu_efi_firmware_code" {
  type        = string
  default     = "/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd"
  description = "EFI firmware code path"
}
variable "qemu_efi_firmware_vars" {
  type        = string
  default     = "/usr/share/edk2/x64/OVMF_VARS.4m.fd"
  description = "EFI firmware vars file path"
}
variable "qemu_efi_drop_efivars" {
  type        = bool
  default     = true
  description = "Drop EFI vars"
}
variable "qemu_format" {
  type    = string
  default = "qcow2"
  validation {
    condition     = var.qemu_format == "qcow2" || var.qemu_format == "raw"
    error_message = "Disk format, takes qcow2 or raw."
  }
  description = "Disk format, takes qcow2 or raw"
}
variable "qemu_machine_type" {
  type    = string
  default = null
}
variable "qemuargs" {
  type    = list(list(string))
  default = null
}

# Source block common variables
variable "boot_command" {
  type        = list(string)
  default     = null
  description = "Commands to pass to gui session to initiate automated install"
}
variable "default_boot_wait" {
  type    = string
  default = null
}
variable "cd_files" {
  type    = list(string)
  default = null
}
variable "cpus" {
  type    = number
  default = 2
}
variable "cpu_model" {
  type    = string
  default = "host"
}
variable "communicator" {
  type    = string
  default = null
}
variable "disk_size" {
  type    = number
  default = 132096
}
variable "floppy_files" {
  type    = list(string)
  default = null
}
variable "headless" {
  type        = bool
  default     = false
  description = "Start GUI window to interact with VM"
}
variable "http_directory" {
  type    = string
  default = null
}
variable "iso_checksum" {
  type        = string
  default     = null
  description = "ISO download checksum"
}
variable "iso_url" {
  type        = string
  default     = null
  description = "ISO download url"
}
variable "odt_url" {
  type        = string
  default     = null
  description = "ISO download url"
}
variable "memory" {
  type    = number
  default = null
}
variable "output_directory" {
  type    = string
  default = null
}
variable "shutdown_command" {
  type    = string
  default = null
}
variable "shutdown_timeout" {
  type    = string
  default = "15m"
}
variable "ssh_password" {
  type    = string
  default = "vagrant"
}
variable "ssh_port" {
  type    = number
  default = 22
}
variable "ssh_timeout" {
  type    = string
  default = "15m"
}
variable "ssh_username" {
  type    = string
  default = "vagrant"
}
variable "winrm_password" {
  type    = string
  default = "vagrant"
}
variable "winrm_timeout" {
  type    = string
  default = "60m"
}
variable "winrm_username" {
  type    = string
  default = "vagrant"
}
variable "vm_name" {
  type    = string
  default = null
}

# builder common block
variable "scripts" {
  type    = list(string)
  default = null
}
