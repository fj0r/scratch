FROM fj0rd/scratch:openssl1 as openssl
FROM io:rs as rs

ENV PKG_CONFIG_ALLOW_CROSS=1
ENV OPENSSL_STATIC=true
ENV OPENSSL_DIR=/musl
WORKDIR /world

COPY --from=openssl / /
