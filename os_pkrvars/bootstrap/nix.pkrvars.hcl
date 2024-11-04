os_name                 = "nix"
os_version              = "24"
os_arch                 = "x86_64"
iso_urls                = ["/osx/Users/Share/Phone/nixos-minimal-x86_64-linux.iso", "https://mirror.nju.edu.cn/nixos-images/nixos-24.05/latest-nixos-minimal-x86_64-linux.iso", ]
iso_checksum            = "sha256:bc686b9cee15a8ed5b66350dd4710cbb3435884cc5201475fb4702af7a31d8f8"
boot_command            = ["<enter><wait10>sudo -i<enter>curl http://{{ .HTTPIP }}:{{ .HTTPPort }}/common/nix.sh | sh<enter><enter><enter><enter>"]