FROM alpine:3.15
LABEL version="1.0"
LABEL description="WebOne Proxy for vintage browsers that arn't HTTPS'in these days."
ENV PACKAGE=webone-0.11.2
EXPOSE 8080
COPY ./include/ /tmp/

RUN apk --no-cache --update add libstdc++ libgcc libintl icu-libs imagemagick ffmpeg logrotate && \
    tar -zxf /tmp/webone-0.11.2.tar.gz -C /usr/local/ && \
    mkdir /home/webone && \
    cp /tmp/webone.logrotate /etc/logrotate.d/webone && \
    cp /tmp/entry.sh /usr/local/bin && \
    chmod +x /usr/local/bin/entry.sh && \
    ln -s /usr/local/bin/entry.sh /. && \
    ln -s /home/webone/webone.conf /usr/local/webone-0.11.2/. && \
    ln -s /home/webone/codepage.conf /usr/local/webone-0.11.2/. && \
    ln -s /home/webone/webone.conf.d /etc/. && \
    ln -s /usr/local/webone-0.11.2/webone /webone.serve && \
    rm -fr /tmp/* && \
    rm -fr /var/cache/*
    
ENTRYPOINT [ "entry.sh" ]
    
    