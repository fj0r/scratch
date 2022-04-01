FROM rust AS builder

RUN set -eux \
  ; mkdir -p /target \
  ; cargo install boringtun \
  ; bin_file=$(whereis boringtun | awk '{print $2}') \
  ; strip -s $bin_file \
  ; cp $bin_file /target

FROM scratch

COPY --from=builder /target /usr/local/bin

