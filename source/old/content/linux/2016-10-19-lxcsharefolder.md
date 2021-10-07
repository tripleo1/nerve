Title: LXC share folder
Date: 19-10-2016
Category: Linux
Tags: containers, linux, lxc
	
## Exposing a directory on the host machine to an LXC container:

1. Log into the container and create an empty directory, this will be the mount point
2. Log out and stop the container.
3. Open to your container’s config file
    * For regular LXC containers: `/var/lib/lxc/mycontainer/config`
    * For *unprivileged* LXC containers: `$HOME/.local/share/lxc/mycontainer/config`
4. Add a new line above the lxc.mount directive, that follows the format below. Substitute proper paths as necessary:
    * `lxc.mount.entry = /path/to/folder/on/host /path/to/mount/point none bind 0 0`
    * Both of these paths are **relative to the host machine**.
    * Location of the root fs in the container can be found at:
        For regular LXC containers: `/var/lib/lxc/mycontainer/rootfs/`
        For unprivileged LXC containers: `$HOME/.local/share/lxc/mycontainer/rootfs`

*Note: If the host’s user does not exist in the container, the container will still be mounted, but with `nobody:nogroup` as the owner. This may not be a problem unless you need to write to these files, in which case you’ll need to give everybody write permission to that folder. (i.e. `chmod -R go+w /folder/to/share`)*

## Example

I want to share `/home/max/foobar` to my unprivileged container `bazquux`. In `bazquux`, I want this folder to be found at `/mnt/baz`.

In the container:

```
$ cd /mnt
$ sudo mkdir baz
$ logout
```

On the host, I will add the following line above `lxc-mount` in `/home/max/.local/share/lxc/bazquux/config`:

```
lxc.mount.entry = /home/max/foobar /home/julian/.local/share/lxc/bazquux/rootfs/mnt/baz none bind 0 0
```

