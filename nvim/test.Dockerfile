FROM ghcr.io/fj0r/scratch:nvim as nvim

FROM io
COPY --from=nvim / /nvim
