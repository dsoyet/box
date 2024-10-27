# Box

### Using `bento` executable

#### build

To build a Debian vagrant box using the bento tool with the template available in the `os_pkrvars` dir, we can use the following command:

```bash
bento build --cpus 2 os_pkrvars/debian/debian-12-x86_64.pkrvars.hcl
```

Other available options:

- cpus - Specify the number of CPUs needed in the new build
- mem - Specify the memory
- config - Use a configuration file other than default builds.yml
- vars - Comma seperated list of variable names equal values (ex: boot_wait="2s",ssh_timeout="5s")
- var_files - Comma seperated list of pkrvar.hcl files to include in the builds (ex: /path/to/var_file.pkrvars.hcl,/path/to/next/var_file2.pkrvars.hcl)
- metadata_only - Only generate the metadata json file
- mirror - The template will have a default mirror link, if you wish to use an alternative one, you can utilise this configuration
- dry-run - This will not create any build, but will create a metadata file for reference
- only - Only build some Packer builds (Default: parallels-iso.vm,virtualbox-iso.vm,vmware-iso.vm
- except - Build all Packer builds except these (ex: parallels-iso.vm,virtualbox-iso.vm,vmware-iso.vm)
- debug - Print the debug logs
- gui - Packer will be building VirtualBox virtual machines by launching a GUI that shows the console of the machine being built. This option is false by default
- single - This can be used to disable the parallel builds

#### list

Used to list all builds available for the workstations cpu architecture. This list is also filtered by the build.yml file do_not_build: section. All entries are matched via regex to filter out build templates from the list.

This only shows what would be built with `bento build` and no template is specified. If any template is specified even if it's in the build.yml to be filtered it'll override the filter.

```bash
bento list
```

#### test

If you have successfully built a vagrant box using the bento tool, you should have the vagrant box and a metadata file in the `builds` folder. You can use these files to test the build with a test-kitchen configuration. Run the following command to test the build.

```bash
bento test
```

#### upload

To upload boxes in the builds directory to your vagrant cloud account update the build.yml file to specify your account name and which OSs are going to be public.

Make sure you have configured the vagrant cli and logged into your account for the upload command to work.

```bash
bento upload
```

When running `bento upload` it'll read each <box_name>._metadata.json file and use the data provided to generate the `vagrant cloud publish` command with the descriptions, version, provider, and checksums all coming from the <box_name>._metadata.json file.

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
packer build --only=qemu.vm -var-file=os_pkrvars/windows/11_EN-US-x86_64.pkrvars.hcl ./packer_templates
```

```pwsh
New-VMSwitch -Name "hyperv" -AllowManagementOS $True -NetAdapterName "Ethernet Instance 0"
packer init -upgrade ./packer_templates
packer build --only=hyperv-iso.vm --var-file=os_pkrvars/deb/black.pkrvars.hcl packer_templates
```

### Windows

```powershell
$VS = "Standardswitch"
$IF_ALIAS = (Get-NetAdapter -Name "vEthernet ($VS)").ifAlias
New-NetFirewallRule -Displayname "Allow incomming from $VS" -Direction Inbound -InterfaceAlias $IF_ALIAS -Action Allow
```
