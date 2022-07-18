FROM rust AS builder

RUN set -eux \
  ; mkdir -p /target \
  ; cargo install boringtun-cli \
  ; bin_file=$(whereis boringtun-cli | awk '{print $2}') \
  ; strip -s $bin_file \
  ; cp $bin_file /target

FROM scratch

COPY --from=builder /target /usr/local/bin

