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
    ];
  };
  system.stateVersion = "24.05";
  security.sudo.wheelNeedsPassword = false; 
  services.openssh.enable = true;
  services.xserver = {
    enable = true;
    desktopManager = {
      xfce.enable = true;
    };
    displayManager = {
      startx.enable = true;
    };
  };
  services.xrdp = {
    enable = true;
    defaultWindowManager = "xfce4-session";
    openFirewall = true;
    extraConfDirCommands = ''substituteInPlace $out/sesman.ini --replace-fail "#EnableFuseMount=false" "EnableFuseMount=false"'';
  };
  environment.systemPackages = with pkgs; [
    psmisc
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };
  nixpkgs.config.allowUnfree = true;
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
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vagrant = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
  };
}
EOF

cat << 'EOF' > /mnt/etc/nixos/home.nix
{ config, pkgs, ... }:
{
  home.username = "vagrant";
  home.homeDirectory = "/home/vagrant";
  home.packages = with pkgs; [
    btop
    git
    wget
    tree
    chromium
    vscode
    keepassxc
    neofetch
  ];
  home.file.".config/xfce4/terminal/terminalrc".text = ''
[Configuration]
MiscAlwaysShowTabs=FALSE
MiscBell=FALSE
MiscBellUrgent=FALSE
MiscBordersDefault=TRUE
MiscCursorBlinks=FALSE
MiscCursorShape=TERMINAL_CURSOR_SHAPE_BLOCK
MiscDefaultGeometry=80x24
MiscInheritGeometry=FALSE
MiscMenubarDefault=TRUE
MiscMouseAutohide=FALSE
MiscMouseWheelZoom=TRUE
MiscToolbarDefault=FALSE
MiscConfirmClose=TRUE
MiscCycleTabs=TRUE
MiscTabCloseButtons=TRUE
MiscTabCloseMiddleClick=TRUE
MiscTabPosition=GTK_POS_TOP
MiscHighlightUrls=TRUE
MiscMiddleClickOpensUri=FALSE
MiscCopyOnSelect=FALSE
MiscShowRelaunchDialog=TRUE
MiscRewrapOnResize=TRUE
MiscUseShiftArrowsToScroll=FALSE
MiscSlimTabs=FALSE
MiscNewTabAdjacent=FALSE
MiscSearchDialogOpacity=100
MiscShowUnsafePasteDialog=TRUE
MiscRightClickAction=TERMINAL_RIGHT_CLICK_ACTION_CONTEXT_MENU
ScrollingBar=TERMINAL_SCROLLBAR_NONE
  '';
  home.file.".config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml".text = ''
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="configver" type="int" value="2"/>
  <property name="panels" type="array">
    <value type="int" value="1"/>
    <property name="dark-mode" type="bool" value="true"/>
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=8;x=640;y=786"/>
      <property name="length" type="uint" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="icon-size" type="uint" value="32"/>
      <property name="size" type="uint" value="48"/>
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
        <value type="int" value="5"/>
        <value type="int" value="8"/>
        <value type="int" value="11"/>
        <value type="int" value="12"/>
      </property>
    </property>
  </property>
  <property name="plugins" type="empty">
    <property name="plugin-2" type="string" value="tasklist">
      <property name="grouping" type="uint" value="1"/>
      <property name="show-labels" type="bool" value="false"/>
      <property name="show-handle" type="bool" value="true"/>
    </property>
    <property name="plugin-3" type="string" value="separator">
      <property name="expand" type="bool" value="true"/>
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-4" type="string" value="pager">
      <property name="rows" type="uint" value="2"/>
    </property>
    <property name="plugin-5" type="string" value="separator">
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-8" type="string" value="pulseaudio">
      <property name="enable-keyboard-shortcuts" type="bool" value="true"/>
      <property name="show-notifications" type="bool" value="true"/>
    </property>
    <property name="plugin-11" type="string" value="separator">
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-12" type="string" value="clock">
      <property name="digital-layout" type="uint" value="3"/>
      <property name="digital-time-font" type="string" value="Sans 16"/>
    </property>
    <property name="plugin-1" type="string" value="applicationsmenu"/>
  </property>
</channel>
  '';
home.file.".config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml".text = ''
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-terminal" version="1.0">
  <property name="scrolling-bar" type="string" value="TERMINAL_SCROLLBAR_NONE"/>
  <property name="title-mode" type="string" value="TERMINAL_TITLE_HIDE"/>
  <property name="font-use-system" type="bool" value="false"/>
  <property name="misc-menubar-default" type="bool" value="false"/>
  <property name="misc-show-unsafe-paste-dialog" type="bool" value="false"/>
  <property name="misc-default-geometry" type="string" value="80x24"/>
  <property name="background-mode" type="string" value="TERMINAL_BACKGROUND_TRANSPARENT"/>
  <property name="background-darkness" type="double" value="1"/>
  <property name="scrolling-unlimited" type="bool" value="true"/>
  <property name="misc-slim-tabs" type="bool" value="true"/>
  <property name="color-use-theme" type="bool" value="true"/>
  <property name="color-background-vary" type="bool" value="false"/>
  <property name="misc-borders-default" type="bool" value="false"/>
  <property name="color-bold-is-bright" type="bool" value="false"/>
</channel>
  '';
  programs.git = {
    enable = true;
    userName = "Lattice Sum";
    userEmail = "dsoyet@foxmail.com";
  };
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
    shellAliases = {
      exp = "neofetch";
    };
  };
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
EOF

sed -i -e 's/fmask=0022/fmask=0077/g' -e 's/dmask=0022/dmask=0077/g' /mnt/etc/nixos/hardware-configuration.nix

nixos-install --flake /mnt/etc/nixos#nix --no-root-password
reboot

# sudo nixos-rebuild switch --flake /etc/nixos#nix