packer {
  required_version = ">= 1.11.0"
  required_plugins {
    hyperv = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/hyperv"
    }
    qemu = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/qemu"
    }
    vagrant = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/vagrant"
    }
    # windows-update = {
    #   version = ">= 0.14.1"
    #   source  = "github.com/rgl/windows-update"
    # }
  }
}

locals {
  scripts = var.scripts == null ? (
    var.is_windows ? [
      "${path.root}/scripts/windows/defender.ps1",
      "${path.root}/scripts/windows/update.ps1",
      "${path.root}/scripts/windows/pkg.ps1",
      "${path.root}/scripts/windows/rule.ps1",
      "${path.root}/scripts/windows/openssh.ps1",
      ] : (
      var.os_name == "archlinux" ? [
        "${path.root}/scripts/common/archlinux.sh"
        ] : (
        var.os_name == "solaris" ? [
          "${path.root}/scripts/solaris/update_solaris.sh",
          "${path.root}/scripts/common/vagrant.sh",
          "${path.root}/scripts/solaris/minimize_solaris.sh"
          ] : (
          var.os_name == "freebsd" ? [
            "${path.root}/scripts/freebsd/update_freebsd.sh",
            "${path.root}/scripts/common/vagrant.sh",
            "${path.root}/scripts/freebsd/minimize_freebsd.sh"
            ] : (
            var.os_name == "opensuse-leap" ||
            var.os_name == "sles" ? [
              "${path.root}/scripts/suse/update_suse.sh",
              "${path.root}/scripts/common/motd.sh",
              "${path.root}/scripts/common/sshd.sh",
              "${path.root}/scripts/common/minimize.sh"
              ] : (
              var.os_name == "ubuntu" || 
              var.os_name == "black" || 
              var.os_name == "mint" || 
              var.os_name == "xfce4" ||
              var.os_name == "debian" ? [
                "${path.root}/scripts/common/vagrant.sh",
                "${path.root}/scripts/debian/apt.sh",
                "${path.root}/scripts/common/motd.sh",
                "${path.root}/scripts/common/sshd.sh",
                "${path.root}/scripts/common/${var.os_name}.sh",
                "${path.root}/scripts/debian/cleanup.sh",
                "${path.root}/scripts/common/minimize.sh"
                ] : (
                var.os_name == "fedora" ? [
                  "${path.root}/scripts/fedora/networking_fedora.sh",
                  "${path.root}/scripts/common/motd.sh",
                  "${path.root}/scripts/common/minimize.sh"
                  ] : (
                  "${var.os_name}-${var.os_version}" == "amazonlinux-2" ? [
                    "${path.root}/scripts/rhel/update_yum.sh",
                    "${path.root}/scripts/common/motd.sh",
                    "${path.root}/scripts/common/minimize.sh"
                    ] : [
                    "${path.root}/scripts/common/vagrant.sh",
                    "${path.root}/scripts/common/motd.sh",
                    "${path.root}/scripts/common/sshd.sh",
                    "${path.root}/scripts/common/minimize.sh"
                  ]
                )
              )
            )
          )
        )
      )
    )
  ) : var.scripts
  source_names = [for source in var.sources_enabled : trimprefix(source, "source.")]
}

# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = var.sources_enabled

  # Linux Shell scipts
  provisioner "shell" {
    environment_vars = var.os_name == "freebsd" ? [
      "HOME_DIR=/home/vagrant",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "no_proxy=${var.no_proxy}",
      "pkg_branch=quarterly"
      ] : (
      var.os_name == "solaris" ? [] : [
        "HOME_DIR=/home/vagrant",
        "http_proxy=${var.http_proxy}",
        "https_proxy=${var.https_proxy}",
        "no_proxy=${var.no_proxy}"
      ]
    )
    execute_command = var.os_name == "freebsd" ? "echo 'vagrant' | {{.Vars}} su -m root -c 'sh -eux {{.Path}}'" : (
      var.os_name == "solaris" ? "echo 'vagrant'|sudo -S bash {{.Path}}" : "echo 'vagrant' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    )
    expect_disconnect = true
    scripts           = local.scripts
    except            = var.is_windows ? local.source_names : null
  }

  # Windows Updates
  # provisioner "windows-update" {
  #   search_criteria = "IsInstalled=0"
  #   except          = var.is_windows ? null : local.source_names
  # }
  provisioner "powershell" {
    elevated_password = "vagrant"
    elevated_user     = "vagrant"
    scripts           = "${path.root}/scripts/windows/init.ps1"
    except            = var.is_windows ? null : local.source_names
  }
  provisioner "windows-restart" {
    except = var.is_windows ? null : local.source_names
  }
  provisioner "powershell" {
    elevated_password = "vagrant"
    elevated_user     = "vagrant"
    scripts           = local.scripts
    except            = var.is_windows ? null : local.source_names
  }
  provisioner "windows-restart" {
    except = var.is_windows ? null : local.source_names
  }
  post-processor "vagrant" {
    # compression_level = 9
    output = "/usb/phone/box/{{ .Provider }}/${var.os_version}_${upper(var.os_lang)}-${var.os_name}-${var.os_arch}.{{ .Provider }}.box"
    vagrantfile_template = var.is_windows ? "${path.root}/vagrantfile-windows.template" : (
      var.os_name == "freebsd" ? "${path.root}/vagrantfile-freebsd.template" : null
    )
  }
}
