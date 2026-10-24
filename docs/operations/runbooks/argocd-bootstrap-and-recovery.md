# Runbook — Argo CD bootstrap and recovery

Normal platform bootstrap is performed by Ansible with the
`kubernetes.core.k8s` module. The module applies the pinned upstream Argo CD
manifest through the Kubernetes API, then applies the reviewed `AppProject`,
RBAC, cert-manager, Vault, and application-root resources. Manual `kubectl`
application is a recovery method only.

## Verify after bootstrap

```bash
kubectl -n argocd get deployments,pods
kubectl -n argocd get appproject streamnest
kubectl -n argocd get applications
kubectl -n cert-manager get deployments
kubectl -n vault get statefulset,pod,pvc
```

The expected result is a running Argo CD control plane, an admitted
`streamnest` AppProject, and Argo Applications for cert-manager and Vault.
Vault still requires the separate initialization and unseal procedure in
`vault-init-and-recovery.md`.

## Private operator access

Use a private, temporary port-forward when no approved ingress exists:

```bash
kubectl -n argocd port-forward svc/argocd-server 8080:443
argocd login 127.0.0.1:8080 --grpc-web --username admin
argocd app list
```

Retrieve the initial admin password only on the protected operator terminal:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 --decode
```

Rotate or replace the bootstrap credential after the first login. Never put
the password, bcrypt hash, kubeconfig, or port-forward endpoint in Git.

## Recovery

If Argo CD is unavailable, first inspect the Kubernetes control plane and
restore the Argo namespace from the pinned upstream manifest using the
Ansible playbook. Reapply the reviewed platform resources through the same
playbook, then verify that the Applications converge from Git. Do not delete
the `argocd` namespace or application PVCs as a first response.

If Git is unavailable, Kubernetes keeps the last applied resources, but no
new desired state can reconcile. Restore repository access, verify the
revision, and inspect Argo sync status before making any manual correction.
