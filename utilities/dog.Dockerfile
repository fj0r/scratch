FROM fj0rd/scratch:openssl1 as openssl
FROM fj0rd/io:rs as rs

ENV PKG_CONFIG_ALLOW_CROSS=1
ENV OPENSSL_STATIC=true
ENV OPENSSL_DIR=/musl

COPY --from=openssl / /
RUN set -eux \
  ; mkdir -p /opt/assets \
  ; git clone https://github.com/ogham/dog.git \
  ; cd dog \
  ; cargo build --release --target=x86_64-unknown-linux-musl \
  ; mv target/x86_64-unknown-linux-musl/release/dog /opt/assets \
  \
  #; cargo install flamegraph \
  #; mv $(whereis flamegraph | awk '{print $2}') /opt/assets \
  \
  ; find /opt/assets -type f -exec grep -IL . "{}" \; | xargs -L 1 strip -s
