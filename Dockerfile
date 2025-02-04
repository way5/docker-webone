FROM   alpine:3.19
LABEL  version="1.3.6"
LABEL  description="WebOne is a HTTP(S) Proxy for vintage browsers that aren't HTTPS'in these days"
ARG    REPO=https://github.com/atauenis/webone.git
ARG    BRANCH=master
ARG    BUILD_PATH=/usr/local/webone/build
ARG    INSTALL_PATH=/usr/local/webone
ARG    WD=/home/webone
ARG    SSLWD=/etc/ssl
ENV    LOG_PATH=${WD}/logs
ENV    SSL_PATH=${WD}/ssl
ENV    CONFIG_PATH=${WD}/config/default/webone.conf
#ENV    CONFIG_PATH=${WD}/config/minimal/webone.conf
ENV    SERVICE_PORT=8080

COPY   ./include/ /tmp/

HEALTHCHECK --start-period=120s --interval=3m --timeout=5s CMD curl -f http://127.0.0.1:$SERVICE_PORT || exit 1

USER root
WORKDIR /root
### PREREQUISITES
RUN apk --no-cache -U upgrade && \
    apk --no-cache add libstdc++ libgcc libintl icu-libs imagemagick ffmpeg yt-dlp logrotate bash git openssl curl wget && \
    apk --no-cache add libgdiplus --repository https://dl-3.alpinelinux.org/alpine/edge/testing/ && \
    adduser -S -s /bin/bash -D webone && \
    mkdir ${INSTALL_PATH} && \
    git config --global http.version HTTP/1.1 && \
### DOWNLOAD AND BUILD
    wget --progress=dot:giga https://dot.net/v1/dotnet-install.sh && \
    chmod +x ./dotnet-install.sh && \
    ./dotnet-install.sh -c 7.0 && \
    git clone --depth 1 --branch ${BRANCH} ${REPO} && \
    /root/.dotnet/dotnet build ./webone/WebOne.csproj -r alpine-x64 && \
    /root/.dotnet/dotnet publish ./webone/WebOne.csproj -c Release -r alpine-x64 --self-contained -o ${INSTALL_PATH} && \
### CONFIGURE
    cp /tmp/webone.logrotate /etc/logrotate.d/webone && \
    cp /tmp/entry.sh /usr/local/bin && \
    cp /tmp/favicon.ico ${INSTALL_PATH}/html/ && \
    chmod +x /usr/local/bin/entry.sh && \
    chown -R webone:root ${INSTALL_PATH} && \
    cp -f /tmp/openssl_webone.cnf ${SSLWD}/openssl.cnf && \
    cp -fr /tmp/config ${WD}/ && \
    cp -fr /tmp/webone.conf.d /etc && \
    mkdir ${LOG_PATH} && \
    chmod +w ${LOG_PATH} && \
    chown -R webone:root ${LOG_PATH} && \
    mkdir ${SSL_PATH} && \
    chmod +w ${SSL_PATH} && \
    chown -R webone:root ${SSL_PATH} && \
### CLEANUP
    apk del bash git && \
    rm -fr *.conf *.cnf README.md CONTRIBUTING.md /etc/webone.conf.d && \
    rm -fr /tmp/.??* /tmp/.[!.]* /tmp/* && \
    rm -fr /var/cache/.??* /var/cache/.[!.]* /var/cache/* && \
    rm -fr ~/.??* ~/.[!.]* ~/*

USER webone

ENTRYPOINT [ "entry.sh" ]