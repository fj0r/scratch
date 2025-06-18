FROM debian:bookworm-slim as build

RUN set -eux \
  ; apt-get update \
  ; DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        git gnupg build-essential curl jq ca-certificates \
        automake autoconf \
        # libz libcrypto
        libssl-dev zlib1g-dev \
  ; mkdir /build /target

WORKDIR /build

RUN set -eux \
  ; mkdir dropbear \
  ; dropbear_url=$(curl --retry 3 -sSL https://api.github.com/repos/mkj/dropbear/releases -H 'Accept: application/vnd.github.v3+json' | jq -r '.[0].tarball_url') \
  ; curl --retry 3 -sSL ${dropbear_url} | tar zxf - -C dropbear --strip-components=1 \
  ; cd dropbear \
  ; autoconf \
  ; autoheader \
  ; ./configure --enable-static \
  ; make PROGRAMS="dropbear dbclient scp dropbearkey dropbearconvert" \
  ; mkdir -p /target/bin \
  ; mv dbclient dropbear scp dropbearkey dropbearconvert /target/bin

RUN set -eux \
  ; git clone --depth=1 https://github.com/openssh/openssh-portable.git \
  ; cd openssh-portable \
  ; autoreconf \
  ; ./configure \
  ; make sftp-server \
  ; mkdir -p /target/libexec \
  ; mv sftp-server /target/libexec

FROM scratch

COPY --from=build /target /usr


