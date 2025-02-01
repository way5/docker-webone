# WebOne HTTP 1.X Proxy on Docker

This is work in progress version of `Docker image` with **[WebOne](https://github.com/atauenis/webone) Proxy Server** by **Alexander Tauenis** 👍 on board.

Please refer to the original 🔥 [Wiki](https://github.com/atauenis/webone/wiki) page before to change configuration files.

## + Setup and Run

>[!IMPORTANT]
By default WebOne is running on port `8080`. If you'd need to change it, go to the configuration file [default.conf](webone.config/webone.conf.d/default.conf) and look for the option `Port`. Before continue you may also change the external port which is going to be exposed by Docker image. Change option `EXPOSE` in [Dockerfile](./Dockerfile), then proceed with building.

1. Clone this repoository `git clone ...` on your host machine that runs Docker.
2. Create a directory for WebOne config files. E.g.: `/your/local/webone`.
3. Copy all files and directtories from [`/webone.conf`](./webone.config/) to your local WebOne config directory from the previoous step.
   1. The [default.conf](/webone.config/webone.conf.d/default.conf) may be used for adding custom configuration or to `override` any configuration options from original `webone.conf`. 
   Custom log file paths and the WebOne port, along with another custom options could be set there without the need of changing original `webone.conf`.
4. Make sure all newly created directories are writable to user that runs WebOne.
5. Run Docker:
   1. Eather download the latest build from **[DockerHub](https://hub.docker.com/r/u306060/webone)** and run it using WebOne config directory you've created and the proper port.
   2. Or build the image yourself:

```bash
cd docker-webone
docker build --no-cache -t IMAGE_NAME .`
docker run -d -p 8080:8080 -v /your/local/webone:/home/webone --name CONTAINER_NAME IMAGE_NAME
```

## + OpenSSL 1.0.1

Since WebOne version 0.17.0 there is [`Added support for browsing HTTPS with pre-2004 browsers without certificate`](https://github.com/atauenis/webone/releases/tag/v0.17.0) which seems to work fine in standalone versions, however it shows an issue (`OpenSSL error - ca md too weak`) on Docker images. The Ubuntu based build (`Docker images with the TAG: 0.XX.X-101`) was created for the purpose of testing this functionality.
