#!/bin/sh -eux

CONFIG_SCRIPT='/mnt/etc/nixos/configuration.nix'
if [ -b /dev/vda ]; then
  ROOT_DISK='vda'
  PKGS='base linux openssh sudo'
fi
if [ -b /dev/sda ]; then
  ROOT_DISK='sda'
  PKGS='base linux openssh sudo hyperv'
fi

ROOT_PARTITION="/dev/${ROOT_DISK}2"

# Partition and format disk
parted "/dev/${ROOT_DISK}" ---pretend-input-tty <<EOF
mktable gpt
mkpart ESP fat32 0% 5%
mkpart primary 5% 95%
mkpart primary linux-swap 95% 100%
set 1 esp on
quit
EOF

mkfs.ext4 ${ROOT_PARTITION}
mkfs.fat -F 32 /dev/${ROOT_DISK}1
mount ${ROOT_PARTITION} /mnt
mkdir /mnt/boot
mount -o fmask=0077,dmask=0077 /dev/${ROOT_DISK}1 /mnt/boot
mkswap -L swap /dev/${ROOT_DISK}3
swapon /dev/${ROOT_DISK}3

nixos-generate-config --root /mnt

# Installation
cat << 'EOF' > ${CONFIG_SCRIPT}
{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader = {
	  systemd-boot.enable = true;
	  efi.canTouchEfiVariables = true;
	  timeout = 1; 
  };
  networking.hostName = "nix";
  time.timeZone = "Asia/Shanghai";
  programs.direnv.enable = true;
  programs.bash.promptInit = ''
  PROMPT_COLOR="1;31m"; ((UID)) && PROMPT_COLOR="1;32m"; export PS1="\[\033[$PROMPT_COLOR\][\h:\w]\\$\[\033[0m\] "
  '';
  users.users.vagrant = {
    isNormalUser = true;
    description = "Lattice Sum";
    initialPassword = "vagrant";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
    ];
    packages = with pkgs; [
      tree
    ];
  };
  system.stateVersion = "24.05";
  security.sudo.wheelNeedsPassword = false; 
  services.openssh.enable = true;
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];
  environment.variables.EDITOR = "vim";
  nix = {
    package = pkgs.nixFlakes;
    settings = {
      substituters = [ "https://mirrors.cernet.edu.cn/nix-channels/store" ];
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
   };
  };
}
EOF

cat << 'EOF' > /mnt/etc/nixos/flake.nix
{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
}
EOF

sed -i -e 's/fmask=0022/fmask=0077/g' -e 's/dmask=0022/dmask=0077/g' /mnt/etc/nixos/hardware-configuration.nix

nixos-install --flake /mnt/etc/nixos#nix --no-root-password
# reboot