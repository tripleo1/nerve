Title: Backup LXC containers 
Date: 20-10-2016 13:44
Category: Linux
Tags: linux, lxc, containers, backup

## Moving LXC containers between host systems
This is how migrate LXC containers between systems:
* Shutdown the container

```
# lxc-stop -n $NAME
```

* Archive container rootfs & config

```
# cd /var/lib/lxc/$NAME/
# tar --numeric-owner -czvf container_fs.tar.gz ./*
```

The `--numeric-owner` flag is very important! Without it, the container may not boot because the `uid/gids` get mangled in the extracted filesystem. When tar creates an archive, it preserves user / group ownership information. By default, when extracting, tar tries to resolve the archive user/group ownership names with the ids on the system running tar. This is intended to ensure that user ownership is resolved on the new system, in case the UID numeric values differ between systems.

This is bad for an LXC filesystem because the numeric uid/gid ownership is intended to be preserved for the whole filesystem. If it gets resolved to a different value, bad things happen.

* Copy the file to your new server

```
# rsync -avh container_fs.tar.gz user@newserver:/var/lib/lxc/
```

* Extract rootfs

```
# mkdir /var/lib/lxc/$NAME/
# cd /var/lib/lxc/$NAME/
# tar --numeric-owner -xzvf container_fs.tar.gz ./*
```

