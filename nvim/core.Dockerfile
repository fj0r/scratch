FROM fj0rd/io:latest
ENV XDG_CONFIG_HOME=/etc
ENV NVIM_PRESET=full

RUN set -eux \
  ; mkdir -p $XDG_CONFIG_HOME \
  ; mkdir -p /opt/language-server \
  \
  ; mkdir -p /usr/local \
  ; nvim_url=$(curl -sSL https://api.github.com/repos/neovim/neovim/releases -H 'Accept: application/vnd.github.v3+json' \
             | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' | grep -v sha256sum | grep linux64) \
  ; curl -sSL ${nvim_url} | tar zxf - -C /usr/local --strip-components=1 \
  ; strip /usr/local/bin/nvim \
  \
  ; rm -rf $XDG_CONFIG_HOME/nvim \
  ; git clone --depth=1 https://github.com/fj0r/nvim-lua.git $XDG_CONFIG_HOME/nvim \
  ; git clone --depth=1 https://github.com/wbthomason/packer.nvim $XDG_CONFIG_HOME/nvim/pack/packer/start/packer.nvim \
  ; nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' \
  \
  ; tsl=$(cat $XDG_CONFIG_HOME/nvim/lua/lang/treesitter_lang.json|jq -r 'join(" ")') \
  ; nvim --headless -c "TSUpdateSync ${tsl}" -c 'quit' \
  ; rm -rf $XDG_CONFIG_HOME/nvim/pack/packer/*/*/.git


