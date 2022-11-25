FROM fj0rd/scratch:py-test as py
FROM alpine
RUN set -eux \
  ; apk add --no-cache curl zstd
COPY --from=py /opt/python /opt/python
