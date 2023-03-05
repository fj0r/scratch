FROM fj0rd/io:base as assets
WORKDIR /root

RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
  ; apt-get install -y --no-install-recommends \
        git build-essential \
        ninja-build gettext libtool-bin cmake g++ pkg-config unzip curl \
        musl musl-dev musl-tools \
        libuv1-dev libmsgpack-dev libvterm-dev \
  \
  ; mkdir neovim \
  #; curl -sSL https://github.com/neovim/neovim/archive/refs/tags/v0.8.3.tar.gz \
  ; curl -sSL https://github.com/neovim/neovim/archive/refs/tags/stable.tar.gz \
    | tar -zxf - -C neovim --strip-components=1 \
  ; cd neovim \
  ; CC="musl-gcc -static" make CMAKE_INSTALL_PREFIX=/opt/nvim CMAKE_BUILD_TYPE=Release \
  ; make install \
  ;

FROM scratch
COPY --from=assets /opt/nvim /opt/nvim

# mkdir build
# cd build
# cmake .. -G Ninja
# CC="musl-gcc -static" cmake --build .
# cd ..
# CC="musl-gcc -static" make CMAKE_INSTALL_PREFIX=/opt/nvim CMAKE_BUILD_TYPE=Release
