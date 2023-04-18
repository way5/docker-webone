FROM alpine:3.17.3
LABEL version="1.2.2"
LABEL description="WebOne Proxy for vintage browsers that aren't HTTPS'in these days."
EXPOSE 8080
COPY ./include/ /tmp/

RUN apk --no-cache -U upgrade && \
    apk --no-cache add libstdc++ libgcc libintl icu-libs imagemagick ffmpeg logrotate bash git && \
    apk --no-cache add libgdiplus --repository https://dl-3.alpinelinux.org/alpine/edge/testing/ && \
    ### BUILD
    cd && wget https://dot.net/v1/dotnet-install.sh && chmod +x /root/dotnet-install.sh && \
    /root/dotnet-install.sh -c 6.0 && \
    git clone https://github.com/atauenis/webone.git && \
    cd webone && \
    /root/.dotnet/dotnet build ./WebOne.csproj -r alpine.3.17-x64 && \
    /root/.dotnet/dotnet publish ./WebOne.csproj -c Release -r alpine.3.17-x64 --self-contained -o /usr/local/webone && \
    ### PREPARE
    mkdir /home/webone && \
    cd /usr/local/webone && \
    rm webone.conf codepage.conf README.md CONTRIBUTING.md && \
    cp /tmp/webone.logrotate /etc/logrotate.d/webone && \
    cp /tmp/entry.sh /usr/local/bin && \
    chmod +x /usr/local/bin/entry.sh && \
    ln -s /usr/local/bin/entry.sh / && \
    ln -s /usr/local/webone/webone /webone.serve && \
    ln -s /home/webone/webone.conf /usr/local/webone/ && \
    ln -s /home/webone/codepage.conf /usr/local/webone/ && \
    ln -s /home/webone/webone.conf.d /etc/ && \
    ### CLEANUP
    apk del bash git && \
    cd /tmp && rm -fr .??* .[^.] * && \
    rm -fr /var/cache/* && \
    cd && rm -rf .??* .[^.] *

ENTRYPOINT [ "entry.sh" ]
