+++
title = "Using Traefik with Docker"
date = "2018-10-26T13:20:25Z"
tags = ["linux", "docker", "traefik", "containers"]

+++

Start Traefik:

```bash
~  >>> docker run -it --rm --name traefik -p 80:80 -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock traefik --api --docker
```

Start some services:

- Gitea container:

```bash
docker run -it --rm --name gitea -l traefik.frontend.rule=Host:gitea.iaroki.io -l traefik.port=3000 gitea/gitea
```

- Blog container:

```bash
docker run -it --rm --name blog -l traefik.frontend.rule=Host:blog.iaroki.io blog
```

Now Gitea will be available at `gitea.iaroki.io` and blog at `blog.iaroki.io`.

