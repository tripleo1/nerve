---
title: "Voidlinux LXD image"
date: 2018-10-11T09:34:49Z
tags: ["linux", "containers", "lxd"]
---

# Create image

To make it work you need to bootstrap rootfs with void, write simple metadata file and add all this into a compressed tarball.
So then you should import it to LXD.

Create void rootfs like this:

```bash
IMAGE="rootfs"
sudo mkdir -v ${IMAGE}
sudo xbps-install -y -r ${PWD}/${IMAGE} --repository=http://repo.voidlinux.eu/current -S base-voidstrap
sudo rm -rf ${PWD}/${IMAGE}/usr/share/doc ${PWD}/${IMAGE}/usr/share/man ${PWD}/${IMAGE}/var/cache/xbps
```

Then create `metadata.yaml` with similiar content:

```yaml
architecture: x86_64
creation_date: 1532507327
properties:
  description: Void Linux glibc 64bit
  os: Void Linux
  release: rolling
```

Add all this to compressed tarball: `tar cJf voidlinux-lxd-image.tar.xz metadata.yaml rootfs`
Now you can import and run Void containers from your image:

```bash
[vagrant@voidlinux ~]$ lxc image import voidlinux-lxd-image.tar.xz --alias void
Image imported with fingerprint: 8730dddda4d5774336995018dc3e0af664fdbd9e42a30699be864e4de6835b74
[vagrant@voidlinux ~]$ lxc image list
+-------+--------------+--------+------------------------+--------+---------+------------------------------+
| ALIAS | FINGERPRINT  | PUBLIC |      DESCRIPTION       |  ARCH  |  SIZE   |         UPLOAD DATE          |
+-------+--------------+--------+------------------------+--------+---------+------------------------------+
| void  | 8730dddda4d5 | no     | Void Linux glibc 64bit | x86_64 | 34.37MB | Jul 25, 2018 at 8:36am (UTC) |
+-------+--------------+--------+------------------------+--------+---------+------------------------------+
[vagrant@voidlinux ~]$ lxc launch void voidlxd
Creating voidlxd
Starting voidlxd
[vagrant@voidlinux ~]$ lxc ls
+---------+---------+------+------+------------+-----------+
|  NAME   |  STATE  | IPV4 | IPV6 |    TYPE    | SNAPSHOTS |
+---------+---------+------+------+------------+-----------+
| voidlxd | RUNNING |      |      | PERSISTENT | 0         |
+---------+---------+------+------+------------+-----------+
[vagrant@voidlinux ~]$ lxc exec voidlxd bash
bash-4.4# poweroff
bash-4.4# exit
[vagrant@voidlinux ~]$
```

# Make network working

* In running container from your image you need to start `dhcpcd-eth0` service:

```bash
ln -s /etc/sv/dhcpcd-eth0 /var/service
```

* Or before compressing tarball image just chroot into rootfs and enable it like this:

```bash
ln -s /etc/sv/dhcpcd-eth0 /etc/runit/runsvdir/default/dhcpcd-eth0
```

You can automate this with simple script. Then create tarball, import it and launch container.

Here is the example:
[![asciicast](https://asciinema.org/a/nztoChkNK2ROiQ8IPiLVsD68D.png)](https://asciinema.org/a/nztoChkNK2ROiQ8IPiLVsD68D)

---
