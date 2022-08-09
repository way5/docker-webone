FROM alpine:3.15
LABEL version="1.1"
LABEL description="WebOne Proxy for vintage browsers that arn't HTTPS'in these days."
ENV PACKAGE=webone-0.12.1
EXPOSE 8080
COPY ./include/ /tmp/

RUN apk --no-cache -U upgrade && \
    apk --no-cache add libstdc++ libgcc libintl icu-libs imagemagick ffmpeg logrotate && \
    tar -zxf /tmp/webone.tar.gz -C /usr/local/ && \
    mkdir /home/webone && \
    cp /tmp/webone.logrotate /etc/logrotate.d/webone && \
    cp /tmp/entry.sh /usr/local/bin && \
    chmod +x /usr/local/bin/entry.sh && \
    ln -s /usr/local/bin/entry.sh /. && \
    ln -s /home/webone/webone.conf /usr/local/$PACKAGE/. && \
    ln -s /home/webone/codepage.conf /usr/local/$PACKAGE/. && \
    ln -s /home/webone/webone.conf.d /etc/. && \
    ln -s /usr/local/$PACKAGE/webone /webone.serve && \
    rm -fr /tmp/* && \
    rm -fr /var/cache/*

ENTRYPOINT [ "entry.sh" ]
