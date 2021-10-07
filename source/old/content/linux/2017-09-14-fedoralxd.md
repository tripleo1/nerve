Title: LXD installation on Fedora 26
Date: 14-09-2017 12:23
Category: Linux
Tags: linux, fedora, lxc, lxd, containers

LXD is not working with enabled SELinux so we need to disable it with comand:
```
[root@fedora ~]# setenforce permissive
```

Enable `ganto` repository to download neded packages:
```
[root@fedora ~]# dnf copr enable ganto/lxd
```

Now time to install LXD:
```
[root@fedora ~]# dnf install lxd lxd-client lxd-tools
```

In order to run lxc tools our user need to be in a `lxd` group, so add it:
```
[root@fedora ~]# usermod -aG lxd iaroki
```

Set sub{u,g}id's range for containeraized `root` user:
```
[root@fedora ~]# echo "root:1000000:65536" >> /etc/subuid
[root@fedora ~]# echo "root:1000000:65536" >> /etc/subgid
```

Enable and start LXD daemon:
```
[root@fedora ~]# systemctl enable lxd.service
[root@fedora ~]# systemctl start lxd.service
```

Finally run LXD initialization:
```
[root@fedora ~]# lxd init
```

And now as a normal user (`iaroki` in my case) start container:
```
[iaroki@fedora ~]$ lxc launch images:debian/stretch mydebian
[iaroki@fedora ~]$ lxc exec mydebian bash
root@mydebian:~#
```

Enjoy LXD!

---
[Running GUI apps in LXD](fedoralxdgui.md)
