FROM ghcr.io/fj0r/io:go as assets

WORKDIR /build

RUN set -eux \
  ; mkdir -p /target/linux_amd64 \
  ; git clone https://github.com/tailscale/tailscale.git \
  ; cd tailscale \
  ; go run github.com/tailscale/depaware --update tailscale.com/cmd/tailscaled \
  ; go run github.com/tailscale/depaware --update tailscale.com/cmd/tailscale \
  ; GOOS=linux GOARCH=amd64 go install tailscale.com/cmd/derper \
  ; mv $GOPATH/bin/derper /target \
  ; GOOS=linux GOARCH=amd64 go install tailscale.com/cmd/tailscale tailscale.com/cmd/tailscaled \
  ; mv $GOPATH/bin/tailscale $GOPATH/bin/tailscaled /target/linux_amd64 \
  ; GOOS=windows GOARCH=amd64 go install tailscale.com/cmd/tailscale tailscale.com/cmd/tailscaled \
  ; mv $GOPATH/bin/windows_amd64 /target \
  ; GOOS=darwin GOARCH=amd64 go install tailscale.com/cmd/tailscale tailscale.com/cmd/tailscaled \
  ; mv $GOPATH/bin/darwin_amd64  /target


FROM scratch

COPY --from=assets /target /
