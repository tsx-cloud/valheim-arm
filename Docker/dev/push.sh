#!/bin/bash

ARCH=$(uname -m)

if [[ "$ARCH" == "aarch64" ]]; then
    echo "Push arm64-box..."
    docker push lucascerq/valheim-arm:arm64
elif [[ "$ARCH" == "x86_64" ]]; then
    echo "Building for amd64..."
    docker push lucascerq/valheim-arm:amd64
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi
