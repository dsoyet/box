source "vmware-iso" "uefi" {
  headless       = var.headless
  boot_wait      = "3s"
  http_directory = local.artifact_directory

  version   = 19
  memory    = 6144
  cpus      = 8
  disk_size = 132096

  vmx_data = {
    "ethernet0.pciSlotNumber" = "32"
    "cpuid.coresPerSocket"    = "1"
    "firmware"                = "efi"
    "sata1.present"           = "TRUE"
    "bios.bootorder"          = ""
    "hgfs.linkrootshare"      = "FALSE"
    "hgfs.maprootshare"       = "FALSE"
    "ulm.disableMitigations"  = "TRUE"
  }
  vmx_data_post = {
    "ide0:0.present" = "FALSE"
    "sata0.present"  = "FALSE"
    "sata1.present"  = "FALSE"
    "ide1:0.present" = "FALSE"
  }
}