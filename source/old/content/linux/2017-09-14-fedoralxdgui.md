Title: Running GUI applications in LXD on Fedora 26
Date: 14-09-2017 18:13
Category: Linux
Tags: linux, fedora, lxc, lxd, containers

Create container:
```
[tripleo1@fedora ~]$ lxc launch images:debian/stretch chrome
```

Install needed tools:
```
[tripleo1@fedora ~]$ lxc exec chrome bash
root@chrome:~# adduser tripleo1
root@chrome:~# apt update
root@chrome:~# apt install x11-apps mesa-utils alsa-utils
```

Map UID and GID ramges:
```
[tripleo1@fedora ~]$ echo "root:1000:1" | sudo tee -a /etc/subuid /etc/subgid
```

Set UID/GUID ranges for container:
```
[tripleo1@fedora ~]$ lxc config set chrome raw.idmap "both $UID 1000"
[tripleo1@fedora ~]$ lxc restart chrome
```

Mount X11 socket and .Xauthority file:
```
[tripleo1@fedora ~]$ lxc config device add chrome X0 disk path=/tmp/.X11-unix/X0 source=/tmp/.X11-unix/X0
[tripleo1@fedora ~]$ lxc config device add chrome Xauthority disk path=/home/tripleo1/.Xauthority source=${XAUTHORITY}
```
Passthrough GPU device:
```
[tripleo1@fedora ~]$ lxc config device add chrome GPU gpu
[tripleo1@fedora ~]$ lxc config device set GPU uid 1000
[tripleo1@fedora ~]$ lxc config device set GPU gid 1000
```

Check results with:
```
[tripleo1@fedora ~]$ lxc exec chrome -- sudo --login --user tripleo1
tripleo1@chrome:~$ export DISPLAY=:0
tripleo1@chrome:~$ echo "export DISPLAY=:0" >> ~/.profile
tripleo1@chrome:~$ glxgears
```

Now we can install and run chromium browser inside:
```
[tripleo1@fedora ~]$ lxc exec chrome -- sudo --login --user tripleo1
tripleo1@chrome:~$ sudo apt install chromium
tripleo1@chrome:~$ chromium
```
