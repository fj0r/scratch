FROM debian:testing-slim as assets

RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        curl ca-certificates ripgrep tree \
        git build-essential cmake ninja-build \
        libcurl4-openssl-dev libssl-dev \
  ; mkdir -p /target \
  ;


RUN set -eux \
  ; mkdir arrow \
  ; version=$(curl -sSL https://arrow.apache.org/install/ | rg 'Current Version: ([.0-9]+)' -or '$1') \
  ; curl -sSL https://dlcdn.apache.org/arrow/arrow-${version}/apache-arrow-${version}.tar.gz \
    | tar zxf - -C arrow --strip-components=1 \
  #; git clone --depth=1 https://github.com/apache/arrow.git \
  ; cd arrow/cpp \
  ; mkdir build \
  ; cd build \
  ; cmake .. --preset ninja-release \
        -DARROW_PARQUET=ON \
        -DARROW_S3=ON \
  ; cmake --build . \
  ; mv release/* /target \
  ; tree /target \
  ;

FROM scratch

COPY --from=assets /target /usr/lib/x86_64-linux-gnu

