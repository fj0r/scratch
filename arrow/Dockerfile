FROM debian:testing-slim as assets

RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        curl ca-certificates ripgrep tree \
        git build-essential cmake ninja-build \
        libcurl4-openssl-dev libssl-dev \
  ; mkdir -p /target/lib \
  ; mkdir -p /target/h \
  ;


ENV SRC=/opt/src/arrow
RUN set -eux \
  ; mkdir -p $SRC \
  ; version=$(curl -sSL https://arrow.apache.org/install/ | rg 'Current Version: ([.0-9]+)' -or '$1') \
  ; curl -sSL https://dlcdn.apache.org/arrow/arrow-${version}/apache-arrow-${version}.tar.gz \
    | tar zxf - -C $SRC --strip-components=1 \
  #; git clone --depth=1 https://github.com/apache/arrow.git \
  \
  ; cd $SRC/cpp \
  ; mkdir build \
  ; cd build \
  ; cmake .. --preset ninja-release \
        -DARROW_JSON=ON \
        -DARROW_PARQUET=ON \
        -DARROW_S3=ON \
        -DARROW_WITH_UTF8PROC=ON \
        -DARROW_WITH_ZLIB=ON \
        -DARROW_WITH_ZSTD=ON \
  ; cmake --build . \
  ; mv release/* /target/lib \
  ; tree /target/lib \
  \
  ; cd $SRC/cpp/src/arrow \
  ; tar -cf - $(find . -name '*.h') | tar -xf - -C /target/h \
  ;

FROM scratch

COPY --from=assets /target/h /usr/include/arrow
COPY --from=assets /target/lib /usr/lib/x86_64-linux-gnu

