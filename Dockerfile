FROM almalinux:9 as builder

LABEL \
    AUTHOR="Stanislav V. Emets <stas@emets.su>" \
    VERSION=1.0 \
    ARCH=AMD64 \
    DESCRIPTION="A Redis benchmark toolset"

ARG REDIS_DOWNLOAD_URL="http://download.redis.io/"

ARG REDIS_VERSION="stable"

RUN dnf -y install tar make pkgconf-pkg-config gcc openssl-devel && \
    dnf clean all

RUN curl -fL -Lo /tmp/redis-${REDIS_VERSION}.tar.gz ${REDIS_DOWNLOAD_URL}/redis-${REDIS_VERSION}.tar.gz && \
    cd /tmp && \
    tar xvzf redis-${REDIS_VERSION}.tar.gz && \
    cd redis-${REDIS_VERSION}/deps && \
    make hiredis lua jemalloc linenoise hdr_histogram BUILD_TLS=yes && \
    cd .. && \
    make install BUILD_TLS=yes

FROM almalinux:9

LABEL \
    AUTHOR="Stanislav V. Emets <stas@emets.su>" \
    VERSION=1.0 \
    ARCH=AMD64 \
    DESCRIPTION="A Redis benchmark toolset"

COPY --from=builder /usr/local/bin/redis-benchmark /usr/bin/redis-benchmark
COPY entrypoint.sh /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
