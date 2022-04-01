FROM fj0rd/io:base as assets
ARG url=
WORKDIR /root

RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
  ; apt-get install -y --no-install-recommends \
        ninja-build gettext libtool libtool-bin \
        autoconf automake cmake g++ pkg-config \
        unzip curl doxygen \
  \
  ; git clone ${url} \
  ; cd neovim \
  ; make

FROM scratch
COPY --from=assets /root/neovim/build/bin/nvim /usr/local/bin/nvim
