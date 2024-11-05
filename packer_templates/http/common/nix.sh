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

mkfs.ext4 ${ROOT_PARTITION} -L NIXROOT
mkfs.fat -F 32 /dev/${ROOT_DISK}1
fatlabel /dev/${ROOT_DISK}1 NIXBOOT
mount ${ROOT_PARTITION} /mnt
mkdir /mnt/boot
mount /dev/${ROOT_DISK}1 /mnt/boot
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
  programs.bash.promptInit = ''
  
'';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver = {
  #   enable = true;
  #   desktopManager = {
  #     xfce.enable = true;
  #   };
  # };


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vagrant = {
    isNormalUser = true;
    description = "Lattice Sum";
    initialPassword = "vagrant";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
        # Replace with your own public key
        "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
    ];
    packages = with pkgs; [
      tree
    ];
  };
  nix.settings.substituters = [ "https://mirrors.cernet.edu.cn/nix-channels/store" ];
  nix.extraOptions = ''
    experimental-features = nix-command
    '';
  security.sudo.wheelNeedsPassword = false; 

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # services.displayManager.defaultSession = "xfce";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
EOF

nixos-install --no-root-password
reboot