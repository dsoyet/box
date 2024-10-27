os_name                 = "archlinux"
os_version              = "2024"
os_arch                 = "x86_64"
iso_url                 = "https://mirrors.nju.edu.cn/archlinux/iso/latest/archlinux-x86_64.iso"
iso_checksum            = "file:https://mirrors.nju.edu.cn/archlinux/iso/latest/sha256sums.txt"
boot_command            = ["<enter><wait10><wait5>useradd -m vagrant<enter>echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/99_vagrant;<enter>echo 'vagrant:vagrant'|chpasswd<enter>"]
