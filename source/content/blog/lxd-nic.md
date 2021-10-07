---
title: "LXD container with second network interface"
date: 2018-09-20T07:58:56Z
tags: ["linux", "containers", "lxd"]
---



# Adding secondary NIC to LXD container

Create container in stopped state:

```bash
lxc init images:alpine/edge server
```

Then add NIC:

```bash
lxc config device add server eth1 nic nictype=bridged parent=docker0
```

Start container and login inside:

```bash
lxc start server
lxc exec server sh
```

You will see that yo have now two network interfaces.
Set an IP address to it:

```bash
ip link set eth1 up
ip addr add 172.17.0.200/24 broadcast 172.17.0.255 dev eth1
```

---
