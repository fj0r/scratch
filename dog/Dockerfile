FROM fj0rd/scratch:musl as musl
FROM fj0rd/io:rs as build

ENV PKG_CONFIG_ALLOW_CROSS=1
ENV OPENSSL_STATIC=true
ENV OPENSSL_DIR=/musl

COPY --from=musl /opt/openssl /musl
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

FROM scratch
COPY --from=build /opt/assets /usr/local/bin
