FROM fj0rd/scratch:dropbear-alpine as dropbear

FROM alpine:3
COPY --from=dropbear / /
COPY --from=dropbear / /dropbear

ENV pubkey=
RUN set -eux \
  ; sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
  # alpine
  ; apk add libcrypto3 \
  ; mkdir /etc/dropbear ~/.ssh \
  ; echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK2Q46WeaBZ9aBkS3TF2n9laj1spUkpux/zObmliHUOI' > ~/.ssh/authorized_keys

ENTRYPOINT /usr/bin/dropbear -REFms -p 22
