Title: Vagrant tips
Date: 30-10-2017 14:02
Category: Linux
Tags: linux, vagrant

Some useful tips to work with [Vagrant](https://vagrantup.com):

* Memory and CPU control:

Add `vb.memory` option to `Vagrantfile` to set desired memory capacity:

```
[...]
 config.vm.provider "virtualbox" do |vb| 
   vb.memory = "1024" 
 end
[...]
```

Add `vb.cpus` option to set CPU's:

```
[...]
 config.vm.provider "virtualbox" do |vb| 
  vb.memory = "1024
  vb.cpus = "2"
 end
[...]
```

* Show GUI:

To show GUI for machine:

```
[...]
 config.vm.provider "virtualbox" do |vb| 
  # Display the VirtualBox GUI when booting the machine 
  vb.gui = true  
  # Customize the amount of memory on the VM: 
  vb.memory = "1024" 
 end
[...]
```

* Synced folders:

If you want to add synced folders add:

```
[...]
config.vm.synced_folder "/storage", "/storage", 
  owner: "user", 
  group: "user"
[...]
```
