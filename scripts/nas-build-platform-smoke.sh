#!/usr/bin/env bash
# Run on TrueNAS host: builds platform-smoke and pushes to local registry.
# Set REGISTRY to the NAS registry endpoint (see docs/private/).
set -euo pipefail
: "${REGISTRY:?Set REGISTRY to host:port of the NAS OCI registry}"
USER="${REGISTRY_USER:-streamnest-robot}"
PASS="${REGISTRY_PASSWORD:?Set REGISTRY_PASSWORD or export from NAS robot.pass}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "$PASS" | sudo docker login "$REGISTRY" -u "$USER" --password-stdin
TAG="git-$(git -C "$ROOT" rev-parse --short HEAD)"
IMAGE="$REGISTRY/streamnest/platform-smoke"
sudo docker build -t "$IMAGE:$TAG" -t "$IMAGE:latest" "$ROOT/services/platform-smoke"
sudo docker push "$IMAGE:$TAG"
sudo docker push "$IMAGE:latest"
echo "Pushed $IMAGE:$TAG"
