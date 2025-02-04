# WebOne HTTP 1.X Proxy on Docker

This is the work in progress version of Docker image with **[WebOne](https://github.com/atauenis/webone) Proxy Server** by **Alexander Tauenis** 👍 on board.

Please refer to the original 🔥 [Wiki](https://github.com/atauenis/webone/wiki) page before to change configuration files.

## Building

If your want to build your own image, please refer to [CONTRIBUTING](CONTRIBUTING.md).

## Quick Setup and Run
Run the container with default setting on port `8080`, configuring host via environment variable `PROXY_HOSTNAME`.

```
docker run -d -p 8080:8080 --name webone \
-e CONFIG_PATH=/home/webone/config/default/webone.conf \
-e PROXY_HOSTNAME=mydockerhost \
u306060/webone:latest
```

Note: Only versions after version `0.17.4`.

## Setup and Run with custom config
1. Create a folder on your docker host for WebOne config files. E.g. `/your/local/webone_config` on *nix or `C:\WebOne\webone_config` on Window
2. Copy [`webone.conf`](include/config/default/webone.conf) to the WebOne config folder you just created.
3. Edit [`webone.conf`](include/config/default/webone.conf) and change any value you would like. You can also change `DefaultHostName` to fixed values, to avoid setting it via the environment variable `PROXY_HOSTNAME`.
4. Run docker (*nix)
   ```
   docker run -d -p 8080:8080 --name webone \
   -v /your/local/webone_config:/home/webone/config/myconfig \
   -e CONFIG_PATH='/home/webone/config/myconfig' \
   -e PROXY_HOSTNAME=mydockerhost 
   u306060/webone:latest
   ```
   Run docker (Windows)
   ```
   docker run -d -p 8080:8080 --name webone \
   -v C:\WebOne\webone_config:/home/webone/config/myconfig \
   -e CONFIG_PATH='/home/webone/config/myconfig' \
   -e PROXY_HOSTNAME=mydockerhost 
   u306060/webone:latest
   ```

Note: If you change the `Port` value in [`webone.conf`](include/config/default/webone.conf) or change the `SERVICE_PORT` variable via the `docker run` command, you also need to change the port mapping.

## Extra config files
Extra config files are loaded using the [Include statement in `webone.conf`](include/config/default/webone.conf#L1034). These config files are placed in the container's `/etc/webone.conf.d/` folder.

The default files are [`codepage.conf`](include/webone.conf.d/codepage.conf) and [`escargot.conf`](include/webone.conf.d/escargot.conf).

You can override these by either mounting a volume with your own extra config files in `/etc/webone.conf.d/`, or you can mount a local folder with your own config files as a volume with a different path inside the container, and change your 
[`webone.conf`](include/config/default/webone.conf#L1034) accordingly.

### Example
Run on custom port 9080 overrding the extra conf dir my mounting a volume `/your/local/webone_extras` on that path. Any valid conf-files in that dir will also be loaded, (if your `webone.conf`'s include statement points to `/etc/webone.conf.d`)
   1. Follow step 1, 2 and 3 under [Quick Setup and Run](#quick-setup-and-run)
   2. Edit the [`Port` value](webone.config/webone.conf#L33) to match your chosen port.
   3. Create a local folder for extra config files, e.g. `/your/local/webone_extras`
   4. Place any or no conf-files in that folder
   5. Run the container with added variable `SERVICE_PORT` and new port mappings and with the local folder created in the step before the previous mounted as `/etc/webone.conf.d`:
   ```
   docker run -d -p 9080:9080 --name webone \
   -v /your/local/webone_config:/home/webone/config/myconfig \
   -v /your/local/webone_extras:/etc/webone.conf.d \
   -e CONFIG_PATH='/home/webone/config/myconfig'
   -e SERVICE_PORT=9080 \
   u306060/webone:latest
   ```
* Run using the minimal built-in


## A note about OpenSSL 1.0.1

Since WebOne version 0.17.0 there is [`Added support for browsing HTTPS with pre-2004 browsers without certificate`](https://github.com/atauenis/webone/releases/tag/v0.17.0) which seems to work fine in standalone versions, however it shows an issue (`OpenSSL error - ca md too weak`) on Docker images. The Ubuntu based build was created for the purpose of testing this functionality.
