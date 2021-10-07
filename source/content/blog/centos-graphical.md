---
title: "Enable graphical login in CentOS 7"
date: 2018-01-22T12:53:25+03:00
tags: ["linux", "centos", "systemd"]
---

To start graphic login you need to enable two `systemd` services:

```
$ sudo systemctl enable gdm.service
$ sudo systemctl set-default graphical.target
```

Then reboot and you will see GDM login manager.
If you want disable it, then run:

```
$ sudo systemctl disable gdm.service
$ sudo systemctl set-default multi-user.target
```

Now reboot.

---
