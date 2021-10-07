---
title: "Passwordless SSH key-based authentication"
date: 2017-03-20T12:22:43+03:00
tags: ["linux", "ssh"]
---

To generate public/private pair of keys enter:

```bash
ssh-keygen -b 4096 -t rsa -C "username@email"
```

Next step is to copy key to the remote server:

```bash
ssh-copy-id -i .ssh/id_rsa.pub user01@server2.example.com
```

On remote server is adviceable to edit `/etc/ssh/sshd_config`:

```ini
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin no
```

Restart the sshd service:

```bash
systemctl restart sshd
```

And try to login:

```bash
ssh server2.example.com
```

Done!

---
