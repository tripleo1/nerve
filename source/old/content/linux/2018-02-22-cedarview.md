Title: Cedarview on Ubuntu 12.04
Date: 22-02-2018 14:34
Category: Linux
Tags: linux, ubuntu, cedarview

First install Ubuntu 12.04 desktop and then fully upgrade system:

```
$ sudo apt-get update
$ sudo apt-get upgrade
```

Install `generic` kernels:

```
$ sudo apt-get install linux-image-generic linux-headers-generic
```

Remove `-pae` kernels:

```
$ sudo apt-get purge linux-image-generic-pae linux-headers-generic-pae
```

Optional grub update:

```
$ sudo update-grub2
```

Optional install gdm

```
$ sudo apt-get install gdm
```

Reboot and install **cedarview** video driver:

```
$ sudo apt-get install cedarview-graphics-drivers cedarview-drm
```

Optional add kernel parameter:
Open `/etc/default/grub` and find `GRUB_CMDLINE_LINUX=""` and add `video=LVDS-1:d`

Update grub and reboot

```
$ sudo update-grub2
$ reboot
```

---
