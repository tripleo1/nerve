Title: Tmux detach with systemd
Date: 19-01-2018 12:16
Category: Linux
Tags: linux, tmux, systemd

With `systemd` version 230+ detachind and logout from remote machine will kill tmux session.

### Systemd config

First solution is to disable killing user processes systemwide.
Edit `/etc/systemd/logind.conf` and set

```ini
KillUserProcesses=no
```

Then restart `systemd-logind.service`:

```
# systemctl restart systemd-logind
```

### Tmux as a service

Second solution is running tmux as a service.
Just add `RemainAfterExit=yes` option to `/etc/systemd/system/tmux@.service`:

```ini
[Unit]
Description=tmux default session (detached)
Documentation=man:tmux(1)

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/tmux new-session -d -s %I
ExecStop=/usr/bin/tmux kill-server
KillMode=none

[Install]
WantedBy=multiplexer.target
```
And then use it like this:

```
# systemctl start tmux@instanceone.service
# systemctl start tmux@instancetwo.service
# tmux list-sessions

instanceone: 1 windows (created Sun Jul 24 00:52:15 2016) [193x49]
instancetwo: 1 windows (created Sun Jul 24 00:52:19 2016) [193x49]

# tmux attach-session -t instanceone

(instanceone)#
```
End

