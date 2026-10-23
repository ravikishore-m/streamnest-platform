#!/usr/bin/env bash
# Run on TrueNAS host: builds platform-smoke and pushes to local registry.
set -euo pipefail
REGISTRY="${REGISTRY:-192.168.68.56:5000}"
USER="${REGISTRY_USER:-streamnest-robot}"
PASS="${REGISTRY_PASSWORD:-$(sudo cat /mnt/WD_Black_1TB_SSD/registry/auth/robot.pass)}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "$PASS" | sudo docker login "$REGISTRY" -u "$USER" --password-stdin
TAG="git-$(git -C "$ROOT" rev-parse --short HEAD)"
IMAGE="$REGISTRY/streamnest/platform-smoke"
sudo docker build -t "$IMAGE:$TAG" -t "$IMAGE:latest" "$ROOT/services/platform-smoke"
sudo docker push "$IMAGE:$TAG"
sudo docker push "$IMAGE:latest"
echo "Pushed $IMAGE:$TAG"
