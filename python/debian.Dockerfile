ARG BASEIMAGE=debian:bookworm-slim
FROM ${BASEIMAGE}
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
	    python3 python3-pip \
	; rm -rf /var/lib/apt/lists/*

