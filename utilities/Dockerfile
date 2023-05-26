FROM scratch:dog as dog
FROM ubuntu:latest as assets

COPY --from=dog /opt/assets /opt/assets/
RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
      ca-certificates curl jq binutils xz-utils \
  ; mkdir -p /opt/assets \
  \
  ; xh_url=$(curl -sSL https://api.github.com/repos/ducaale/xh/releases -H 'Accept: application/vnd.github.v3+json' \
           | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep x86_64-unknown-linux-musl) \
  ; curl -sSL ${xh_url} | tar zxf - -C /opt/assets --strip-components=1 --wildcards '*/xh' \
  ; cd /opt/assets && ln -s ./xh ./xhs \
  ; cp /opt/assets/xh /usr/local/bin \
  \
  ; rq_url=$(curl -sSL https://api.github.com/repos/dflemstr/rq/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep 'x86_64-unknown-linux-gnu') \
  ; curl -sSL ${rq_url} | tar zxf - -C /opt/assets \
  \
  ; yq_url=$(curl -sSL https://api.github.com/repos/mikefarah/yq/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep 'linux_amd64.tar') \
  ; curl -sSL ${yq_url} | tar zxf - && mv yq_linux_amd64 /opt/assets/yq \
  \
  ; fd_url=$(curl -sSL https://api.github.com/repos/sharkdp/fd/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep x86_64-unknown-linux-musl) \
  ; curl -sSL ${fd_url} | tar zxf - -C /opt/assets --strip-components=1 --wildcards '*/fd' \
  \
  ; sd_url=$(curl -sSL https://api.github.com/repos/chmln/sd/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep x86_64-unknown-linux-musl) \
  ; curl -sSL ${sd_url} -o /opt/assets/sd && chmod +x /opt/assets/sd \
  \
  ; rg_url=$(curl -sSL https://api.github.com/repos/BurntSushi/ripgrep/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep x86_64-unknown-linux-musl) \
  ; curl -sSL ${rg_url} | tar zxf - -C /opt/assets --strip-components=1 --wildcards '*/rg' \
  \
  ; dust_url=$(curl -sSL https://api.github.com/repos/bootandy/dust/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep x86_64-unknown-linux-musl) \
  ; curl -sSL ${dust_url} | tar zxf - -C /opt/assets --strip-components=1 --wildcards '*/dust' \
  \
  ; just_url=$(curl -sSL https://api.github.com/repos/casey/just/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep x86_64-unknown-linux-musl) \
  ; curl -sSL ${just_url} | tar zxf - -C /opt/assets just \
  \
  ; watchexec_url=$(curl -sSL https://api.github.com/repos/watchexec/watchexec/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease==false and (.tag_name|startswith("cli")))][0].assets[].browser_download_url' | grep 'x86_64-unknown-linux-musl.tar') \
  ; curl -sSL ${watchexec_url} | tar Jxf - --strip-components=1 -C /opt/assets --wildcards '*/watchexec' \
  \
  ; btm_url=$(curl -sSL https://api.github.com/repos/ClementTsang/bottom/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep x86_64-unknown-linux-musl) \
  ; curl -sSL ${btm_url} | tar zxf - -C /opt/assets btm \
  #\
  #; websocat_url=$(curl -sSL https://api.github.com/repos/vi/websocat/releases -H 'Accept: application/vnd.github.v3+json' \
  #        | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep linux64) \
  #; curl -sSLo /opt/assets/websocat ${websocat_url} ; chmod +x /opt/assets/websocat \
  \
  ; find /opt/assets -type f -exec grep -IL . "{}" \; | xargs -L 1 strip -s

FROM scratch

COPY --from=assets /opt/assets /usr/local/bin
