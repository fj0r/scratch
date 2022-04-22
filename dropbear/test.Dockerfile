FROM fj0rd/scratch:dropbear-alpine as dropbear

FROM alpine:3
COPY --from=dropbear / /
COPY --from=dropbear / /dropbear

RUN set -eux \
  ; mkdir -p /etc/dropbear ~/.ssh \
  ; echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK2Q46WeaBZ9aBkS3TF2n9laj1spUkpux/zObmliHUOI' > ~/.ssh/authorized_keys

ENTRYPOINT /usr/bin/dropbear -REFems -p 22
