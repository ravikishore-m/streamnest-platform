# Floci validation boundary

Floci is used only as a disposable AWS API emulator for CI contract tests. It
does not host the platform and it is not a replacement for the TrueNAS
provider, the k3s runtime, Vault, Argo CD, or the NAS S3 state backend.

## What is real and what is emulated

| Concern | Implementation | Boundary |
| --- | --- | --- |
| NAS infrastructure | TrueNAS Terraform provider | Real TrueNAS API and resources |
| Linux guest and k3s | Ansible and k3s | Real Linux VM on TrueNAS |
| Application runtime | k3s, Helm, Argo CD | Real Kubernetes workloads on the NAS |
| Secrets | Vault | Real Vault instance in k3s, after recovery testing |
| Terraform state | TrueNAS S3-compatible service | Real NAS state backend, protected credentials |
| AWS API compatibility tests | Floci 2.3.0 | Ephemeral GitHub Actions service only |

The Floci workflow exercises S3, SQS, Secrets Manager, and IAM request
contracts without using any NAS endpoint or credential. Its test data is
intentionally disposable. A passing Floci job proves only that the tested AWS
client calls are compatible with the emulator; it does not prove that a
TrueNAS S3 backend, Vault policy, k3s cluster, or application is healthy.

## Why Floci does not host the platform

Floci emulates cloud APIs. It is not a durable production control plane with
the backup, identity, storage, upgrade, and recovery semantics required for
this single-host platform. Running it in the NAS cluster would add a second,
nested cloud-control abstraction and would make Argo CD responsible for an
emulator rather than for the actual workloads.

Jellyfin, Vault, Argo CD, observability, and the supporting media applications
remain ordinary OCI workloads in k3s. The existing NAS Apps deployment is not
modified by the Floci workflow or by this repository change.

## Version and supply-chain policy

The CI job uses the current stable Floci release `2.3.0`, pinned to its
multi-architecture image digest
`sha256:e0b292df4dc9559b7b1bf4f51bdda4bb8e269276236438cd03cae661260ea8a9`.
It does not use `latest` or a nightly tag. Before relying on a future release,
review its compatibility matrix and verify the release image signature and
digest against the upstream release evidence. The job is never a production
deployment path.

## Promotion and recovery implications

Floci test results are a CI quality gate only. They cannot authorize a
Terraform apply, a Vault initialization, an Argo production sync, a storage
migration, or a Jellyfin cutover. Those actions still require the protected
operator path documented in `docs/operations/infra-path.md` and the separate
application GitOps path.
