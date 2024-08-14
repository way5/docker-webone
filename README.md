# WebOne HTTP 1.X Proxy on Docker

This is the work in progress version of Docker image with **[WebOne](https://github.com/atauenis/webone) Proxy Server** by **Alexander Tauenis** 👍 on board.

Please refer to the original 🔥 [Wiki](https://github.com/atauenis/webone/wiki) page before to change configuration files.

## **+ Setup**

- You can build an image yourself:

> `git clone ...`
> 
> `cd docker-webone`
> 
> `docker build --no-cache -t IMAGE_NAME .`
> 
> `docker run -d -p 8080:8080 -v /your/local/webone.config:/home/webone --name CONTAINER_NAME IMAGE_NAME`

- Or download it from **[DockerHub](https://hub.docker.com/repository/docker/u306060/webone)**.

## **+ OpenSSL 1.0.1**

Since WebOne version 0.17.0 there is [`Added support for browsing HTTPS with pre-2004 browsers without certificate`](https://github.com/atauenis/webone/releases/tag/v0.17.0) which seems to work fine in standalone versions, however it shows an issue (`OpenSSL error - ca md too weak`) on Docker images. The Ubuntu based build was created for the purpose of testing this functionnality.
