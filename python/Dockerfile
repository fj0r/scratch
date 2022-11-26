FROM debian:bullseye-slim as build
ENV LANG C.UTF-8
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		netbase \
		tzdata \
		zstd \
		ripgrep \
		curl \
		jq \
	; \
	rm -rf /var/lib/apt/lists/*

ARG PYTHON_VERSION=3.10
RUN set -eux \
  ; mkdir -p /opt/python \
  ; py_url=$(curl -sSL https://api.github.com/repos/indygreg/python-build-standalone/releases -H 'Accept: application/vnd.github.v3+json' \
          | jq -r '[.[]|select(.prerelease == false)][0].assets[].browser_download_url' \
          | grep -v sha256 \
          | grep ${PYTHON_VERSION} \
          | grep x86_64-unknown-linux-musl-install_only) \
  ; curl -sSL ${py_url} | tar zxf - -C /opt/python --strip-components=1 \
  ; tar -C /opt -cf - python | zstd -T0 -19 > /target/python.tar.zst

FROM scratch
COPY --from=build /target /
