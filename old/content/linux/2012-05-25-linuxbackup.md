Title: Linux backup on the fly
Date: 25-05-2012 13:38
Category: Linux
Tags: linux, backup

Backing-up:

```
cd /
tar cvpjf backup.tar.bz2 --exclude=/proc 
                         --exclude=/lost+found 
                         --exclude=/backup.tar.bz2 
                         --exclude=/mnt 
                         --exclude=/sys /
```

Restoring:

```
tar xvpfj backup.tar.bz2 -C /
```

