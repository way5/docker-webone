FROM   alpine:3.21
LABEL  version="1.4.2"
LABEL  description="WebOne is a HTTP(S) Proxy for vintage browsers that aren't HTTPS'in these days"
ARG    REPO=https://github.com/way5/webone.git
ARG    BRANCH=master
ARG    INSTALL_DIR=/usr/local/webone
ARG    SSL_SYSTEM=/etc/ssl
ARG    CONFIG_DEFAULTS=/etc/webone
ENV    TIMEZONE=""
ENV    CONFIG_PATH=${CONFIG_DEFAULTS}/webone.conf
ENV    LOG_DIR=${CONFIG_DEFAULTS}/logs
ENV    SERVICE_PORT=8080

EXPOSE ${SERVICE_PORT}

COPY   ./include/ /tmp/
COPY   ./configuration/ /tmp/config/

HEALTHCHECK --start-period=120s --interval=3m --timeout=5s CMD curl -f http://127.0.0.1:$SERVICE_PORT || exit 1

USER root
WORKDIR /root
### PREPARE
RUN apk --no-cache -U upgrade && \
    apk --no-cache add libstdc++ libgcc libintl icu-libs imagemagick ffmpeg yt-dlp logrotate bash git openssl curl wget tzdata && \
    apk --no-cache add libgdiplus --repository https://dl-3.alpinelinux.org/alpine/edge/testing/ && \
    adduser -D -S -s /bin/bash -H webone && \
    git config --global http.version HTTP/1.1 && \
### DOWNLOAD AND BUILD
    wget --progress=dot:giga https://dot.net/v1/dotnet-install.sh && \
    chmod +x ./dotnet-install.sh && \
    ./dotnet-install.sh -c 8.0 && \
    git clone --depth 1 --branch ${BRANCH} ${REPO} && \
    /root/.dotnet/dotnet build ./webone/WebOne.csproj -r alpine-x64 && \
    /root/.dotnet/dotnet publish ./webone/WebOne.csproj -c Release -r alpine-x64 --self-contained -o ${INSTALL_DIR} && \
### CONFIGURATION
    if [[ ! -z "${TIMEZONE}" ]]; then ln -s "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime; fi && \
    mkdir -p ${CONFIG_DEFAULTS} && \
    mkdir -p ${LOG_DIR} && \
    cp -r /tmp/config/* ${CONFIG_DEFAULTS} && \
    ln -s ${LOG_DIR} /var/log/webone && \
    echo -e "/var/log/webone/*.log {\nweekly\nrotate 30\nsize 2M\ncompress\ndelaycompress\ncreate 666 root root\n}" > /etc/logrotate.d/webone && \
    cp /tmp/entry.sh /usr/local/bin && \
    rm -f ${SSL_SYSTEM}/openssl.cnf && \
    ln -s ${CONFIG_DEFAULTS}/openssl_webone.cnf ${SSL_SYSTEM}/openssl.cnf && \
    ln -s ${CONFIG_DEFAULTS}/favicon.ico ${INSTALL_DIR}/html/ && \
    chown -R webone:root ${INSTALL_DIR} ${CONFIG_DEFAULTS} ${LOG_DIR} && \
    chmod +x /usr/local/bin/entry.sh && \
### CLEANUP
    apk del bash git && \
    cd ${INSTALL_DIR} && rm -fr *.conf *.cnf README.md CONTRIBUTING.md && \
    cd /tmp && rm -fr .??* .[^.] * && \
    cd /var/cache && rm -fr .??* .[^.] * && \
    cd && rm -rf .??* .[^.] *

USER webone

ENTRYPOINT [ "entry.sh" ]