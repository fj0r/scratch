FROM ubuntu:jammy as assets

RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        curl ca-certificates tree \
        git build-essential cmake ninja-build \
  ; mkdir -p /target \
  ;


RUN set -eux \
  ; git clone --depth=1 https://github.com/apache/arrow.git \
  ; cd arrow/cpp \
  ; mkdir build \
  ; cd build \
  ; cmake .. --preset ninja-release \
  ; cmake --build . \
  ; mv release/* /target \
  ; tree \
  ;

FROM scratch

COPY --from=assets /target /usr/local

