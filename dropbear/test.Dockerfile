FROM ghcr.io/fj0r/scratch:dropbear-alpine as dropbear

FROM alpine:3
COPY --from=dropbear / /
COPY --from=dropbear / /dropbear

RUN set -eux \
  ; echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK2Q46WeaBZ9aBkS3TF2n9laj1spUkpux/zObmliHUOI' > ~/.ssh/authorized_keys

ENTRYPOINT /usr/bin/dropbear -REFems -p 22 -K 300 -I 600
