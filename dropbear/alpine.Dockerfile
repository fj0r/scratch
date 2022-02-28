FROM alpine:3 as build

RUN set -eux \
  ; apk add \
        automake autoconf gcc g++ make curl jq git \
        openssl3-dev zlib-dev \
  ; mkdir /build /target

WORKDIR /build

RUN set -eux \
  ; mkdir dropbear \
  #; export https_proxy=http://172.17.0.1:7890 \
  #; curl -sSL https://matt.ucc.asn.au/dropbear/dropbear-2020.81.tar.bz2 \
  ; dropbear_url=$(curl -sSL https://api.github.com/repos/mkj/dropbear/releases -H 'Accept: application/vnd.github.v3+json' | jq -r '.[0].tarball_url') \
  ; curl -sSL ${dropbear_url} | tar zxf - -C dropbear --strip-components=1 \
  ; cd dropbear \
  ; autoconf && autoheader && ./configure --enable-static \
  ; make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" \
  ; mkdir -p /target/bin \
  ; mv dropbear scp dropbearkey dropbearconvert /target/bin \
  ; mv dbclient /target/bin/ssh

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


