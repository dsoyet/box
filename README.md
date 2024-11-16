# Box

### Build vagrant box for hyperv and qemu
why use hyperv and libvirt
- better disk performance (500+MBps) for qcow2 and vhdx

### supported os
- Windows
    - 10.0.26100.2448 windows desktop 11  (EN-US ZH-CN)
    - 10.0.26100.2314 windows server 2025 (EN-US ZH-CN)

- Linux
    - archlinux
    - debian
    - nixos
    - mint
    - kali
    - rocky
    - opensuse
    - openeuler
    - kylin
    - freebsd


### Using `packer`

To build latest archlinux box for only the Qemu provider

```bash
packer init -upgrade ./packer_templates
packer build --only=qemu.vm --var-file=os_pkrvars/bootstrap/archlinux.pkrvars.hcl packer_templates
```

To build latest NixOS boxes for Qemu provider

```bash
packer init -upgrade ./packer_templates
packer build --only=qemu.vm --var-file=os_pkrvars/bootstrap/nix.pkrvars.hcl packer_templates
```
To use an alternate url

````bash
packer init -upgrade ./packer_templates
packer build -var 'iso_url=https://mirrors.rit.edu/fedora/fedora/linux/releases/39/Server/x86_64/iso/Fedora-Server-dvd-x86_64-39-1.5.iso' --only=qemu.vm --var-file=os_pkrvars/bootstrap/nix.pkrvars.hcl packer_templates
````

If the build is successful, your box files will be in the `builds` directory at the root of the repository.

### KVM/qemu support for Windows

You must download [the iso image with the Windows drivers for paravirtualized KVM/qemu hardware](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso) and place it in the builds/iso/ directory.
You can do this from the command line: `mkdir -p builds/iso/; wget -nv -nc https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso -O builds/iso/virtio-win.iso`

You can use the following sample command to build a KVM/qemu Windows box:

```bash
packer init -upgrade ./packer_templates
packer build --only=qemu.vm --var-file=os_pkrvars/windows/11.pkrvars.hcl packer_templates
```

```pwsh
New-VMSwitch -Name "hyperv" -AllowManagementOS $True -NetAdapterName "Ethernet Instance 0"
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
git clone https://gitee.com/xanflorp/box.git
cd box
packer init -upgrade ./packer_templates
echo "done"
packer build --only=hyperv-iso.vm --var-file=os_pkrvars/deb/mint.pkrvars.hcl packer_templates
```

```bash
sed -i 's:\\u::g' $HOME/.bashrc
sed -i 's/\(deb\|security\|ftp\).debian.org/mirrors.bfsu.edu.cn/g' /etc/apt/sources.list
sed -i 's/\(archive\|security\).ubuntu.com/mirrors.bfsu.edu.cn/g'  /etc/apt/sources.list

#Ubuntu
cat << 'EOF' > /etc/wsl.conf
[boot]
systemd=true
EOF


RmDHVxkSw5FH7ATx
Django + alpine.js + htmx
$ { sleep 10; ls /; } | nc termbin.com 9999
$ { sleep 10; ls /; } | nc paste.c-net.org 9999
https://paste.c-net.org/ExampleOne

https://search.nixos.org/options

sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo ln -sf ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo systemctl start nix-daemon.service

PROMPT_COLOR="1;31m"; ((UID)) && PROMPT_COLOR="1;32m"; export PS1="\[\033[$PROMPT_COLOR\][@\h:\w]\\$\[\033[0m\] "

nix-channel --add https://mirrors.nju.edu.cn/nix-channels/nixpkgs-unstable nixpkgs
nix-channel --update

nix-env -iA nixpkgs.hello

nix run home-manager/release-24.05 -- init --switch
home-manager switch


substituters = https://mirrors.cernet.edu.cn/nix-channels/store https://cache.nixos.org/

#bsd
sed -i '' 's/#EnableFuseMount=false/EnableFuseMount=false/g' /usr/local/etc/xrdp/sesman.ini
```

### FreeBSD
```sh
https://rockyhotas.github.io/unix/2019/02/27/freebsd-kernel-modules.html
sysctl kern.module_path

#nice FreeBSD tools 
sockstat
gstat
top -b -o res
top -m io -o total
usbconfig
rcorder
beadm/bectl
idprio/rtprio

#lsblk
sudo camcontrol devlist
geom disk list
gpart show
```

```pwsh
Import-Certificate -FilePath "ArchWSL-AppX_24.4.28.0_x64.cer" -CertStoreLocation Cert:\LocalMachine\TrustedPeople -Confirm:$true

winget source remove winget
winget source add winget https://mirrors.cernet.edu.cn/winget-source --trust-level trusted
```

```pwsh
echo "Install PotPlayerSetup64.exe"
Start-Process -FilePath E:\pkg\PotPlayerSetup64.exe -ArgumentList '/S /D=C:\Program Files\PotPlayer' -Wait
Disable proxy for Packer
echo "Install astrill-setup-win.exe"
Start-Process -FilePath E:\pkg\astrill-setup-win.exe -ArgumentList '/VERYSILENT /NOCANCEL /NORESTART /NOICONS /DIR="C:\Program Files (x86)\Proxy"' -Wait
```

### Windows

```powershell
$VS = "Standardswitch"
$IF_ALIAS = (Get-NetAdapter -Name "vEthernet ($VS)").ifAlias
New-NetFirewallRule -Displayname "Allow incomming from $VS" -Direction Inbound -InterfaceAlias $IF_ALIAS -Action Allow
```
