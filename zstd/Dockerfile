FROM debian:testing-slim as build

RUN set -eux \
  ; apt update \
  ; apt-get install -y --no-install-recommends \
        curl gnupg ca-certificates \
        zstd xz-utils unzip tree \
        jq ripgrep git build-essential \
        musl musl-dev musl-tools \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
  \
  ; mkdir /dist \
  ; mkdir zstd \
  ; zstd_ver=$(curl -sSL https://api.github.com/repos/facebook/zstd/releases/latest | jq -r '.tag_name' | cut -c 2-) \
  ; curl -sSL https://github.com/facebook/zstd/releases/latest/download/zstd-${zstd_ver}.tar.gz \
        | tar -zxf - -C zstd --strip-components=1 \
  ; cd zstd \
  ; CC="musl-gcc -static" make \
  ; cp programs/zstd /dist \
  ;

FROM scratch
COPY --from=build /dist/zstd /usr/local/bin/zstd
