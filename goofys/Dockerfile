FROM fj0rd/io:base as assets

RUN set -eux \
  ; mkdir -p /opt/assets \
  \
  ; goofys_url=$(curl -sSL https://api.github.com/repos/kahing/goofys/releases -H 'Accept: application/vnd.github.v3+json' \
             | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url') \
  ; curl -sSLo /opt/asssets/goofys ${goofys_url} \
  ; chmod +x /opt/asssets/goofys \
  ; strip -s /opt/asssets/goofys
