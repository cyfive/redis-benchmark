FROM alpine:3.17 as builder

LABEL \
    AUTHOR="Stanislav V. Emets <stas@emets.su>" \
    VERSION=1.0 \
    ARCH=AMD64 \
    DESCRIPTION="A Redis benchmark toolset"

ARG REDIS_DOWNLOAD_URL="http://download.redis.io/"

ARG REDIS_VERSION="stable"

RUN apk add --no-cache su-exec tzdata make curl build-base linux-headers bash openssl-dev

RUN curl -fL -Lo /tmp/redis-${REDIS_VERSION}.tar.gz ${REDIS_DOWNLOAD_URL}/redis-${REDIS_VERSION}.tar.gz && \
    cd /tmp && \
    tar xvzf redis-${REDIS_VERSION}.tar.gz && \
    cd redis-${REDIS_VERSION} && \
    make && \
    make install BUILD_TLS=yes

FROM alpine:3.17

LABEL \
    AUTHOR="Stanislav V. Emets <stas@emets.su>" \
    VERSION=1.0 \
    ARCH=AMD64 \
    DESCRIPTION="A Redis benchmark toolset"

COPY --from=builder /usr/local/bin/redis-benchmark /usr/bin/redis-benchmark
#COPY --from=builder /usr/local/bin/redis-cli /usr/local/bin/redis-cli

#RUN addgroup -S -g 1000 redis && adduser -S -G redis -u 1000 redis && \
#    apk add --no-cache bash

#COPY redis.conf /etc/redis/redis.conf

COPY entrypoint.sh /usr/bin/entrypoint.sh

#COPY setupMasterSlave.sh /usr/bin/setupMasterSlave.sh

#COPY healthcheck.sh /usr/bin/healthcheck.sh

#RUN chown -R redis:redis /etc/redis

#VOLUME ["/data"]

#WORKDIR /data

#EXPOSE 6379

#USER 1000

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
