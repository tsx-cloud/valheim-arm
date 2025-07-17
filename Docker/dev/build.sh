#!/bin/bash

ARCH=$(uname -m)

if [[ "$ARCH" == "aarch64" ]]; then
    echo "Building for ARM64..."
    docker build -t tsxcloud/valheim-arm:arm64 ../
elif [[ "$ARCH" == "x86_64" ]]; then
    echo "Building for AMD64..."
    docker build -t tsxcloud/valheim-arm:amd64 ../
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi
