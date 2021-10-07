+++
title = "Vagrant with libvirt provider"
date = "2018-11-21T14:24:45Z"
draft = false

+++

To make it work you need to install `vagrant` and `vagrant-libvirt` plugin and run with `vagrant up --provider=libvirt`.
But in my case it was stuck on message `Determining domain IP address...`.
The actual problem was not in the networking but with qemu-kvm in which I get kernel panic related to cpu.

Solution is to set in the config parameter `cpu_mode=host-passthrough`.

Here is my example `Vagrantfile`:

```
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.hostname = "homeserver"
  # config.vm.box_check_update = false
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.provider :libvirt do |libvirt|
    libvirt.cpu_mode="host-passthrough"
    libvirt.cpus = 1
    libvirt.memory = 512
    libvirt.nested = true
  end
  config.vm.provision "docker"
end
```

Now everything works!
