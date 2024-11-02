DISTRIBUTIONS="base.txz kernel.txz"

export nonInteractive="YES"
export ZFSBOOT_DISKS="vtbd0"
export ZFSBOOT_CONFIRM_LAYOUT=0
# PARTITIONS="vtbd0 gpt {	125G freebsd-ufs /, 2G freebsd-swap }"

HOSTNAME=freebsd

#!/bin/sh -x

ifdev=$(ifconfig | grep '^[a-z]' | cut -d: -f1 | head -n 1)
# Enable required services
cat >> /etc/rc.conf << EOT
ifconfig_${ifdev}="DHCP -rxcsum"
sshd_enable="YES"
hostname="freebsd"
EOT

# Tune and boot from zfs
cat >> /boot/loader.conf << EOT
vm.kmem_size="200M"
vm.kmem_size_max="200M"
vfs.zfs.arc_max="40M"
vfs.zfs.vdev.cache.size="5M"
autoboot_delay=1
EOT

echo "proc                    /proc   procfs  rw              0       0" >> /etc/fstab

# Since FreeBSD 14.0 bsdinstall again creates dataset for /home rather then /usr/home
# Thus on versions prior to 14.0 we have to create /home -> /usr/home symlink,
# otherwise just use /home as the base for vagrant's home
version=$(freebsd-version -u)
if [ "${version%%.*}" -lt "14" ]; then
   home_base="/usr/home"
   ln -s $home_base /home
else
   home_base="/home"
fi

# Set up user accounts
echo "vagrant" | pw -V /etc useradd vagrant -h 0 -s /bin/sh -G wheel -d ${home_base}/vagrant -c "Lattice Sum"
echo "vagrant" | pw -V /etc usermod root

mkdir -p ${home_base}/vagrant
chown 1001:1001 ${home_base}/vagrant

efibootmgr -n -b 0002
reboot