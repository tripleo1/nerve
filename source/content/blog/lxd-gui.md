---
title: "Running GUI applications in LXD on Fedora 26"
date: 2017-09-20T12:28:27+03:00
tags: ["linux", "fedora", "lxd", "containers"]
---

Create container:
```
[iaroki@fedora ~]$ lxc launch images:debian/stretch chrome
```

Install needed tools:
```
[iaroki@fedora ~]$ lxc exec chrome bash
root@chrome:~# adduser iaroki
root@chrome:~# apt update
root@chrome:~# apt install x11-apps mesa-utils alsa-utils
```

Map UID and GID ramges:
```
[iaroki@fedora ~]$ echo "root:1000:1" | sudo tee -a /etc/subuid /etc/subgid
```

Set UID/GUID ranges for container:
```
[iaroki@fedora ~]$ lxc config set chrome raw.idmap "both $UID 1000"
[iaroki@fedora ~]$ lxc restart chrome
```

Mount X11 socket and .Xauthority file:
```
[iaroki@fedora ~]$ lxc config device add chrome X0 disk path=/tmp/.X11-unix/X0 source=/tmp/.X11-unix/X0
[iaroki@fedora ~]$ lxc config device add chrome Xauthority disk path=/home/iaroki/.Xauthority source=${XAUTHORITY}
```
Passthrough GPU device:
```
[iaroki@fedora ~]$ lxc config device add chrome GPU gpu
[iaroki@fedora ~]$ lxc config device set GPU uid 1000
[iaroki@fedora ~]$ lxc config device set GPU gid 1000
```

Check results with:
```
[iaroki@fedora ~]$ lxc exec chrome -- sudo --login --user iaroki
iaroki@chrome:~$ export DISPLAY=:0
iaroki@chrome:~$ echo "export DISPLAY=:0" >> ~/.profile
iaroki@chrome:~$ glxgears
```

Now we can install and run chromium browser inside:
```
[iaroki@fedora ~]$ lxc exec chrome -- sudo --login --user iaroki
iaroki@chrome:~$ sudo apt install chromium
iaroki@chrome:~$ chromium
```

---
