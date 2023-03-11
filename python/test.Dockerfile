FROM fj0rd/scratch:py as py
FROM debian:testing-slim as tar
COPY --from=py /python.tar.zst /
RUN set -eux \
  ; apt-get update \
  ; apt-get install -y --no-install-recommends zstd \
  ; mkdir -p /opt/python \
  ; cat /python.tar.zst | zstd -d -T0 | tar -xf - -C /opt/python --strip-components=1

FROM debian:testing-slim
RUN set -eux \
  ; apt-get update \
  ; apt-get install -y --no-install-recommends zstd curl \
  ; rm -rf /var/lib/apt/lists/*

COPY --from=tar /opt/python /opt/python
