docker manifest create --amend lucascerq/valheim-arm:latest \
  lucascerq/valheim-arm:amd64 \
  lucascerq/valheim-arm:arm64

docker manifest push --purge lucascerq/valheim-arm:latest
