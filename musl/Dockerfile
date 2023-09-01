FROM debian:bookworm-slim as build

ENV PKG_CONFIG_ALLOW_CROSS=1
ENV OPENSSL_STATIC=true
ENV OPENSSL_DIR=/musl
RUN set -eux \
  ; apt-get update \
  ; apt-get install -y --no-install-recommends \
        ca-certificates \
        netbase \
        tzdata \
        build-essential \
        zstd \
        ripgrep \
        curl \
        jq \
        tree \
        linux-libc-dev \
  ; rm -rf /var/lib/apt/lists/* \
  \
  ; mkdir -p /opt/musl \
  ; mkdir -p /opt/musl-src \
  ; musl_ver=$(curl --retry 3 -sSL https://musl.libc.org | rg 'Latest release: <a href="(.+)">' -or '$1') \
  ; curl --retry 3 -sSL https://musl.libc.org/${musl_ver} | tar zxf - -C /opt/musl-src --strip-components=1 \
  ; cd /opt/musl-src \
  ; ./configure --prefix=/opt/musl --disable-shared \
  ; make \
  ; make install \
  ; tree /opt/musl \
  \
  ; curl --retry 3 -sSL https://musl.cc/x86_64-linux-musl-cross.tgz | tar zxf - -C /opt/musl --strip-components=1 \
  \
  ; mkdir -p /opt/musl/include/x86_64-linux-musl \
  ; ln -s /usr/include/x86_64-linux-gnu/asm /opt/musl/include/x86_64-linux-musl/asm \
  ; ln -s /usr/include/asm-generic /opt/musl/include/x86_64-linux-musl/asm-generic \
  ; ln -s /usr/include/linux /opt/musl/include/x86_64-linux-musl/linux


RUN set -eux \
  ; mkdir -p /opt/openssl \
  ; mkdir -p /opt/openssl-src \
  ; openssl_ver=$(curl --retry 3 -sSL https://github.com/openssl/openssl/tags | rg '>(OpenSSL_1.+)</a>' -or '$1' | head -n 1) \
  ; curl --retry 3 -sSL https://github.com/openssl/openssl/archive/${openssl_ver}.tar.gz | tar zxf - -C /opt/openssl-src --strip-components=1 \
  \
  ; cd /opt/openssl-src \
  ; CC="/opt/musl/bin/x86_64-linux-musl-gcc -fPIE -pie" \
    ./Configure \
        --prefix=/opt/openssl \
        --openssldir=/opt/musl/ssl \
        no-shared \
        no-async \
        no-engine \
        linux-x86_64 \
        #-DOPENSSL_NO_SECURE_MEMORY \
  ; make depend && make -j$(nproc) && make install

FROM debian:bookworm-slim
COPY --from=build /opt/musl /opt/musl
COPY --from=build /opt/openssl /opt/openssl
RUN set -eux \
  ; apt-get update \
  ; apt-get install -y --no-install-recommends \
        curl ca-certificates \
        ripgrep jq tree \
        build-essential \
  ; rm -rf /var/lib/apt/lists/* \
  ; dust_ver=$(curl --retry 3 -sSL https://api.github.com/repos/bootandy/dust/releases/latest | jq -r '.tag_name') \
  ; dust_url="https://github.com/bootandy/dust/releases/latest/download/dust-${dust_ver}-x86_64-unknown-linux-musl.tar.gz" \
  ; curl --retry 3 -sSL ${dust_url} | tar zxf - -C /usr/local/bin --strip-components=1 --wildcards '*/dust' \
  ;
