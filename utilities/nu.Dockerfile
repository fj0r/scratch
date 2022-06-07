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


FROM ubuntu:jammy as assets

COPY --from=rs /opt/assets /opt/assets/
RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
      ca-certificates curl jq binutils xz-utils \
  ; mkdir -p /opt/assets \
  \
  ; nu_url=$(curl -sSL https://api.github.com/repos/nushell/nushell/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep linux) \
  ; curl -sSL ${nu_url} | tar zxf - -C /opt/assets --strip-components=2 --wildcards '*/*/nu*' \
  \
  ; rg_url=$(curl -sSL https://api.github.com/repos/BurntSushi/ripgrep/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep x86_64-unknown-linux-musl) \
  ; curl -sSL ${rg_url} | tar zxf - -C /opt/assets --strip-components=1 --wildcards '*/rg' \
  \
  ; btm_url=$(curl -sSL https://api.github.com/repos/ClementTsang/bottom/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep x86_64-unknown-linux-musl) \
  ; curl -sSL ${btm_url} | tar zxf - -C /opt/assets btm \
  \
  ; find /opt/assets -type f -exec grep -IL . "{}" \; | xargs -L 1 strip -s

FROM scratch

COPY --from=assets /opt/assets /usr/local/bin