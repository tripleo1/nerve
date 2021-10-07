---
title: "Archlinux on LUKS"
date: 2017-03-16T12:20:55+03:00
tags: ["linux", "lvm", "luks"]
---

After live cd is loaded you need to setup network connection.
For ethernet follow the next steps:

```bash
ip link set eth0 up #set interface up
ip addr add 10.69.0.100/24 broadcast 10.69.0.255 dev eth0 #set ip address
ip route add default via 10.69.0.1 #set gateway
```

Setting gateway in the example above may fail. If so, you can try next commands:

```bash
ip route add 10.69.0.1 dev eth0
ip route add default via 10.69.0.1 dev eth0
```
It is good to set right time now:

```bash
timedatectl set-ntp true
```

Next step is to prepare our filesystems. We will be using LVM on LUKS.
For `/boot` i am using partition on my USB flash drive `/dev/sdb1` formatted to `ext2`.
Encrypted partition with LUKS is `/dev/sda1`, you may choose whatever you want.

So lets create LUKS encrypted partition:

```bash
cryptsetup -v --cipher aes-xts-plain64 --key-size 512 --hash sha512 luksFormat /dev/sda1
```

You need to enter secure password in prompt, so choose wisely. Now open our partition:

```bash
cryptsetup luksOpen /dev/sda1 lvm
```
We opened encrypted partition `/dev/sda1` as `lvm` name and it is now available at `/dev/mapper/lvm`.
To create LVM follow the next steps:

```bash
pvcreate /dev/mapper/lvm #create physical volume
vgcreate ArchVol /dev/mapper/lvm #create volume group named ArchVol
lvcreate -L 4G ArchVol -n swap #in ArchVol create 4GB partition named swap
lvcreate -l 100%FREE ArchVol -n root #in ArchVol create partition named root filled all remaining space
```

After this time to format our new logical partitions:
* _root_ available at `/dev/mapper/ArchVol-root`
* _swap_ available at `/dev/mapper/ArchVol-swap`
* _boot_ is my USB flash drive at `/dev/sdb1`

```bash
mkfs.ext4 /dev/mapper/ArchVol-root
mkswap /dev/mapper/ArchVol-swap
mkfs.ext2 /dev/sdb1
```

Mount aour filesystems and activate swap:

```bash
mount /dev/mapper/ArchVol-root /mnt
mkdir /mnt/boot
mount /dev/sdb1 /mnt/boot
swapon /dev/mapper/ArchVol-swap
```

Okay,  now __exact__ Arch installation:

```bash
pacstrap /mnt base
```

This bootstraps base system. To generate our `/etc/fstab` accordingly to mountpoints:

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Now lets chroot to our system:

```bash
arch-chroot /mnt
```

Inside we need to set proper timezone and time:

```bash
ln -s /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
```

To setup locales just select and generate them:

```bash
nano /etc/locale.gen
locale-gen
/etc/locale.conf LANG=en_US.UTF-8
```

Fill the hostname:

```bash
nano /etc/hostname
nano /etc/hosts
```

Arch Linux has many available ways to configure network. So i am using `systemd-networkd`.
For wired ethernet connection create the next config `/etc/systemd/network/wired.network`:

```ini
[Match]
Name = eth0

[Network]
Address = 10.69.0.100/24
Gateway = 10.69.0.1
DNS = 8.8.8.8
```

We are almost done. The few things which are left is generating `initramfs image` and installing bootloader.
Our `initramfs image` must be configured with extra features such as `lvm` and `encrypt`.
Edit configuration file `/etc/mkinitcpio.conf`:
```ini
HOOKS="...  encrypt  lvm2  ...  filesystems  ..."
MODULES="i915"  #if you use intel graphics
```

Generate `initramfs`:
`mkinitcpio -p linux`

Set `root` password:
`passwd root`

Install and configure bootloader:

```bash
pacman -S grub
```

Next you need to add your encrypted partition UUID to `grub` config. You can get it by running next command:

```bash
blkid /dev/sda1

# example output
/dev/sda1: UUID="cddd0a60-8281-4a09-8cce-1c5cb8849f62" TYPE="crypto_LUKS" PARTUUID="61979b00-998a-409d-aeb1-08e50f45023c"
```

Note the __UUID__ part. Add it to `/etc/default/grub`:

```
GRUB_CMDLINE_LINUX_DEFAULT="cryptdevice=UUID=cddd0a60-8281-4a09-8cce-1c5cb8849f62:lvm"
```

Install bootloader to MBR of our USB flash drive and generate config:

```bash
grub-install --target=i386-pc /dev/sdb1
grub-mkconfig -o /boot/grub/grub.cfg
```

At this point we have everything done. Time to unmount our partitions and reboot.

```bash
exit
umount /mnt/boot
umount /mnt
swapoff /dev/mapper/ArchVol-swap
reboot
```

Congratulations! Enjoy your fresh Arch Linux system on encrypted partition and boot USB flash drive as a key!

---
