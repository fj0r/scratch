FROM fj0rd/io:rs as rs

ENV PKG_CONFIG_ALLOW_CROSS=1
ENV OPENSSL_STATIC=true
ENV OPENSSL_DIR=/musl
RUN set -eux \
  ; mkdir /musl \
  ; ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/x86_64-linux-musl/asm \
  ; ln -s /usr/include/asm-generic /usr/include/x86_64-linux-musl/asm-generic \
  ; ln -s /usr/include/linux /usr/include/x86_64-linux-musl/linux \
  ; curl -sSL https://github.com/openssl/openssl/archive/OpenSSL_1_1_1n.tar.gz | tar zxf - \
  ; cd openssl-OpenSSL_1_1_1n/ \
  ; CC="musl-gcc -fPIE -pie" ./Configure no-shared no-async --prefix=/musl --openssldir=/musl/ssl linux-x86_64 \
  ; make depend && make -j$(nproc) && make install

FROM scratch
COPY --from=rs /musl /musl
