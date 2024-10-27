#!/bin/sh -eux

bento=''

if [ -d /etc/update-motd.d ]; then
    MOTD_CONFIG='/etc/update-motd.d/99-bento'

    cat >> "$MOTD_CONFIG" <<BENTO
#!/bin/sh

cat <<'EOF'
$bento
EOF
BENTO

    chmod 0755 "$MOTD_CONFIG"
else
    touch /etc/motd
    chmod 0777 /etc/motd
    echo "$bento" >> /etc/motd
    chmod 0755 /etc/motd
fi
