Title: Tor hidden service
Date: 16-09-2017 14:43
Category: Linux
Tags: linux, fedora, ssh, tor, nginx

As for Fedora install `tor` package, `nginx` web service and SSH server for remote control:
```
[root@hiddensrv ~]# dnf install tor nginx openssh-server
```
Now change defaultSSH port and disable root login:
```
[root@hiddensrv ~]# vim /etc/ssh/sshd_config

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
Port 2222
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

# Authentication:

#LoginGraceTime 2m
PermitRootLogin no
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10
```

Enable and start SSH service:
```
[root@hiddensrv ~]# systemctl enable sshd
[root@hiddensrv ~]# systemctl start sshd
```

Edit TOR configuration file to uncomment next strings:
```
[root@hiddensrv ~]# vim /etc/tor/torrc

############### This section is just for location-hidden services ###

## Once you have configured a hidden service, you can look at the
## contents of the file ".../hidden_service/hostname" for the address
## to tell people.
##
## HiddenServicePort x y:z says to redirect requests on port x to the
## address y:z.

HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServicePort 80 127.0.0.1:80
HiddenServicePort 2222 127.0.0.1:2222
```

Enable and start TOR and NGINX services:
```
[root@hiddensrv ~]# systemctl enable nginx
[root@hiddensrv ~]# systemctl start nginx
[root@hiddensrv ~]# systemctl enable tor
[root@hiddensrv ~]# systemctl start tor
```

Now you can check generated hostname of your service to access:
```
[root@hiddensrv ~]# cat /var/lib/tor/hidden_service/hostname
v63z5ihn6uxx3kwf.onion
```

There you can see default NGINX index page.
But to access SSH you need to add settings on yor laptop:
```
user@laptop:~$ vim ~/.ssh/config

host hidden
    hostname v63z5ihn6uxx3kwf.onion
    port 2222
    user prouser
    proxyCommand ncat --proxy 127.0.0.1:9050 --proxy-type socks5 %h %p
```

If you encounter problems with `ncat` command you can try `nc -xlocalhost:9150 -X5 %h %p`.

Try to access:
```
user@laptop:~$ ssh hidden
hidden's password:
prouser@hiddensrv:~$
```
