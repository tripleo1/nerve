Title: Dockerfile description
Date: 11-04-2017 13:17
Category: Docker
Tags: linux, docker, containers, dockerfile

### Creating image from file

Go to the directory with Dockerfile and run:
```bash
docker build -t imagename .
```

### Dockerfile instructions

**FROM**

`FROM` - This instruction is used to set the base image for subsequent instructions. It is mandatory to set this in the first line of a Dockerfile. You can use it any number of times though.

Example:
```
FROM debian:jessie
```

**MAINTAINER**

`MAINTAINER` - This is a non-executable instruction used to indicate the author of the Dockerfile.

Example:
```
MAINTAINER iaroki
```

**RUN**

`RUN` - This instruction lets you execute a command on top of an existing layer and create a new layer with the results of command execution.

Example:
```
FROM debian:jessie
RUN apt-get update && apt-get install python3 -y
```

**CMD**

`CMD` - The major difference between `CMD` and `RUN` is that `CMD` doesn’t execute anything during the build time. It just specifies the intended command for the image. Whereas `RUN` actually executes the command during build time.

Note: there can be only one `CMD` instruction in a Dockerfile, if you add more, only the last one takes effect.

Example:
```
CMD ["echo", "say hello"]
```

**EXPOSE**

`EXPOSE` - While running your service in the container you may want your container to listen on specified ports. The `EXPOSE` instruction helps you do this.

Example:
```
EXPOSE 9000
```

**ENV**

`ENV` - This instruction can be used to set the environment variables in the container.

Example:
```
ENV HOME=/home/user
```

**USER**

`USER` - This is used to set the UID (or username) to use when running the image.

Example:
```
USER iaroki
```

**WORKDIR**

`WORKDIR` - This is used to set the currently active directory for other instructions such as `RUN`, `CMD`, `ENTRYPOINT`, `COPY` and `ADD`.

Note that if relative path is provided, the next `WORKDIR` instruction will take it as relative to the path of previous `WORKDIR` instruction.

Example:
```
WORKDIR /user
WORKDIR home
RUN pwd
```
This will output the path as `/user/home`.

**COPY**

`COPY` - This instruction is used to copy files and directories from a specified source to a destination (in the file system of the container).

Example:
```
COPY preconditions.txt /usr/temp
```

**ADD**

`ADD` - This instruction is similar to the `COPY` instruction with few added features like remote URL support in the source field and local-only tar extraction. But if you don’t need a extra features, it is suggested to use `COPY` as it is more readable.

Example:
```
ADD http://www.site.com/downloads/sample.tar.xz /usr/src
```

**ENTRYPOINT**

`ENTRYPOINT` - You can use this instruction to set the primary command for the image.

For example, if you have installed only one application in your image and want it to run whenever the image is executed, `ENTRYPOINT` is the instruction for you.

Note: arguments are optional, and you can pass them during the runtime with something like `docker run <image-name>`.

Also, all the elements specified using `CMD` will be overridden, except the arguments. They will be passed to the command specified in `ENTRYPOINT`.

Example:
```
CMD "Hello World!"
ENTRYPOINT echo
```

**VOLUME**

`VOLUME` - You can use the `VOLUME` instruction to enable access to a location on the host system from a container. Just pass the path of the location to be accessed.

Example:
```
VOLUME /data
```

**ONBUILD**

`ONBUILD` - This instruction adds a trigger instruction to be executed when the image is used as the base for some other image. It behaves as if a `RUN` instruction is inserted immediately after the `FROM` instruction of the downstream Dockerfile. This is typically helpful in cases where you need a static base image with a dynamic config value that changes whenever a new image has to be built (on top of the base image).

Example:
```
ONBUILD RUN rm -rf /usr/temp
```

