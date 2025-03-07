# `WebOne` on :whale: [Docker]

This is the work in progress version of Docker image with **[WebOne](https://github.com/atauenis/webone) Proxy Server** by **Alexander Tauenis** 👍 on board.

Please refer to the original 🔥 [Wiki](https://github.com/atauenis/webone/wiki) page before to change configuration files.

## [Contributing]()
If your want to build your own image or to share your code, please read about the [CONTRIBUTING](CONTRIBUTING.md) first.

## [Quick Setup and Run]()
Run the container on port `8080` and the default configuration at `/etc/webone_defaults.conf`.

```bash
docker run -d -p 8080:8080 --name webone u306060/webone:latest
```

## [Environment variables (version 0.17.4 and higher):]()
These are used as a container-wide accessible values and could be used in WebOne configuration as `%YOUR_ENV_VARIABLE%`. E.g.: `DefaultHostName=%PROXY_HOSTNAME%`.

| Name | Description |
|:---|:----|
| SERVICE_PORT | _(optional)_ This port number *must* be the same as the exposed (container external) port, on which WebOne oprates. And it's used for the container healthcheck feature allowing Docker to make sure your instance of WebOne is up and running. Default value: `8080` |
| PROXY_HOSTNAME | _(optional)_ Custom WebOne hostname, for more details see #[160](https://github.com/atauenis/webone/issues/160) (see also `DefaultHostName` in [custom.conf](/configuration/custom.conf)). |
| CONFIG_PATH | _(optional)_ The main (`webone.conf`) configuration path. By default WebOne is expecting the configuration at `/etc/webone.conf.d/webone.conf` or in the same directory where it has been installed. You may change this path to, for instance: `/your/directory/webone.conf`, of cource if directory `/your/directory` exists or it is exposed to the host machine with `-v` option. |
| LOG_DIR | _(optional)_ A directory where WebOne will store log files, by default it is `/etc/webone.conf.d/logs`. It could be used in configuration as `AppendLogFile=%LOG_DIR%/webone.log` (see: [custom.conf](/configuration/custom.conf)).  |

## [Custom configuration]()
1. Create a directory on your host machine (e.g. `/your/local/webone_configs` for *nix or `C:\WebOne\webone_configs` for Windows) and copy the [configuration](./configuration) directory contents into it;
2. Edit `custom.conf` as needed. You may expand the list of customized options, using ones from [webone.conf](./configuration/webone.conf);
3. Run docker

    ```bash
    docker run -d -p 8080:8080 --name webone \
    -v /your/local/webone_configs:/etc/webone.conf.d \
    -e CONFIG_PATH=/etc/webone.conf.d/webone.conf \
    -e SERVICE_PORT=8080 \
    -e LOG_DIR=/etc/webone.conf.d/logs \
    -e PROXY_HOSTNAME=mydockerhost \
    u306060/webone:latest
    ```

    for Windows change the configuration folder respectively:

    ```bash
    ...
    -v C:\WebOne\webone_configs:/home/webone \
    ...
    ```

>[!NOTE]
>The `Port` option value and `SERVICE_PORT` variable value must be equal (see: [`custom.conf`](./configuration/custom.conf)).

Custom configuration files are loaded using the include statement as one at the very end of [webone.conf](./configuration/webone.conf). By default the Docker image is self-sufficient, which means that it already carries the default configuration and could be started right after dowloading without any change.
The defaults could be overriden by using [Custom configuration](#custom-configuration) approach.

## [OpenSSL]()

Since WebOne version 0.17.0 there is [`Added support for browsing HTTPS with pre-2004 browsers without certificate`](https://github.com/atauenis/webone/releases/tag/v0.17.0) which seems to work fine in standalone versions, however it shows an issue (`OpenSSL error - ca md too weak`) on Docker images. The Ubuntu based build was created for the purpose of testing this functionality.
