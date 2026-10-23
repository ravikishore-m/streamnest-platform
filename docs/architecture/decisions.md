# Approved decisions (Phase 1 lock)

Recorded 2026-10-23 from operator approval. Ambiguous “go ahead” replies were resolved to Phase 0 recommended defaults (stated below).

| ID | Decision | Locked choice |
|----|----------|---------------|
| D1 | Topology | **A — Dual VMs, staging idle-off** (separate staging + production k3s VMs; staging powered off when not validating) |
| D2 | Live Jellyfin | **Remain on TrueNAS Apps** until staging k8s acceptance tests pass and cutover is explicitly approved |
| D3 | QSV / transcoding | **Host QSV for live Jellyfin**; **software-only** for k8s staging Jellyfin initially; **GPU passthrough deferred** until separately tested |
| D4 | TrueNAS train | **Proceed on 26.0.0-BETA.3** (accept beta risk; prefer staging VM applies before production VM) |
| D5 | Backup target | **Toshiba_HDD_1TB** as independent local backup destination (plus keep ZFS snapshots); cloud offsite deferred |
| D6 | Git remote | **Create remote and push** this repository |
| D7 | Wave-1 scope | **Parallel tracks:** platform (k3s/GitOps/CI) **and** new k8s apps for **Jellyfin + eligible streaming stack** (Seerr, *arr, qBittorrent, Navidrome, etc.) developed in repo simultaneously. Live host Apps remain until staging proof + cutover approval. |
| D8 | OpenACP hardening | **Deferred** — no k8s remediation rights until you decide |
| D9 | Existing k3s cloud-init password | **Must rotate** before starting/recreating VMs (Phase 3 prerequisite) |
| D10 | Git authorship | **Strict:** commits must **not** add Cursor / AI agent as `Co-authored-by`. Operator is sole author. |

Namespace-only isolation (option D) is **rejected** unless you reopen this decision.

## Parallel app track (D7)

| App | k8s chart / GitOps | Live today | Staging k8s | Prod k8s cutover |
|-----|--------------------|------------|-------------|------------------|
| Jellyfin | `charts/jellyfin` | TrueNAS App (QSV) | New parallel deploy (software encode) | Only after acceptance + approval |
| Seerr | `charts/seerr` | TrueNAS App | Parallel | After staging |
| Sonarr / Radarr / Prowlarr / Bazarr / qBittorrent | `charts/*` | TrueNAS Apps | Parallel | After staging |
| Navidrome | `charts/navidrome` | TrueNAS App | Parallel | After staging |
| Platform smoke | `charts/platform-smoke` | N/A | Required for CI digest proof | Promote same digest |
| Argo CD / Vault / kube-prom | `platform/*` | obs-lite on host | Cluster-native | Staging first |
