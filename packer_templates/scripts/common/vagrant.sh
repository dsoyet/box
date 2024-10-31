#!/bin/sh -eux

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/home/vagrant}";

mkdir -p $HOME_DIR/.ssh;
sed -i 's:\\u::g' $HOME_DIR/.bashrc 
# for rocky and centos
[ -f "/etc/bash.bashrc" ] && sed -i 's:\\u::g' /etc/bash.bashrc
[ -f "/etc/bashrc" ] && sed -i 's:\\u::g' /etc/bashrc

# keylin sshd
test -f "/etc/motd" && truncate -s 0 /etc/motd

if [ -f /etc/ssh/sshd_config ]; then
    sed -i -e 's/AllowTcpForwarding no/AllowTcpForwarding yes/g' -e 's/X11Forwarding no/X11Forwarding yes/g' -e 's/AllowAgentForwarding no/AllowAgentForwarding yes/g' /etc/ssh/sshd_config
fi

# password-less sudo
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/99_vagrant;
chmod 440 /etc/sudoers.d/99_vagrant;

cat <<EOF > $HOME_DIR/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOF

chown -R vagrant "$HOME_DIR"/.ssh;
chmod -R go-rwsx "$HOME_DIR"/.ssh;
