FROM rust AS builder

ENV export PKG_CONFIG_ALLOW_CROSS=1
ENV export OPENSSL_STATIC=true
ENV export OPENSSL_DIR=/musl

RUN set -eux \
  ; apt update \
  ; apt-get install -y --no-install-recommends \
        wget build-essential libssl-dev musl musl-dev musl-tools \
  ; rustup target add x86_64-unknown-linux-musl \
  ; mkdir /musl \
  #; ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/x86_64-linux-musl/asm \
  #; ln -s /usr/include/asm-generic /usr/include/x86_64-linux-musl/asm-generic \
  #; ln -s /usr/include/linux /usr/include/x86_64-linux-musl/linux \
  ; wget https://github.com/openssl/openssl/archive/OpenSSL_1_1_1n.tar.gz \
  ; tar zxf OpenSSL_1_1_1n.tar.gz \
  ; cd openssl-OpenSSL_1_1_1n/ \
  ; CC="musl-gcc -fPIE -pie" ./Configure no-shared no-async --prefix=/musl --openssldir=/musl/ssl linux-x86_64 \
  ; make depend && make -j$(nproc) && make install \
  ; cargo install drill --target=x86_64-unknown-linux-musl \
  ; strip -s $HOME/.cargo/bin/drill \
  ; cp $HOME/.cargo/bin/drill /target

FROM scratch

COPY --from=builder /target /usr/local/bin

