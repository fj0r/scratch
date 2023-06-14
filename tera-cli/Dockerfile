FROM rust

RUN set -eux \
  ; mkdir -p /target \
  ; cargo install \
    --git https://github.com/chevdor/tera-cli \
    --target=x86_64-unknown-linux-musl \
  ; bin_file=$(whereis tera | awk '{print $2}') \
  ; strip -s $bin_file \
  ; cp $bin_file /target

FROM scratch

COPY --from=builder /target /usr/local/bin
