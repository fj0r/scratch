FROM fj0rd/scratch:dog as dog
FROM debian:bookworm-slim as assets

COPY --from=dog /usr/local/bin/dog /opt/assets/
RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
      ca-certificates curl jq binutils xz-utils \
  ; mkdir -p /opt/assets \
  \
  ; nu_url=$(curl --retry 3 -sSL https://api.github.com/repos/nushell/nushell/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep x86_64-unknown-linux-musl) \
  ; curl --retry 3 -sSL ${nu_url} | tar zxf - -C /opt/assets --strip-components=1 --wildcards '*/nu' \
  \
  ; zoxide_url=$(curl --retry 3 -sSL https://api.github.com/repos/ajeetdsouza/zoxide/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep x86_64-unknown-linux-musl) \
  ; curl --retry 3 -sSL ${zoxide_url} | tar zxf - -C /opt/assets zoxide \
  \
  ; btm_url=$(curl --retry 3 -sSL https://api.github.com/repos/ClementTsang/bottom/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep x86_64-unknown-linux-musl) \
  ; curl --retry 3 -sSL ${btm_url} | tar zxf - -C /opt/assets btm \
  \
  ; dust_url=$(curl --retry 3 -sSL https://api.github.com/repos/bootandy/dust/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep x86_64-unknown-linux-musl) \
  ; curl --retry 3 -sSL ${dust_url} | tar zxf - -C /opt/assets --strip-components=1 --wildcards '*/dust' \
  \
  ; find /opt/assets -type f -exec grep -IL . "{}" \; | xargs -L 1 strip -s

FROM scratch

COPY --from=assets /opt/assets /usr/local/bin
