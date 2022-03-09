FROM rust AS builder

RUN set -eux \
  ; apt update \
  ; apt-get install -y --no-install-recommends \
        cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 \
  ; git clone https://github.com/alacritty/alacritty.git \
  ; cd alacritty \
  ; cargo build --release \
  ; bin_file=$(whereis alacritty | awk '{print $2}') \
  ; strip -s $bin_file \
  ; cp $bin_file /target

FROM scratch

COPY --from=builder /target /usr/local/bin

