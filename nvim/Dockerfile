FROM fj0rd/io:base as assets
WORKDIR /root

RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
  ; apt-get install -y --no-install-recommends \
        git build-essential \
        musl musl-dev musl-tools \
        ninja-build gettext libtool libtool-bin \
        autoconf automake cmake g++ pkg-config \
        unzip curl doxygen \
  \
  ; mkdir neovim \
  #; curl -sSL https://github.com/neovim/neovim/archive/refs/tags/stable.tar.gz \
  ; curl -sSL https://github.com/neovim/neovim/archive/refs/tags/v0.8.3.tar.gz \
    | tar -zxf - -C neovim --strip-components=1 \
  ; cd neovim \
  ; CC="musl-gcc -static" make \
  ; tree /root/neovim/build \
  ;

FROM scratch
COPY --from=assets /root/neovim/build /usr/local
