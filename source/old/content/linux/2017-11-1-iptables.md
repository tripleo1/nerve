Title: Iptables setup
Date: 01-11-2017 13:02
Category: Linux
Tags: linux, network, iptables

With iptables, several different packet matching tables are defined and each table can contain a number of built-in chains as well as some chains defined by the user. The chains are actually lists of rules that match set of packets and each rule specifies what to do with the matched packet.

The default table is the `filter` table and it contains the built-in chains INPUT, FORWARD, and OUTPUT. The INPUT chain is used for packets destined to local sockets, the FORWARD chain is used for packets being routed through the box while the OUTPUT chain is used for locally-generated packets.

Connect to your server via SSH and list the rules defined in a specific chain using the following syntax:

```
sudo iptables -L CHAIN
```

Replace CHAIN with one of the built-in chains to see the defined rules. If no chain is selected, all chains will be listed in the output.

```
sudo iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
```

The firewall rules specify what to do with a certain packet if it matches certain criteria and in case the packet doesn’t match the criteria, the next firewall rule defined in the chain will be examined. This is a very important thing to know when defining the firewall rules because you can easily lock yourself out of your server if you define the rule which accepts packets from your local IP address after the blocking rule.

The targets you can use for the firewall rules are ACCEPT, DROP, QUEUE and RETURN. ACCEPT will let the packet through, DROP will drop the packet, QUEUE will pass the packet to the userspace while RETURN will stop the packet traversing of the current chain and will resume at the next rule in the previous chain. The default chain policy will define what to do with a packet if it doesn’t match certain firewall rule. As you can see in the output of the first command, the default policy for all built-in chains is set to ACCEPT. ACCEPT will let the packet go through so basically there is no protection.

Before adding any specific rules, add the following one:

```
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

This will prevent the connections that are already established to be dropped and your current SSH session will remain active.

Next, add rules to allow traffic on your loopback interface:

```
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT
```

Next, allow access to your server via SSH for your local IP address so only you can access the server:

```
sudo iptables -A INPUT -s 111.111.111.111 -p tcp --dport 22 -j ACCEPT
```

Where `111.111.111.111` is your local IP address and `2` is the listening port of your SSH daemon. In case your local IP address changes dynamically it is best to omit the `-s 111.111.111.111` part and use a different method to protect the SSH service from unwanted traffic.

```
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```

Next, allow access to your important services like HTTP/HTTPS server:

```
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
```

Now, list the current rules and check if everything is OK. For detailed output you can use the following command:

```
sudo iptables -nvL
```

If you have other services that you want to allow access to it is best to do that now. Once you are done, you can set the default policy for the INPUT built-in chain to DROP.

```
sudo iptables -P INPUT DROP
```

This will drop any packet that doesn’t match the firewall rules criteria. The final output should be similar to the following one:

```
Chain INPUT (policy DROP 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate RELATED,ESTABLISHED
    0     0 ACCEPT     all  --  lo     *       0.0.0.0/0            0.0.0.0/0
    0     0 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:22
    0     0 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:80
    0     0 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:443

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
    0     0 ACCEPT     all  --  *      lo      0.0.0.0/0            0.0.0.0/0
```

However, if you now restart the server you will lose all the firewall rules you defined so it is really important to make the rules permanent.

In case you are using an Ubuntu you need to install an additional package for that purpose. Go ahead and install the required package using the following command:

```
sudo apt-get install iptables-persistent
```

On Ubutnu 14.04 you can save and reload the firewall rules using the commands below:

```
sudo /etc/init.d/iptables-persistent save
sudo /etc/init.d/iptables-persistent reload
```

On Ubuntu 16.04 use the following commands instead:

```
sudo netfilter-persistent save
sudo netfilter-persistent reload
```

If you are using a CentOS you can save the firewall rules using the command below:

```
service iptables save
```
