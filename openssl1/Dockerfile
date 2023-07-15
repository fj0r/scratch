FROM rust as rs

ENV PKG_CONFIG_ALLOW_CROSS=1
ENV OPENSSL_STATIC=true
ENV OPENSSL_DIR=/musl
RUN set -eux \
  ; mkdir /musl \
  ; mkdir /build \
  ; ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/x86_64-linux-musl/asm \
  ; ln -s /usr/include/asm-generic /usr/include/x86_64-linux-musl/asm-generic \
  ; ln -s /usr/include/linux /usr/include/x86_64-linux-musl/linux \
  ; openssl_ver=$(curl --retry 3 -sSL https://github.com/openssl/openssl/tags | rg '>(OpenSSL_1.+)</a>' -or '$1' | head -n 1) \
  ; curl --retry 3 -sSL https://github.com/openssl/openssl/archive/${openssl_ver}.tar.gz | tar zxf - -C /build --strip-components=1 \
  ; cd /build \
  ; CC="musl-gcc -fPIE -pie" ./Configure no-shared no-async --prefix=/musl --openssldir=/musl/ssl linux-x86_64 \
  ; make depend && make -j$(nproc) && make install

FROM scratch
COPY --from=rs /musl /musl
