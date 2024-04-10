FROM debian:bookworm-slim as assets

ENV SRC=/tmp/build
RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        curl ca-certificates jq ripgrep tree \
        git build-essential ninja-build cmake \
        libcurl4-openssl-dev libssl-dev uuid-dev zlib1g-dev libpulse-dev \
  \
  ; nu_ver=$(curl --retry 3 -sSL https://api.github.com/repos/nushell/nushell/releases/latest | jq -r '.tag_name') \
  ; nu_url="https://github.com/nushell/nushell/releases/download/${nu_ver}/nu-${nu_ver}-x86_64-unknown-linux-musl.tar.gz" \
  ; curl --retry 3 -sSL ${nu_url} | tar zxf - -C /usr/local/bin --strip-components=1 --wildcards '*/nu' '*/nu_plugin_query' \
  \
  ; mkdir -p $SRC \
  ; mkdir -p /target/lib \
  ; mkdir -p /target/include \
  ;


RUN set -eux \
  ; cd $SRC \
  ; git clone --recurse-submodules https://github.com/aws/aws-sdk-cpp \
  ; cd aws-sdk-cpp \
  ; mkdir sdk_build \
  ; cd sdk_build \
  ; cmake .. -DCMAKE_BUILD_TYPE=Release \
        #-DCMAKE_PREFIX_PATH=/target \
        -DCMAKE_INSTALL_PREFIX=/target \
        -DBUILD_ONLY="s3" \
  ; make -j8 \
  ; make install \
  ; nu -c "for i in (glob '/target/lib/*' -F -S) { rm -rf \$i }" \
  ;

RUN set -eux \
  ; mkdir -p /target/include/arrow \
  ; mkdir -p /target/include/parquet \
  ; cd $SRC \
  ; git clone https://github.com/apache/arrow.git \
  ; cd arrow/cpp \
  ; mkdir build \
  ; cd build \
  # https://github.com/apache/arrow/blob/main/cpp/CMakePresets.json
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
  \
  ; cd $SRC/arrow/cpp/src/arrow \
  ; tar -cf - $(find . -name '*.h') | tar -xf - -C /target/include/arrow/ \
  ; cp $SRC/arrow/cpp/build/src/arrow/util/config.h /target/include/arrow/util/config.h \
  \
  ; cd $SRC/arrow/cpp/src/parquet \
  ; tar -cf - $(find . -name '*.h') | tar -xf - -C /target/include/parquet/ \
  ; cp $SRC/arrow/cpp/build/src/parquet/parquet_version.h /target/include/parquet/parquet_version.h \
  ;

FROM scratch
COPY --from=assets /target /usr
