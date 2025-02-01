# WebOne HTTP 1.X Proxy on Docker

This is the work in progress version of Docker image with **[WebOne](https://github.com/atauenis/webone) Proxy Server** by **Alexander Tauenis** 👍 on board.

Please refer to the original 🔥 [Wiki](https://github.com/atauenis/webone/wiki) page before to change configuration files.

## Setup and Run
1. Create a folder on your docker host for WebOne config files. E.g. `/your/local/webone.config`
2. Copy [`webone.conf`](webone.config/webone.conf) to the WebOne config folder.
3. Create a sub folder for the log files. E.g. `/your/local/webone.config/logs`
    - Make sure the log folder is writable
4. Edit [`webone.conf` line 60](webone.config/webone.conf#L60) and change `%SYSLOGDIR%` to `%WD%/logs`. This will configure logs to be placed in the folder created above.
   - Remember it must be your version of webone.conf you edit.
5. Run docker
   ```
   docker run -d -p 8080:8080 --name webone \
   -v /your/local/webone.config:/home/webone \
   u306060/webone:latest
   ``` 

Note: This starts WebOne with a default setup on port 8080. The contanier will not start if the port is already occupied.

## Custom Port Setup and Run
**NB**: On image version <u>0.17.3 and earlier</u> on [Docker Hub](https://hub.docker.com/r/u306060/webone/tags), this breaks the healthcheck.
1. Follow steps [1-4] under [Setup and Run](#setup-and-run)
2. Edit the [Port value of `webone.conf` line 33](webone.config/webone.conf#L33) to match your chosen port.
3. Run the container with the added environment variable `SERVICE_PORT` and new port mappings. Example where the chosen port is `8181`:
      ```
      docker run -d -p 8181:8181 --name webone \
      -v /your/local/webone.config:/home/webone \
      u306060/webone:latest
      ```

## Advanced Setup and Run
1. Follow steps [1-4] under [Setup and Run](#quick-setup-and-run)
2. Edit, add and/or remove configuration in your `webone.conf`. See more [on the WebOne wiki](https://github.com/atauenis/webone/wiki/Configuration-file) about the configuration file.
    - Remember, if you change the Port, follow the instructions in [Custom Port Setup and Run](custom-port-setup-and-run).

## A note OpenSSL 1.0.1

Since WebOne version 0.17.0 there is [`Added support for browsing HTTPS with pre-2004 browsers without certificate`](https://github.com/atauenis/webone/releases/tag/v0.17.0) which seems to work fine in standalone versions, however it shows an issue (`OpenSSL error - ca md too weak`) on Docker images. The Ubuntu based build was created for the purpose of testing this functionality.
