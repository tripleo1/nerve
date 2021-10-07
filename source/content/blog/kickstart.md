---
title: "CentOS 7 kickstart installation"
date: 2018-06-07T12:55:02+03:00
tags: ["linux", "centos", "fedora", "rhel", "kickstart"]
---

I have generated kickstart file located on my pc and to make it available over local network I just start python server:

```
[iaroki@workstation ~]$ python -m http.server
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...
```

Now my kickstart config located at `http://10.69.0.202:8000/ks.cfg`.

On another pc or vm I load installation media and in main menu hit `Esc`.
To tell installer where ks.cfg is I must declare it and as it available on network I must assign IP address too:

```
boot: linux inst.ip=10.69.0.210 inst.ks=http://10.69.0.202:8000/ks.cfg
```

After this Anaconda installer will fetch and install system following this kickstart config.

---
