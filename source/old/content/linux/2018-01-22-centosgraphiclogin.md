Title: Enable graphical login in Centos 7
Date: 22-01-2018 12:16
Category: Linux
Tags: linux, centos systemd

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
