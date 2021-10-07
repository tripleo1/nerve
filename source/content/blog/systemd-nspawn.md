+++
title = "Systemd-Nspawn"
date = "2018-10-22T14:13:30Z"
tags = ["linux", "fedora", "containers"]
draft = false
+++

# Setup bridge

Download `netns` tool:

```bash
wget https://github.com/genuinetools/netns/releases/download/v0.5.2/netns-linux-amd64
```

Create bridge:

```bash
sudo netns create --iplink eth0 --bridge br0 --ip 10.10.10.1/24
```

Enable IP Forwarding:

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

_To delete bridge_:

```bash
sudo netns rm --bridge br0
```

# Create container rootfs

For Fedora:

```bash
sudo dnf -y --releasever=28 --installroot=/home/iaroki/workstation --disablerepo='*' --enablerepo=fedora --enablerepo=updates install systemd passwd dnf fedora-release vim git tmux iproute iputils
```

Set root password:

```bash
sudo chroot workstation
passwd
exit
```

Be sure to disable selinux:

```bash
sudo setenforce 0
```

Start container:

```bash
sudo systemd-nspawn -D /home/iaroki/workstation -b --network-bridge br0
```

# Setup network

Login with root and configure network interface:

```bash
[root@workstation ~]# ip addr add 10.10.10.100/24 dev host0
[root@workstation ~]# ip link set host0 up
[root@workstation ~]# ip route add default via 10.10.10.1
[root@workstation ~]# echo nameserver 1.1.1.1 > /etc/resolv.conf
```

Or write systemd network file:
`/etc/systemd/network/20-wired.network`
```ini
[Match]
Name=host0

[Network]
Address=10.10.10.100/24
Gateway=10.10.10.1
DNS=1.1.1.1
```

That's it!

