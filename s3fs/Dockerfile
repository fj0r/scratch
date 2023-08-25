FROM debian:bookworm-slim as build

RUN set -eux \
  ; apt-get update \
  ; DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        curl jq ca-certificates \
        build-essential git \
        libfuse-dev libcurl4-openssl-dev libxml2-dev \
        mime-support automake libtool \
        # libz libcrypto
        libssl-dev zlib1g-dev \
  ; mkdir /build /target

WORKDIR /build

RUN set -eux \
  ; mkdir s3fs \
  ; s3fs_ver=$(curl https://api.github.com/repos/s3fs-fuse/s3fs-fuse/releases/latest | jq -r '.tag_name') \
  ; s3fs_url="https://github.com/s3fs-fuse/s3fs-fuse/archive/refs/tags/${s3fs_ver}.tar.gz" \
  ; curl --retry 3 -sSL ${s3fs_url} | tar zxf - -C s3fs --strip-components=1 \
  ; cd s3fs \
  ; autoreconf --install \
  ; ./configure --prefix=/target \
  ; make && make install

FROM scratch

COPY --from=build /target /usr
