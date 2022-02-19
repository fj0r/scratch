FROM fj0rd/io:base as assets
RUN set -eux \
  ; mkdir -p /xetc \
  ; cfg_home=/xetc \
  ; curl -sSL https://deb.nodesource.com/setup_16.x | bash - \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
  ; apt-get install -y --no-install-recommends \
        gnupg \
        nodejs \
        build-essential \
        python3 python3-pip \
  \
  ; mkdir -p /opt/language-server \
  ; npm install -g quicktype \
                   pyright \
                   vscode-json-languageserver \
                   yaml-language-server \
  ; sed -i "s/\(exports.KUBERNETES_SCHEMA_URL = \)\(.*\)$/\1process.env['KUBERNETES_SCHEMA_URL'] || \2/" $(dirname $(which yaml-language-server))/../lib/node_modules/yaml-language-server/out/server/src/languageservice/utils/schemaUrls.js \
  ; npm cache clean -f \
  \
  ; lua_ls_url=$(curl -sSL https://api.github.com/repos/josa42/coc-lua-binaries/releases -H 'Accept: application/vnd.github.v3+json' \
               | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep 'linux') \
  ; mkdir -p /opt/language-server/sumneko_lua \
  ; curl -sSL ${lua_ls_url} | tar zxf - \
      -C /opt/language-server/sumneko_lua \
      --strip-components=1 \
  \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
  \
  ; nvim_url=$(curl -sSL https://api.github.com/repos/neovim/neovim/releases -H 'Accept: application/vnd.github.v3+json' \
             | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep -v sha256sum | grep linux64) \
  ; curl -sSL ${nvim_url} | tar zxf - -C /usr/local --strip-components=1 \
  ; strip /usr/local/bin/nvim \
  ; pip3 --no-cache-dir install \
        neovim neovim-remote \
  ; nvim_config_url=$(curl -sSL https://api.github.com/repos/fj0r/nvim-lua/releases -H 'Accept: application/vnd.github.v3+json' \
                    | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep gz) \
  ; curl -sSL ${nvim_config_url} | tar zxf - -C $cfg_home




FROM scratch

COPY --from=assets /opt /opt
COPY --from=assets /xetc /etc
