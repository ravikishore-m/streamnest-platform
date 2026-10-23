#!/usr/bin/env bash
# Apply streamnest seeds → app PVCs.
# Preferred path: temporary HTTP serve of seed tarballs on the NAS (read-only copies).
# Live TrueNAS Apps config dirs are never mounted and never written.
#
# Env:
#   NAS_SEED_ROOT     seed parent on the NAS
#   SEED_HTTP_BASE    e.g. http://NAS_MACVLAN_OR_HOST:9199  (where *.tgz are served)
#   KUBECTL           kubectl binary/wrapper
#
# Prep (on NAS):
#   for a in sonarr radarr ...; do tar -C "$NAS_SEED_ROOT/$a" -czf /tmp/seed-tars/$a.tgz .; done
#   docker run --rm -d --network host -v /tmp/seed-tars:/srv:ro busybox httpd -f -p 9199 -h /srv
set -euo pipefail

: "${SEED_HTTP_BASE:?Set SEED_HTTP_BASE e.g. http://nas-host:9199}"
KUBECTL="${KUBECTL:-kubectl}"
APPS="${APPS:-sonarr radarr prowlarr bazarr jellyfin qbittorrent seerr}"

apply_one() {
  local app="$1"
  local ns="$app"
  local deploy="$app"

  echo "Seeding $app from $SEED_HTTP_BASE/$app.tgz (replica only)"

  $KUBECTL -n "$ns" scale deploy/"$deploy" --replicas=0 2>/dev/null || \
    $KUBECTL -n "$ns" scale deploy -l "app.kubernetes.io/name=$app" --replicas=0 || true
  $KUBECTL -n "$ns" wait --for=delete pod -l "app.kubernetes.io/name=$app" --timeout=180s 2>/dev/null || true

  local pvc
  pvc=$($KUBECTL -n "$ns" get pvc -o name | sed -n 's#.*/##p' | grep -E 'config$' | head -1)
  pvc=${pvc:-$($KUBECTL -n "$ns" get pvc -o jsonpath='{.items[0].metadata.name}')}
  [[ -n "$pvc" ]] || { echo "no pvc in $ns" >&2; return 1; }

  $KUBECTL -n "$ns" delete job seed-http --ignore-not-found --wait=true 2>/dev/null || true

  local post=""
  case "$app" in
    sonarr|radarr|prowlarr)
      post="f=/target/config.xml; if [ -f \$f ]; then
        if grep -q '<UrlBase' \$f; then sed -i 's#<UrlBase>[^<]*</UrlBase>#<UrlBase>/${app}</UrlBase>#' \$f;
        else sed -i 's#</Config>#  <UrlBase>/${app}</UrlBase>\\n</Config>#' \$f; fi; fi"
      ;;
    jellyfin)
      post="f=/target/config/network.xml; if [ -f \$f ]; then
        if grep -q '<BaseUrl' \$f; then sed -i 's#<BaseUrl>[^<]*</BaseUrl>#<BaseUrl>/jellyfin</BaseUrl>#' \$f;
        else sed -i 's#</NetworkConfiguration>#  <BaseUrl>/jellyfin</BaseUrl>\\n</NetworkConfiguration>#' \$f; fi; fi"
      ;;
    bazarr)
      post="f=/target/config/config.yaml; [ -f \$f ] || f=/target/config.yaml;
        if [ -f \$f ]; then
          if grep -q base_url: \$f; then sed -i 's#base_url:.*#base_url: /bazarr#' \$f;
          else echo 'base_url: /bazarr' >> \$f; fi; fi"
      ;;
    seerr)
      post="f=/target/settings.json; if [ -f \$f ]; then
        sed -i 's#\"basePath\"[[:space:]]*:[[:space:]]*\"[^\"]*\"#\"basePath\": \"/seerr\"#' \$f || true; fi"
      ;;
  esac

  cat <<EOF | $KUBECTL -n "$ns" apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: seed-http
  labels:
    streamnest.io/source: nas-seed-readonly
spec:
  backoffLimit: 1
  ttlSecondsAfterFinished: 300
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: seed
          image: public.ecr.aws/docker/library/busybox:1.36
          command: ["sh", "-c"]
          args:
            - |
              set -e
              wget -q -O /tmp/seed.tgz ${SEED_HTTP_BASE}/${app}.tgz
              rm -rf /target/..?* /target/.[!.]* /target/* 2>/dev/null || true
              tar -xzf /tmp/seed.tgz -C /target
              ${post}
              echo seed complete
          volumeMounts:
            - name: target
              mountPath: /target
      volumes:
        - name: target
          persistentVolumeClaim:
            claimName: ${pvc}
EOF

  $KUBECTL -n "$ns" wait --for=condition=complete job/seed-http --timeout=900s
  $KUBECTL -n "$ns" scale deploy/"$deploy" --replicas=1 2>/dev/null || \
    $KUBECTL -n "$ns" scale deploy -l "app.kubernetes.io/name=$app" --replicas=1
  echo "ok $app"
}

for a in $APPS; do
  apply_one "$a"
done
echo "Done. Live NAS Apps were not modified."
