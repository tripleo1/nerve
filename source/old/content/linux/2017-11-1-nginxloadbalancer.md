Title: Nginx load balancing
Date: 01-11-2017 14:28
Category: Linux
Tags: linux, nginx

Load balancing is a very useful technique to distribute the incoming network traffic across a number servers. With this technique you can reduce the resource usage, lower the response time and avoid server overload.

Nginx Load Balancing is one of the most efficient options available to achieve full application redundancy, and it is relatively easy and quick to setup. We will configure Nginx load balancing using the Round robin mechanism. This way it will forward all requests to the corresponding server included in the Nginx configuration.

Let’s start with the installation and configuration.

Login to your server as user root

```
ssh root@IP_Address
```

and make sure that all packages installed on it are up to date

```
apt-get update && apt-get upgrade
```

We need Nginx web server installed. Run the following command to install Nginx

```
apt-get install nginx
```

Once it is installed, check if the web server is running

```
service nginx status

● nginx.service - A high performance web server and a reverse proxy server
Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
Active: active (running)
```

Now, open your website’s Nginx configuration file with your favorite text editor

```
vim /etc/nginx/sites-available/yourdomain.com.conf
```

and append the load balancing configuration at the top of the file

```
upstream loadbalancer {
server vps1.yourdomain.com;
server vps2.yourdomain.com;
server vps3.yourdomain.com;
}
```

You should have Nginx installed and listening on port 80 on all servers listed above.

Within the same configuration file yourdomain.com.conf we need to add the upstream module in the virtualhost configuration

```
server {
location / {
proxy_pass http://loadbalancer;
}
}
```

Save the file and restart Nginx for the changes to take effect.

```
service nginx restart
```

This configuration will equally distribute all incoming traffic across the three servers (vps1.yourdomain.com, vps2.yourdomain.com, vps3.yourdomain.com). Nginx can be also configured to distribute the traffic more efficiently. It comes with balancing options such as weight balancing, max fails and IP hash balancing.

## Weight Balancing

We can use this option to specify the proportion of the traffic distributed to each of the servers we listed in the upstream.

For example:

```
upstream loadbalancer {
server vps1.yourdomain.com weight=1;
server vps2.yourdomain.com weight=2;
server vps3.yourdomain.com weight=5;
}
```

In this example, vps2.yourdomain.com will receive twice as much traffic compared to vps2.yourdomain.com, and vps3.yourdomain.com will receive five times more traffic than vps1.yourdomain.com.

## Max Fails

If you use the default Nginx settings, it will send data to the servers even if they are down. We can use the Max fails option to prevent such cases.

```
upstream loadbalancer {
server vps1.yourdomain.com max_fails=4  fail_timeout=20s;
server vps2.yourdomain.com weight=2;
server vps3.yourdomain.com weight=4;
}
```

In the example above, Nginx will attempt to connect to vps1.yourdomain.com and if it is not responding for more than 20 seconds it will make another attempt. After four attempts vps1.yourdomain.com will be considered as down.

## IP Hash Balancing

With this method, the visitors will be always sent to the same server. So, if a visitor received the content of vps1.yourdomain.com, it will be always transferred to that server unless the servers are down or inaccessible.

```
upstream loadbalancer {
ip_hash;
server vps1.yourdomain.com;
server vps2.yourdomain.com;
server vps3.yourdomain.com down;
}
```

In this example, vps3.yourdomain.com is known to be inaccessible, and it is marked as down.

