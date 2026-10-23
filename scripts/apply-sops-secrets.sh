#!/usr/bin/env bash
# Decrypt secrets/streamnest.enc.yaml and apply to the cluster without echoing values.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENC="${SOPS_FILE:-$ROOT/secrets/streamnest.enc.yaml}"
KUBECTL="${KUBECTL:-kubectl}"
export SOPS_AGE_KEY_FILE="${SOPS_AGE_KEY_FILE:-$ROOT/config/local/age.key}"

if [[ ! -f "$ENC" ]]; then
  echo "Missing $ENC — encrypt from secrets/streamnest.enc.yaml.example (see secrets/README.md)" >&2
  exit 1
fi
if [[ ! -f "$SOPS_AGE_KEY_FILE" ]]; then
  echo "Missing age key at $SOPS_AGE_KEY_FILE" >&2
  exit 1
fi
command -v sops >/dev/null || { echo "sops required" >&2; exit 1; }

extract() {
  # sops --extract '["stringData"]["key"]'
  sops -d --extract "[\"stringData\"][\"$1\"]" "$ENC" 2>/dev/null || true
}
reg_host=$(extract registryHost)
reg_user=$(extract registryUsername)
reg_pass=$(extract registryPassword)
argo_hash=$(extract argocdAdminPasswordMbcrypt)

NS_LIST="${PULL_SECRET_NAMESPACES:-jellyfin sonarr radarr prowlarr bazarr qbittorrent seerr platform-smoke}"

if [[ -n "$reg_host" && -n "$reg_user" && -n "$reg_pass" ]]; then
  AUTH=$(printf '%s:%s' "$reg_user" "$reg_pass" | base64 | tr -d '\n')
  DOCKERCFG=$(printf '{"auths":{"%s":{"username":"%s","password":"%s","auth":"%s"}}}' \
    "$reg_host" "$reg_user" "$reg_pass" "$AUTH")
  for ns in $NS_LIST; do
    $KUBECTL create namespace "$ns" --dry-run=client -o yaml | $KUBECTL apply -f - >/dev/null
    $KUBECTL -n "$ns" create secret docker-registry regcred \
      --docker-server="$reg_host" \
      --docker-username="$reg_user" \
      --docker-password="$reg_pass" \
      --dry-run=client -o yaml | $KUBECTL apply -f - >/dev/null
  done
  echo "Applied regcred to: $NS_LIST"
fi

if [[ -n "$argo_hash" && "$argo_hash" != CHANGE_ME_BCRYPT ]]; then
  # Patch Argo CD admin password hash (does not print hash)
  $KUBECTL -n argocd patch secret argocd-secret --type merge \
    -p "{\"stringData\":{\"admin.password\":\"$argo_hash\",\"admin.passwordMtime\":\"$(date -u +%FT%TZ)\"}}" \
    >/dev/null
  echo "Updated Argo CD admin password hash"
fi

echo "Secrets apply complete (values not logged)."
