FROM fj0rd/io:base as assets
ARG url=https://github.com/neovim/neovim.git
WORKDIR /root

RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
  ; apt-get install -y --no-install-recommends \
        musl musl-dev musl-tools \
        ninja-build gettext libtool libtool-bin \
        autoconf automake cmake g++ pkg-config \
        unzip curl doxygen \
  \
  ; git clone ${url} \
  ; cd neovim \
  ; CC="musl-gcc -static" make \
  ; tree /root/neovim/build \
  ;

FROM scratch
COPY --from=assets /root/neovim/build /usr/local
