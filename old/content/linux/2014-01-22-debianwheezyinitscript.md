Title: Adding autostart script to Debian Wheezy
Date: 22-01-2014 15:33
Category: Linux
Tags: linux, debian

Create your script:

```
mkdir /tmp/spaghetti && touch /tmp/spaghetti/meatballs.txt
```

Make the script executable:

```
root@wheezy ~ # chmod +x spaghetti.sh
```

Add your script to `/etc/init.d`:

```
root@wheezy ~ # mv spaghetti.sh /etc/init.d
```

Run `update-rc.d` on the new script:

```
root@wheezy ~ # update-rc.d spaghetti.sh defaults
```

