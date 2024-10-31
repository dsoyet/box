# Box

### Using `packer`

To build a Ubuntu 22.04 box for only the VirtualBox provider

```bash
cd <path/to>/bento
packer init -upgrade ./packer_templates
packer build -only=virtualbox-iso.vm -var-file=os_pkrvars/ubuntu/ubuntu-22.04-x86_64.pkrvars.hcl ./packer_templates
```

To build latest Debian 12 boxes for all possible providers (simultaneously)

```bash
cd <path/to>/bento
packer init -upgrade ./packer_templates
packer build -var-file=os_pkrvars/debian/debian-12-x86_64.pkrvars.hcl ./packer_templates
```

To build latest CentOS 7 boxes for all providers except VMware and Parallels

```bash
cd <path/to>/bento
packer init -upgrade ./packer_templates
packer build -except=parallels-iso.vm,vmware-iso.vm -var-file=os_pkrvars/centos/centos-7-x86_64.pkrvars.hcl ./packer_templates
```

To use an alternate url

````bash
cd <path/to>/bento
packer init -upgrade ./packer_templates
packer build -var 'iso_url=https://mirrors.rit.edu/fedora/fedora/linux/releases/39/Server/x86_64/iso/Fedora-Server-dvd-x86_64-39-1.5.iso' -var-file=os_pkrvars/fedora/fedora-39-x86_64.pkrvars.hcl ./packer_templates
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
