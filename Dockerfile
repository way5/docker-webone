FROM   alpine:3.18
LABEL  version="1.3.0"
LABEL  description="WebOne is a HTTP(S) Proxy for vintage browsers that aren't HTTPS'in these days"
ENV    WD=/home/webone
ENV    WOD=/usr/local/webone
COPY   ./include/ /tmp/
EXPOSE 8080 8081
HEALTHCHECK --start-period=30s --interval=3m --timeout=5s CMD curl -f http://127.0.0.1:8080 || exit 1

RUN apk --no-cache -U upgrade && \
    apk --no-cache add libstdc++ libgcc libintl icu-libs imagemagick ffmpeg logrotate bash git && \
    apk --no-cache add libgdiplus --repository https://dl-3.alpinelinux.org/alpine/edge/testing/ && \
    adduser -S -s /bin/bash -D webone && mkdir ${WOD}
### BUILD
WORKDIR /root
RUN wget https://dot.net/v1/dotnet-install.sh && chmod +x ./dotnet-install.sh && \
    ./dotnet-install.sh -c 7.0 && \
    git clone --depth 1 https://github.com/atauenis/webone.git && \
    .dotnet/dotnet build ./webone/WebOne.csproj -r alpine.3.17-x64 && \
    .dotnet/dotnet publish ./webone/WebOne.csproj -c Release -r alpine.3.17-x64 --self-contained -o ${WOD}
### PREPARE
WORKDIR ${WOD}
RUN rm webone.conf codepage.conf README.md CONTRIBUTING.md && \
    cp /tmp/webone.logrotate /etc/logrotate.d/webone && \
    cp /tmp/entry.sh /usr/local/bin && \
    chmod +x /usr/local/bin/entry.sh && \
    ln -s ${WOD}/webone /webone.serve && \
    ln -s ${WD}/webone.conf ${WOD} && \
    ln -s ${WD}/codepage.conf ${WOD} && \
    ln -s ${WD}/webone.conf.d /etc/ && \
    chown -R webone:root ${WOD} && \
### CLEANUP
    apk del bash git
WORKDIR /tmp
RUN rm -fr .??* .[^.] * && \
    rm -fr /var/cache/*
WORKDIR /root
RUN rm -rf .??* .[^.] *
USER webone

ENTRYPOINT [ "entry.sh" ]