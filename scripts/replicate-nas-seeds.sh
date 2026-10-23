#!/usr/bin/env bash
# One-way copy: live TrueNAS Apps config → streamnest seeds.
# READ-ONLY against live apps. Never writes back to ix-* config dirs.
#
# Required env (from config/local.yaml / docs/private — not committed):
#   NAS_CONFIG_ROOT   e.g. /mnt/POOL/configs
#   NAS_SEED_ROOT     e.g. /mnt/POOL/configs/streamnest-seeds
#
# Optional: APPS="sonarr radarr ..." (default: all known)
set -euo pipefail

: "${NAS_CONFIG_ROOT:?Set NAS_CONFIG_ROOT to the live apps config parent}"
: "${NAS_SEED_ROOT:?Set NAS_SEED_ROOT to the seed destination parent}"

# live dirname → seed name
declare -A MAP=(
  [sonarr]=sonarr
  [radarr]=radarr
  [prowlarr]=prowlarr
  [bazarr]=bazarr
  [jellyfin]=jellyfin
  [qbittorrent]=qbittorrent
  [jellyseerr]=seerr
)

APPS="${APPS:-sonarr radarr prowlarr bazarr jellyfin qbittorrent jellyseerr}"

# Never touch live trees; only read.
RSYNC_EXCLUDES=(
  --exclude='Cache/'
  --exclude='cache/'
  --exclude='transcodes/'
  --exclude='Transcodes/'
  --exclude='log/'
  --exclude='logs/'
  --exclude='*.log'
  --exclude='Sentry/'
  --exclude='crashdbs/'
)

mkdir -p "$NAS_SEED_ROOT"
echo "Replicating live configs → seeds (source remains unmodified)"
echo "  source root: $NAS_CONFIG_ROOT"
echo "  seed root:   $NAS_SEED_ROOT"

for live in $APPS; do
  seed="${MAP[$live]:-$live}"
  src="$NAS_CONFIG_ROOT/$live"
  dst="$NAS_SEED_ROOT/$seed"
  if [[ ! -d "$src" ]]; then
    echo "skip missing source: $src" >&2
    continue
  fi
  mkdir -p "$dst"
  # Archive copy into seed only. --delete keeps seed aligned with live snapshot.
  rsync -a --delete "${RSYNC_EXCLUDES[@]}" "$src/" "$dst/"
  # Marker proves this tree is a replica, not the live mount
  printf '%s\n' "replicated_from=$src" "replicated_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    "policy=read-only-source-never-write-back" >"$dst/.streamnest-seed-meta"
  echo "ok $live → $seed"
done

echo "Done. Live NAS Apps configs were not modified."
