Title: Bridge interface for lxc-containers
Date: 09-12-2015
Category: Linux
Tags: containers, linux, lxc	

Script for creating bridge interface and applying  iptable routing rule:

```
CMD_BRCTL=/sbin/brctl
CMD_IFCONFIG=/sbin/ifconfig
CMD_IPTABLES=/sbin/iptables
CMD_ROUTE=/sbin/route
NETWORK_BRIDGE_DEVICE_NAT=lxc-br0
HOST_NETDEVICE=eth0
PRIVATE_GW_NAT=192.168.0.1
PRIVATE_NETMASK=255.255.255.0

${CMD_BRCTL} addbr ${NETWORK_BRIDGE_DEVICE_NAT}
${CMD_BRCTL} setfd ${NETWORK_BRIDGE_DEVICE_NAT} 0
${CMD_IFCONFIG} ${NETWORK_BRIDGE_DEVICE_NAT} ${PRIVATE_GW_NAT} netmask ${PRIVATE_NETMASK} promisc up
${CMD_IPTABLES} -t nat -A POSTROUTING -o ${HOST_NETDEVICE} -j MASQUERADE
echo 1 > /proc/sys/net/ipv4/ip_forward
```

Edit the container config:

```
# Network configuration
lxc.network.type = veth
lxc.network.flags = up
lxc.network.link = lxc-br0
lxc.network.name = eth0
lxc.network.hwaddr = 00:FF:AA:00:00:01
lxc.network.ipv4 = 192.168.0.2/24
lxc.network.ipv4.gateway = 192.168.0.1
```

Edit the container interfaces:

```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address 192.168.0.2
netmask 255.255.255.0
gateway 192.168.0.1
dns-nameservers 8.8.8.8
```

Enjoy the working network inside your lxc-container!

