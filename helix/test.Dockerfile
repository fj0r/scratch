FROM fj0rd/scratch:helix as helix

FROM io
COPY --from=helix / /helix
