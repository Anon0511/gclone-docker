FROM golang:alpine AS builder
ENV CGO_ENABLED=0
ENV GO111MODULE=on

RUN set -xe && \
    apk add --no-cache --virtual .build-deps \
        build-base \
        tzdata \
        curl \
        upx && \
    VERSION=$(curl -s https://api.github.com/repos/dogbutcat/gclone/releases/latest | grep "tag_name" | cut -d'"' -f4) && \
    cd /root && \
    mkdir gclone && wget https://github.com/dogbutcat/gclone/archive/refs/tags/$VERSION.tar.gz -O - | tar -xzC gclone && cd gclone && cd * \
    sed -i '/"gclone sa file:"/d' ./backend/drive/drive.go && \
    LDFLAGS="-s -w" && \
    go build -ldflags "$LDFLAGS" -v -o /usr/bin/gclone && \
    upx --lzma /usr/bin/gclone && \
    apk del .build-deps 

FROM alpine:latest

VOLUME ["/var/gclone"]
RUN apk add --no-cache su-exec
RUN apk add --update tzdata
RUN rm -rf /var/cache/apk/*
COPY --from=builder /usr/bin/gclone /usr/bin/gclone
COPY ./entrypoint.sh /bin/entrypoint.sh
COPY ./gclone_start.sh /bin/gclone_start.sh

ENV PUID=0 PGID=0 HOME=/var/gclone
RUN mkdir -p /var/gclone/.config/rclone
RUN chmod 777 /bin/entrypoint.sh
RUN chmod 777 /bin/gclone_start.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
