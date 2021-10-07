Title: Creating systemd Unit file
Date: 19-09-2017 12:23
Category: Linux
Tags: linux, systemd 

Create a unit file in the `/etc/systemd/system/` directory and make sure it has correct file permissions. Execute as `root`:

```
# touch /etc/systemd/system/name.service
# chmod 664 /etc/systemd/system/name.service
```

Replace `name` with a name of the service to be created. Note that file does not need to be executable. 

Open the `name.service` file created in the previous step, and add the service configuration options. The following is an example unit configuration for a network-related service:

```ini
[Unit]
Description=service_description
After=network.target

[Service]
ExecStart=path_to_executable
Type=forking

[Install]
WantedBy=default.target
```

Notify systemd that a new `name.service` file exists by executing the following command as root:

```
# systemctl daemon-reload
# systemctl enable name.service
# systemctl start name.service
```
