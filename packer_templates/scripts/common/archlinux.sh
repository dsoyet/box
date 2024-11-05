#!/bin/sh -eux

CONFIG_SCRIPT='/usr/local/bin/arch-config.sh'
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

mkfs.btrfs ${ROOT_PARTITION} 
mkfs.fat -F 32 /dev/${ROOT_DISK}1
mount ${ROOT_PARTITION} /mnt
mkdir /mnt/efi
mount /dev/${ROOT_DISK}1 /mnt/efi

# Installation
cat << 'EOF' > /etc/pacman.d/mirrorlist
# Server
Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
EOF

mkdir -p /mnt/efi/EFI/Boot /mnt/etc/mkinitcpio.d /mnt/etc/kernel /mnt/etc/systemd/network
cat << 'EOF' > /mnt/etc/mkinitcpio.d/linux.preset
ALL_kver="$(ls /usr/lib/modules/*/vmlinuz)"
PRESETS=('default')
default_uki="/efi/EFI/Boot/bootx64.efi"
default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"
EOF

echo "root=${ROOT_PARTITION}" >> /mnt/etc/kernel/cmdline

cat << 'EOF' > /mnt/etc/systemd/network/20-wired.network
[Match]
Name=e*

[Network]
DHCP=yes
EOF

pacstrap /mnt ${PKGS}

# Config
install --mode=0755 /dev/null "/mnt${CONFIG_SCRIPT}"
genfstab -U /mnt >> /mnt/etc/fstab
cat <<-EOF > "/mnt${CONFIG_SCRIPT}"
  echo 'arch' > /etc/hostname
  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
  locale-gen

  echo 'root:root' | chpasswd

  # ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
  # systemctl enable dhcpcd@eth0.service systemd-resolved.service

  systemctl enable systemd-networkd.service systemd-resolved.service

  sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
  systemctl enable sshd #rngd vmtoolsd rpcbind
  if [ -f /usr/lib/systemd/system/hv_kvp_daemon.service ]; then
    systemctl enable hv_kvp_daemon.service hv_vss_daemon.service
  fi

  useradd --create-home --user-group vagrant
  echo 'vagrant:vagrant' | chpasswd
  echo "export PS1='[\\h \\W]\\$ '" >> $HOME_DIR/.bashrc

  mkdir -p $HOME_DIR/.ssh
  chown -R vagrant $HOME_DIR/.ssh
  chmod -R go-rwsx $HOME_DIR/.ssh
  
  pacman -Scc --noconfirm
  
  #grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
  #grub-mkconfig -o /boot/grub/grub.cfg
  #cp -r /boot/EFI/GRUB /boot/EFI/BOOT
  #mv /boot/EFI/BOOT/grubx64.efi /boot/EFI/BOOT/bootx64.efi
EOF
arch-chroot /mnt ${CONFIG_SCRIPT}

cat << 'EOF' > /mnt/etc/sudoers.d/64_vagrant
Defaults env_keep += "SSH_AUTH_SOCK"
vagrant ALL=(ALL) NOPASSWD: ALL
EOF

cat << 'EOF' > /mnt/etc/pacman.d/mirrorlist
# Server
Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
EOF

export HOME_DIR=/mnt/home/vagrant

cat << 'EOF' > $HOME_DIR/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOF

chown -R vagrant $HOME_DIR/.ssh;
chmod -R go-rwsx $HOME_DIR/.ssh;

ln -sf ../run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf

echo 'PROMPT_COLOR="1;31m"; ((UID)) && PROMPT_COLOR="1;32m"; export PS1="\[\033[$PROMPT_COLOR\][\h:\w]\\$\[\033[0m\] "' >> /mnt/etc/bash.bashrc

# clean
rm -rf /mnt/var/cache
rm -rf /mnt/var/log
