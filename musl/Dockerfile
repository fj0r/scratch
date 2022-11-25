FROM debian:bullseye-slim as build

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		netbase \
		tzdata \
		build-essential \
		zstd \
        ripgrep \
		curl \
		jq \
        tree \
	; \
	rm -rf /var/lib/apt/lists/*

RUN set -eux \
  ; mkdir -p /opt/musl \
  ; mkdir -p /opt/musl-src \
  ; musl_ver=$(curl -sSL https://musl.libc.org | rg 'Latest release: <a href="(.+)">' -or '$1') \
  ; curl -sSL https://musl.libc.org/${musl_ver} | tar zxf - -C /opt/musl-src --strip-components=1 \
  ; cd /opt/musl-src \
  ; ./configure --prefix=/opt/musl --disable-shared \
  ; make \
  ; make install \
  ; tree /opt/musl

ENV PKG_CONFIG_ALLOW_CROSS=1
ENV OPENSSL_STATIC=true
ENV OPENSSL_DIR=/opt/musl

RUN set -eux \
  ; mkdir -p /opt/openssl-src \
  ; ln -s /usr/include/x86_64-linux-gnu/asm /opt/musl/include/x86_64-linux-musl/asm \
  ; ln -s /usr/include/asm-generic /opt/musl/include/x86_64-linux-musl/asm-generic \
  ; ln -s /usr/include/linux /opt/musl/include/x86_64-linux-musl/linux \
  #curl -sSL https://api.github.com/repos/openssl/openssl/git/refs/tags -H 'Accept: application/vnd.github.v3+json' \
  #  | jq '[.[]|select(.name | test("11"))]' \
  ; openssl_ver=$(curl -sSL https://github.com/openssl/openssl/tags | rg '>(OpenSSL_1.+)</a>' -or '$1' | head -n 1) \
  ; curl -sSL https://github.com/openssl/openssl/archive/${openssl_ver}.tar.gz | tar zxf - -C /opt/openssl-src --strip-components=1 \
  ; cd /opt/openssl-src \
  ; CC="/opt/musl/bin/musl-gcc -fPIE -pie" ./Configure no-shared no-async --prefix=/opt/musl --openssldir=/opt/musl/ssl linux-x86_64 \
  ; make depend && make -j$(nproc) && make install

FROM scratch
COPY --from=build /opt/musl /opt/musl
