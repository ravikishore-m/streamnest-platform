# Runbook — Vault initialization and recovery

Vault is deployed by the Argo CD `vault` Application using the official
HashiCorp chart, standalone file storage, a dedicated PVC, and in-cluster TLS.
This is intentionally a single-node, non-HA deployment because the current
topology has one k3s VM. It is not Vault development mode.

## Preconditions

- The `cert-manager` Application is healthy.
- The `vault-server-tls` Certificate is Ready.
- The Vault StatefulSet has a running pod and its PVC is bound.
- The operator has a private, offline location for the initialization output.

## Initialize once

Run from an operator host with the protected kubeconfig. The command prints
unseal key shares and a root token; capture them directly into the approved
offline secret store and do not paste them into a shell transcript, Git,
Telegram, or an issue.

```bash
kubectl -n vault exec -it vault-0 -- \
  vault operator init -key-shares=5 -key-threshold=3
```

Unseal the pod by providing three different key shares from the offline
store. Do not place the keys in a ConfigMap or repository file:

```bash
kubectl -n vault exec -it vault-0 -- vault operator unseal
kubectl -n vault exec -it vault-0 -- vault operator unseal
kubectl -n vault exec -it vault-0 -- vault operator unseal
```

The prompt accepts a key through standard input. Avoid command-line arguments
that could be recorded in process listings. Authenticate only for the
specific bootstrap actions required, then revoke the initial root token after
creating narrowly scoped operator and workload auth paths.

## Verify

```bash
kubectl -n vault exec vault-0 -- \
  env VAULT_ADDR=https://127.0.0.1:8200 \
  vault status -tls-skip-verify
kubectl -n vault get statefulset,pod,pvc
```

The TLS skip flag is only for the in-pod loopback health check. Clients should
use the service certificate and the cluster CA trust path. Confirm audit
logging, Kubernetes auth, least-privilege policies, and a test secret before
making an application depend on Vault.

## Recovery

Restore the Vault data PVC from the tested backup, restore the unseal/recovery
material from the offline secret store, and follow the same unseal procedure.
Do not delete the PVC to force initialization. After recovery, verify the
audit log, auth methods, policies, and a read-only application health check.

The single-node file backend is a deliberate availability limitation. A
future HA change requires a new ADR, a tested Raft or external storage design,
and a recovery drill before production use.
