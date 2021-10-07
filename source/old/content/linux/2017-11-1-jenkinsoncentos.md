Title: Installing Jenkins on Centos 7
Date: 01-11-2017 13:58
Category: Linux
Tags: linux, jenkins, centos, nginx

In this article we will install and configure Jenkins with Nginx as a reverse proxy on a CentOS 7.

Jenkins is a leading open source automation server built with Java that monitors executions of repeated jobs, such as building a software project or jobs run by cron. With Jenkins, organizations can accelerate the software development process through automation. It manages and controls development life-cycle processes of all kinds, including build, document, test, package, stage, deployment, static analysis and many more.

Builds can be started by various means, including being triggered by commit in a version control system, scheduling via a cron-like mechanism, building when other builds have completed, and by requesting a specific build URL.

## REQUIREMENTS

Log in to your server via SSH:

```
# ssh root@server_ip
```

Before starting, enter the below command to check whether you have the proper version of CentOS installed on your machine:

```
# cat /etc/redhat-release
```

It should give you the underneath output:

```
CentOS Linux release 7.2.1511 (Core)
```

## UPDATE THE SYSTEM

Make sure your server is fully up to date:

```
# yum update
```

## INSTALL JAVA AND NGINX

Your next step is to install Nginx along some needed dependencies and the vim text editor so you can edit some config files. Of course, you can use your favorite text editor.

Install the `epel` repository for CentOS 7 and then install Nginx, vim etc… Use the below commands to do that:

```
# yum install epel-release
# yum install nginx wget vim
```

Start Nginx and enable it to start on boot:

```
# systemctl start nginx
# systemctl enable nginx
```

Now create a host directive for the domain from which you will access Jenkins. Open a file, let’s say called ‘your_domain.conf’ in the ‘/etc/nginx/conf.d/’ directory:

```
# vim /etc/nginx/conf.d/your_domain.conf
```

Paste the following:

```
upstream jenkins {
    server 127.0.0.1:8080;
}

server {
    listen      80 default;
    server_name your_jenkins_site.com;

    access_log  /var/log/nginx/jenkins.access.log;
    error_log   /var/log/nginx/jenkins.error.log;

    proxy_buffers 16 64k;
    proxy_buffer_size 128k;

    location / {
        proxy_pass  http://jenkins;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;

        proxy_set_header    Host            $host;
        proxy_set_header    X-Real-IP       $remote_addr;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto https;
    }

}
```

Replace the `your_jenkins_site.com` value with your own domain, save and close the file.

Test if the Nginx configuration is OK:

```
# nginx -t
```

If everything is OK, restart Nginx for the changes to take effect:

```
# service nginx restart
```

Since Jenkins is built with Java, let’s install it with the yum package manager:

```
# yum install java
```

You can check the installed Java version:

```
# java -version

openjdk version "1.8.0_71"
OpenJDK Runtime Environment (build 1.8.0_71-b15)
OpenJDK 64-Bit Server VM (build 25.71-b15, mixed mode)
```

## INSTALL JENKINS

Download the Jenkins repo and install Jenkins with the following commands:

```
# wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
# rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
# yum install jenkins
```

Start the Jenkins server and enable it to start on boot with:

```
# service jenkins start
# systemctl enable jenkins
```

Congratulations, you have successfully installed Jenkins on your CentOS 7. You can now open your favorite web browser and access Jenkins using the domain you configured in the Nginx conf file.

However, the installation is insecure and allows anyone on the network to launch processes on your behalf. Therefore enable authentication to discourage misuse. Go to **Manage Jenkins** (in the left menu).

Click `Setup Security` on the page loaded. Enable security by checking the box next to `Enable security`.

Configure Jenkins to use it’s own user database and disable sign ups:

Navigate to Matrix-based security under Authorization and check the box next to it. Then make sure that Anonymous has only the Read right under the View group to prevent Jenkins from crashing.

Click save at the bottom of the page. After that, you’ll see a sign up form.

Enter a username, password, name and email. Use a lower case username to avoid confusion because Jenkins is assuming a lower case username will be used. After signing up, you will be the administrator of this fresh Jenkins install.

Once everything is up and running, it is up to you to create and schedule your first job, install plugins etc…
