docker manifest create --amend tsxcloud/valheim-arm:latest \
  tsxcloud/valheim-arm:amd64 \
  tsxcloud/valheim-arm:arm64

docker manifest push --purge tsxcloud/valheim-arm:latest
