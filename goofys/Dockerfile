FROM ghcr.io/fj0r/io as assets

RUN set -eux \
  ; mkdir -p /target \
  \
  ; goofys_url=$(curl --retry 3 -sSL https://api.github.com/repos/kahing/goofys/releases -H 'Accept: application/vnd.github.v3+json' \
             | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url') \
  ; curl --retry 3 -sSLo /target/goofys ${goofys_url} \
  ; chmod +x /target/goofys \
  ; strip -s /target/goofys

FROM scratch

COPY --from=assets /target/goofys /usr/local/bin/goofys
