FROM ghcr.io/fj0r/scratch:helix as helix

FROM io
COPY --from=helix / /helix
