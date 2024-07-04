FROM   alpine:latest
LABEL  version="1.3.5"
LABEL  description="WebOne is a HTTP(S) Proxy for vintage browsers that aren't HTTPS'in these days"
ENV    WD=/home/webone
ENV    WOD=/usr/local/webone
ENV    SSLWD=/etc/ssl
COPY   ./include/ /tmp/
EXPOSE 8080
HEALTHCHECK --start-period=120s --interval=3m --timeout=5s CMD curl -f http://127.0.0.1:8080 || exit 1

USER root
RUN apk --no-cache -U upgrade && \
    apk --no-cache add libstdc++ libgcc libintl icu-libs imagemagick ffmpeg logrotate bash git openssl && \
    apk --no-cache add libgdiplus --repository https://dl-3.alpinelinux.org/alpine/edge/testing/ && \
    adduser -S -s /bin/bash -D webone && mkdir ${WOD} && \
    git config --global http.version HTTP/1.1 && \
### BUILD
    cd && wget https://dot.net/v1/dotnet-install.sh && chmod +x ./dotnet-install.sh && \
    ./dotnet-install.sh -c 7.0 && \
    git clone --depth 1 https://github.com/atauenis/webone.git && \
    .dotnet/dotnet build ./webone/WebOne.csproj -r alpine-x64 && \
    .dotnet/dotnet publish ./webone/WebOne.csproj -c Release -r alpine-x64 --self-contained -o ${WOD} && \
### PREPARE
    cd ${WOD} && rm -fr *.conf *.cnf README.md CONTRIBUTING.md /etc/webone.conf.d && \
    cp /tmp/webone.logrotate /etc/logrotate.d/webone && \
    cp /tmp/entry.sh /usr/local/bin && \
    chmod +x /usr/local/bin/entry.sh && \
    chown -R webone:root ${WOD} && \
    rm ${SSLWD}/openssl.cnf && \
    ln -s ${WD}/openssl_webone.cnf ${SSLWD}/openssl.cnf && \
    ln -s ${WD}/webone.conf ${WOD} && \
    ln -s ${WD}/escargot.conf ${WOD} && \
    ln -s ${WD}/codepage.conf ${WOD} && \
    ln -s ${WD}/openssl_webone.cnf ${WOD} && \
    ln -s ${WD}/webone.conf.d /etc/ && \
### CLEANUP
    apk del bash git && \
    cd /tmp && rm -fr .??* .[^.] * && \
    cd /var/cache && rm -fr .??* .[^.] * && \
    cd && rm -rf .??* .[^.] *
USER webone

ENTRYPOINT [ "entry.sh" ]