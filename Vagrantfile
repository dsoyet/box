Vagrant.configure("2") do |config|
  config.vm.box_check_update = false
  config.ssh.insert_key = false
  config.ssh.forward_agent = true
  config.vm.synced_folder "./", "/vagrant",  SharedFoldersEnableSymlinksCreate: false, disabled: true
  config.vm.provider "libvirt" do |libvirt|
    libvirt.channel :type => 'unix', :target_name => 'org.qemu.guest_agent.0', :target_type => 'virtio'
    libvirt.channel :type => 'spicevmc', :target_name => 'com.redhat.spice.0', :target_type => 'virtio'
    libvirt.management_network_domain = "libvirt.fake"
    libvirt.management_network_name = "libvirt" 
    libvirt.cpu_mode = "host-passthrough"
    libvirt.graphics_type = 'spice'
    libvirt.watchdog :model => 'itco', :action => 'reset'
    libvirt.video_type = 'qxl'
    libvirt.machine_type = 'q35'
    (1..2).each do
      libvirt.redirdev :type => "spicevmc"
    end
    libvirt.usb_controller :model => "qemu-xhci"
    libvirt.cpus = 4
    libvirt.memory = 6144
    libvirt.nested = true
    libvirt.memorybacking :source, :type => 'memfd'
    libvirt.memorybacking :access, :mode => "shared"
  end

  (1..8).each do |i|
    config.vm.define "fake#{i}" do |fake|
      fake.vm.box = "#{ENV.fetch('box','xacklinux/xacklinux')}"
      fake.vm.guest = "windows"
      fake.vm.network :forwarded_port, guest: 3389,   host: "3#{i}89", host_ip: "0.0.0.0"
      fake.vm.provision "shell", inline: <<-SHELL
      chezmoi.exe init --apply https://gitee.com/xanflorp/osfiles.git
      reg import C:\\Users\\vagrant\\Desktop\\NT12.reg 2>&1>$null  
      SHELL
      fake.vm.provider :libvirt do |libvirt|
        libvirt.management_network_mac = "58:54:00:a1:8c:a#{i}"
        libvirt.loader = "/usr/share/OVMF/x64/OVMF_CODE.fd"
      end
    end
  end
end