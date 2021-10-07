Title: Network Manager restart after suspend/hibernate
Date: 09-10-2016 12:22
Category: Linux
Tags: linux, systemd	

Open a terminal and type the following:

```
sudo nano /etc/systemd/system/wifi-resume.service 
```

Now paste the script in there. Exit with CTRL + X and press Y to save. 

Now to activate it: 

```
sudo systemctl enable wifi-resume.service
```

Script:

```
#/etc/systemd/system/wifi-resume.service
#sudo systemctl enable wifi-resume.service
[Unit]
Description=Restart networkmanager at resume
After=suspend.target
After=hibernate.target
After=hybrid-sleep.target

[Service]
Type=oneshot
ExecStart=/bin/systemctl restart network-manager.service

[Install]
WantedBy=suspend.target
WantedBy=hibernate.target
WantedBy=hybrid-sleep.target
```

Hope this helps. It works on my laptop.

