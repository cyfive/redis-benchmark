FROM almalinux:9 as builder

ARG REDIS_DOWNLOAD_URL="https://github.com/redis/redis/archive/refs/tags"

ARG REDIS_VERSION="7.0.10"

LABEL \
    AUTHOR="Stanislav V. Emets <stas@emets.su>" \
    VERSION=${REDIS_VERSION} \
    ARCH=AMD64 \
    DESCRIPTION="A Redis benchmark container image"

RUN dnf -y install tar make pkgconf-pkg-config gcc openssl-devel && \
    dnf clean all

RUN curl -fL -Lo /tmp/redis-${REDIS_VERSION}.tar.gz ${REDIS_DOWNLOAD_URL}/${REDIS_VERSION}.tar.gz && \
    cd /tmp && \
    tar xvzf redis-${REDIS_VERSION}.tar.gz && \
    cd redis-${REDIS_VERSION}/deps && \
    make hiredis lua jemalloc linenoise hdr_histogram BUILD_TLS=yes && \
    cd .. && \
    make install BUILD_TLS=yes

FROM almalinux:9

LABEL \
    AUTHOR="Stanislav V. Emets <stas@emets.su>" \
    VERSION=${REDIS_VERSION} \
    ARCH=AMD64 \
    DESCRIPTION="A Redis benchmark container image"

COPY --from=builder /usr/local/bin/redis-benchmark /usr/bin/redis-benchmark
COPY entrypoint.sh /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
