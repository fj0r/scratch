FROM fj0rd/scratch:musl as musl

FROM ubuntu
COPY --from=musl / /
