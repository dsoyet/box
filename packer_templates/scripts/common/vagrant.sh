#!/bin/sh -eux

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/home/vagrant}";
[ -f "/etc/os-release" ] && . /etc/os-release 

mkdir -p $HOME_DIR/.ssh;
if [ -f $HOME_DIR/.bashrc ]; then
    sed -i 's:\\u::g' $HOME_DIR/.bashrc 
    echo "PS1='[\h \W]\$ '" >> $HOME_DIR/.bashrc 
fi
# for rocky and centos
[ -f "/etc/bash.bashrc" ] && sed -i 's:\\u::g' /etc/bash.bashrc
[ -f "/etc/bashrc" ] && sed -i 's:\\u::g' /etc/bashrc

# kylin sshd
test -f "/etc/motd" && truncate -s 0 /etc/motd

case $ID in
  kylin)
    sed -i -e 's/AllowTcpForwarding no/AllowTcpForwarding yes/g' -e 's/X11Forwarding no/X11Forwarding yes/g' -e 's/AllowAgentForwarding no/AllowAgentForwarding yes/g' /etc/ssh/sshd_config
    ;;
  freebsd | solaris)
    echo "PS1='[\h \W]\$ '" >> $HOME_DIR/.bashrc
    chown -R vagrant "$HOME_DIR"/.bashrc;
    ;;
esac

# password-less sudo
if [ -d "/etc/sudoers.d" ]; then
    echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/64_vagrant;
    chmod 440 /etc/sudoers.d/64_vagrant;
fi

# freebsd
if [ -d "/usr/local/etc/sudoers.d" ]; then
    echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >/usr/local/etc/sudoers.d/64_vagrant;
    chmod 440 /usr/local/etc/sudoers.d/64_vagrant;
fi

cat <<EOF > $HOME_DIR/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOF

chown -R vagrant "$HOME_DIR"/.ssh;
chmod -R go-rwsx "$HOME_DIR"/.ssh;
