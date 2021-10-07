+++
title = "Centos 7 home router"
date = "2018-10-30T12:01:52Z"
tags = ["linux", "centos"]
draft = false

+++

In this project I build home router based on a Centos 7.
To my server connected two NICs: `enp0s3` and `enp0s8`.
* `enp0s3` - will be WAN
* `enp0s8` - will be LAN

First of all we need to enable IP forwarding:
```
sysctl -w net.ipv4.ip_forward=1
```

Then tweak Firewalld rules:
```
firewall-cmd --set-default-zone=external
firewall-cmd --permanent --zone=internal --add-interface=enp0s8
firewall-cmd --permanent --zone=internal --add-service=dhcp
firewall-cmd --permanent --zone=internal --add-service=dns
firewall-cmd --direct --add-rule ipv4 nat POSTROUTING 0 -o eth_ext -j MASQUERADE
firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -i eth_int -o eth_ext -j ACCEPT
firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -i eth_ext -o eth_int -m state --state RELATED,ESTABLISHED -j ACCEPT
```

Install DHCP:
```
yum -y install dhcp
vi /etc/dhcp/dhcpd.conf
```
And edit dhcp configuration file:
```
# DHCP Server Configuration file.
#   see /usr/share/doc/dhcp*/dhcpd.conf.example
#   see dhcpd.conf(5) man page
#

option domain-name "iaroki.io"; 
option domain-name-servers 10.0.0.1;
default-lease-time 600; 
max-lease-time 7200; 
authoritative; 

subnet 10.0.0.0 netmask 255.255.255.0 { 
  range 10.0.0.100 10.0.0.254; 
  option broadcast-address 10.0.0.255; 
  option routers 10.0.0.1;
  option interface-mtu 1500; 
}

#host nas { 
#  option host-name "nas.iaroki.io"; 
#  hardware ethernet f0:9f:c2:1f:c1:12; 
#  fixed-address 10.0.0.2; 
#}
```

Now enable and start your DHCP server:
```
systemctl start dhcpd
systemctl enable dhcpd
```

Install DNS server:
```
yum -y install bind-chroot bind-utils
```

Configure `/etc/named.conf`:
```
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//
// See the BIND Administrator's Reference Manual (ARM) for details about the
// configuration located in /usr/share/doc/bind-{version}/Bv9ARM.html

options {
	listen-on port 53 { 10.0.0.1; };
	listen-on-v6 port 53 { none; };
	directory 	"/var/named";
	dump-file 	"/var/named/data/cache_dump.db";
	statistics-file "/var/named/data/named_stats.txt";
	memstatistics-file "/var/named/data/named_mem_stats.txt";
	allow-query     { 10.0.0.0/24; };
	recursion yes;
	forwarders {1.1.1.1; 1.0.0.1; };
	dnssec-enable yes;
	dnssec-validation yes;

	/* Path to ISC DLV key */
	bindkeys-file "/etc/named.iscdlv.key";

	managed-keys-directory "/var/named/dynamic";

	pid-file "/run/named/named.pid";
	session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
	type hint;
	file "named.ca";
};

zone "iaroki.io" IN {
	type master;
	file "iaroki.io.zone";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
```

Then create `/var/named/iaroki.io.zone` file:
```
$TTL 86400 
@ IN SOA gw.iaroki.io. root.iaroki.io. ( 
  2018103001	;Serial  
  3600		;Refresh 
  1800		;Retry 
  604800	;Expire 
  86400 )	;Minimum TTL

		IN NS		gw.iaroki.io. 
		IN A		10.0.0.1
gw		IN A		10.0.0.1
nas		IN A		10.0.0.2
```

Now enable and start your DNS server:
```
systemctl start named
systemctl enable named
```

Configured server will send DHCP broadcast in 10.0.0.0 subnet with caching DNS server.
