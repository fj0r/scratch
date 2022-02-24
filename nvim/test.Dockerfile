FROM fj0rd/scratch:nvim as nvim

FROM io
COPY --from=nvim / /nvim
