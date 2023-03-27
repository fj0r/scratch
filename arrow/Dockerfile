FROM debian:testing-slim as assets

RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        curl ca-certificates jq ripgrep tree \
        git build-essential cmake ninja-build \
        libcurl4-openssl-dev libssl-dev \
  ; mkdir -p /target/lib \
  ; mkdir -p /target/a \
  ; mkdir -p /target/h/arrow \
  ; mkdir -p /target/h/parquet \
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
        -DARROW_BUILD_INTEGRATION=OFF \
        -DARROW_BUILD_STATIC=OFF \
        -DARROW_BUILD_TESTS=OFF \
        -DARROW_EXTRA_ERROR_CONTEXT=ON \
        -DARROW_WITH_RE2=OFF \
        -DARROW_JSON=ON \
        -DARROW_PARQUET=ON \
        -DARROW_S3=ON \
        -DARROW_WITH_UTF8PROC=ON \
        -DARROW_WITH_ZLIB=ON \
        -DARROW_WITH_ZSTD=ON \
  ; cmake --build . \
  ; mv release/* /target/lib \
  ;

RUN set -eux \
  #; cp -r $SRC/cpp/build/awssdk_ep-prefix/src/awssdk_ep/aws-cpp-sdk-core/include/aws /target/h \
  ; cp -r $SRC/cpp/build/awssdk_ep-install/lib/libaws-cpp-sdk-core.a /target/a/ \
  ; cp -r $SRC/cpp/build/awssdk_ep-install/lib/libaws-cpp-sdk-s3.a /target/a/ \
  ; tree /target/lib \
  \
  ; cd $SRC/cpp/src/arrow \
  ; tar -cf - $(find . -name '*.h') | tar -xf - -C /target/h/arrow/ \
  ; cp $SRC/cpp/build/src/arrow/util/config.h /target/h/arrow/util/config.h \
  \
  ; cd $SRC/cpp/src/parquet \
  ; tar -cf - $(find . -name '*.h') | tar -xf - -C /target/h/parquet/ \
  ; cp $SRC/cpp/build/src/parquet/parquet_version.h /target/h/parquet/parquet_version.h \
  \
  ; cp -r $SRC/cpp/build/awssdk_ep-install/include/aws /target/h \
  ;

FROM scratch

COPY --from=assets /target/h /usr/include
COPY --from=assets /target/a /usr/include
COPY --from=assets /target/lib /usr/lib/x86_64-linux-gnu

