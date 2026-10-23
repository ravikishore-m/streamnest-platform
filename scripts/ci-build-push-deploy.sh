#!/usr/bin/env bash
# End-to-end: build custom images → push NAS registry → refresh Argo apps.
# Run on the NAS (or self-hosted runner) with Docker + kubectl/argocd.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
: "${REGISTRY:?Set REGISTRY (host:port)}"
USER="${REGISTRY_USER:-streamnest-robot}"
: "${REGISTRY_PASSWORD:?Set REGISTRY_PASSWORD}"
KUBECTL="${KUBECTL:-kubectl}"
TAG="${IMAGE_TAG:-git-$(git -C "$ROOT" rev-parse --short HEAD)}"

echo "$REGISTRY_PASSWORD" | docker login "$REGISTRY" -u "$USER" --password-stdin

build_push() {
  local name="$1" context="$2"
  local image="$REGISTRY/streamnest/$name"
  docker build -t "$image:$TAG" -t "$image:latest" "$context"
  docker push "$image:$TAG"
  docker push "$image:latest"
  echo "pushed $image:$TAG"
}

# Custom images under services/
if [[ -f "$ROOT/services/platform-smoke/Dockerfile" ]]; then
  build_push platform-smoke "$ROOT/services/platform-smoke"
fi

# Optional: one-way seed refresh before sync (never touches live apps for write)
if [[ "${REPLICATE_SEEDS:-false}" == "true" ]]; then
  : "${NAS_CONFIG_ROOT:?}"
  : "${NAS_SEED_ROOT:?}"
  "$ROOT/scripts/replicate-nas-seeds.sh"
  if [[ "${APPLY_SEEDS:-false}" == "true" ]]; then
    "$ROOT/scripts/apply-seeds-to-k8s.sh"
  fi
fi

# Ensure Argo platform config is present
$KUBECTL apply -f "$ROOT/platform/argocd/" >/dev/null
$KUBECTL -n argocd apply -f "$ROOT/apps/root-app.yaml" >/dev/null

# Hard refresh Applications so digests/values pick up
APPS="${SYNC_APPS:-platform-smoke jellyfin sonarr radarr prowlarr bazarr qbittorrent seerr argocd-config}"
for app in $APPS; do
  if $KUBECTL -n argocd get application "$app" >/dev/null 2>&1; then
    $KUBECTL -n argocd annotate application "$app" \
      argocd.argoproj.io/refresh=hard --overwrite >/dev/null || true
    echo "refreshed $app"
  fi
done

echo "ci-build-push-deploy complete tag=$TAG"
