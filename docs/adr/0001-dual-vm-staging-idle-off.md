# ADR 0001 — Dual k3s VMs with staging idle-off

## Status

Accepted (2026-10-23)

## Context

31 GiB host RAM with live Jellyfin (QSV), *arr stack, OpenACP, and 8 GiB ARC. Separate production and staging Kubernetes clusters are required; namespaces-only isolation was rejected. Always-on dual VMs risk memory pressure under stream+transcode load.

## Options

1. Dual always-on VMs  
2. Dual VMs, staging powered off when idle (**chosen**)  
3. Staging-only VM first, production later  
4. Single cluster + namespaces  

## Decision

Provision two Linux VMs on TrueNAS (WD SSD zvols), each running single-node k3s:

| VM | Role | Autostart | Nominal size |
|----|------|-----------|--------------|
| `k3s-prod` | Production | On (after acceptance) | 6 vCPU / 8 GiB / 80–100 GiB disk |
| `k3s-staging` | Staging / CI validation | **Off** when idle | 4 vCPU / 4–6 GiB / 64 GiB disk |

Start staging for GitOps validation, smoke tests, and rollout failure drills; stop when idle to protect streaming headroom.

## Consequences

- True environment isolation (separate kube-apiservers, secrets, etcd).  
- Staging availability is on-demand; CI must tolerate start latency or a warm window.  
- Single physical host remains a SPOF (not physically HA).  

## Security

Separate kubeconfigs, Vault namespaces/paths, and image-pull credentials per cluster. No shared prod secrets in staging.

## Recovery

Document VM start/stop runbooks; GitOps remains source of truth if a cluster is rebuilt.
