# Project status

**Phase:** Infrastructure code path implemented; live target validation pending
**Authorship:** no AI/agent `Co-authored-by` trailers are permitted

## Topology

**Single environment** — one k3s VM/cluster (`streamnest`). No staging/prod split (ADR 0006).

Live Jellyfin remains on the NAS app layer until an explicit cutover.

## Implemented in this repository

- Single-env GitOps layout (`apps/`, charts, Terraform/Ansible shapes)
- Privacy hygiene (D12): inventory out of Git; `SECURITY.md` + CI secret checks
- Terraform resources for the supported TrueNAS provider surface: VM, zvol,
  platform dataset, NIC/disk devices, and periodic snapshots.
- A versioned TrueNAS S3 backend contract with state locking and recovery
  instructions; bucket/access credentials remain an operator precondition.
- Ansible playbooks for the guest baseline, k3s, and pinned Argo CD bootstrap.
- Argo-managed cert-manager and Vault definitions with internal TLS.
- Separate CI paths for infrastructure validation and application image work.
- Floci 2.3.0 CI contract checks for disposable S3, SQS, Secrets Manager, and
  IAM API compatibility; this is not a NAS runtime or production cloud layer.
- Shell operational entrypoints removed; Path 1 uses Terraform/Ansible and
  Path 2 uses GitHub Actions/Argo CD.

## Verified only by local repository checks

- Helm charts and Argo app manifests (repo URL set to public GitHub remote)
- ADRs and architecture (no site inventory)
- Terraform formatting and YAML syntax checks run locally.
- Live VM, k3s, Argo CD, Vault, storage, DNS, ingress, and playback status
  still require execution from an approved operator host against the NAS.
- Floci CI evidence does not replace live TrueNAS, k3s, Vault, Argo CD, or
  Jellyfin verification.

## Not in Git (private)

- Hostnames, LAN/Tailscale IPs, MagicDNS
- Pool/dataset/zvol paths, disk models/serials
- SSH users/aliases, API keys, kubeconfigs, `secrets.yaml`
- Media library sizes and personal paths
- Agent/Telegram configuration

Use `config/local.yaml` (from `config/local.example.yaml`) and `docs/private/`.

## Next

1. From a protected operator host, initialize/validate the TrueNAS S3 state
   bucket and run a reviewed Terraform plan.
2. Apply the VM, configure k3s with Ansible, and bootstrap Argo CD.
3. Verify cert-manager and Vault initialization/recovery before enabling apps.
4. Deploy the parallel Jellyfin workload only after storage and health tests;
   keep the live NAS App untouched until explicit cutover approval.

External Let's Encrypt ingress and a private NAS OCI registry are not claimed
as complete: both require target-side DNS, network, credential, and recovery
tests. GHCR is the current custom-image registry in CI.
