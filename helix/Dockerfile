FROM ghcr.io/fj0r/io:base as assets
RUN set -eux \
  ; mkdir -p /target/etc/helix \
  ; mkdir -p /target/usr/local/bin \
  \
  ; helix_url=$(curl --retry 3 -sSL https://api.github.com/repos/helix-editor/helix/releases -H 'Accept: application/vnd.github.v3+json' \
      | jq -r '.[0].assets[].browser_download_url' | grep x86_64-linux) \
  ; curl --retry 3 -sSL ${helix_url} | tar Jxf - -C /target/usr/local/bin --strip-components=1 \
  #; strip /target/usr/local/bin/hx \
  ; curl --retry 3 -sSL https://raw.githubusercontent.com/fj0r/configuration/main/helix/config.toml > /target/etc/helix/config.toml




FROM scratch

COPY --from=assets /target /
