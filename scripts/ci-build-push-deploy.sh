#!/usr/bin/env bash
# Manual/NAS fallback for deploy steps. CI uses official GitHub Actions:
#   docker/login-action, docker/setup-buildx-action, docker/metadata-action,
#   docker/build-push-action, azure/setup-kubectl, azure/setup-helm.
#
# This script only covers Argo refresh (+ optional seeds) when Actions are unavailable.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KUBECTL="${KUBECTL:-kubectl}"

if [[ "${REPLICATE_SEEDS:-false}" == "true" ]]; then
  : "${NAS_CONFIG_ROOT:?}"
  : "${NAS_SEED_ROOT:?}"
  "$ROOT/scripts/replicate-nas-seeds.sh"
  if [[ "${APPLY_SEEDS:-false}" == "true" ]]; then
    : "${SEED_HTTP_BASE:?}"
    "$ROOT/scripts/apply-seeds-to-k8s.sh"
  fi
fi

"$KUBECTL" apply -f "$ROOT/platform/argocd/" >/dev/null
"$KUBECTL" -n argocd apply -f "$ROOT/apps/root-app.yaml" >/dev/null

APPS="${SYNC_APPS:-platform-smoke jellyfin sonarr radarr prowlarr bazarr qbittorrent seerr argocd-config}"
for app in $APPS; do
  if "$KUBECTL" -n argocd get application "$app" >/dev/null 2>&1; then
    "$KUBECTL" -n argocd annotate application "$app" \
      argocd.argoproj.io/refresh=hard --overwrite >/dev/null || true
    echo "refreshed $app"
  fi
done

echo "deploy refresh complete (image build/push is via docker/*-action in CI)"
