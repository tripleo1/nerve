---
title: "Vagrant Tips"
date: 2017-10-30T12:37:21+03:00
tags: ["linux", "vagrant"]
---

Some useful tips to work with [Vagrant](https://vagrantup.com):

* Memory and CPU control:

Add `vb.memory` option to `Vagrantfile` to set desired memory capacity:

```ruby
[...]
 config.vm.provider "virtualbox" do |vb| 
   vb.memory = "1024" 
 end
[...]
```

Add `vb.cpus` option to set CPU's:

```ruby
[...]
 config.vm.provider "virtualbox" do |vb| 
  vb.memory = "1024
  vb.cpus = "2"
 end
[...]
```

* Show GUI:

To show GUI for machine:

```ruby
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

```ruby
[...]
config.vm.synced_folder "/storage", "/storage", 
  owner: "user", 
  group: "user"
[...]
```

---
