FROM debian:bullseye-slim as build

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		netbase \
		tzdata \
        gcc \
        make \
		zstd \
        ripgrep \
		curl \
		jq \
	; \
	rm -rf /var/lib/apt/lists/*

RUN set -eux \
  ; mkdir -p /opt/musl \
  ; mkdir -p /opt/musl-src \
  ; musl_ver=$(curl -sSL https://musl.libc.org | rg 'Latest release: <a href="(.+)">' -or '$1') \
  ; curl -sSL https://musl.libc.org/${musl_ver} | tar zxf - -C /opt/musl-src --strip-components=1 \
  ; cd /opt/musl-src \
  ; ./configure --prefix=/opt/musl --disable-shared \
  ; make \
  ; make install

FROM scratch
COPY --from=build /opt/musl /opt/musl
