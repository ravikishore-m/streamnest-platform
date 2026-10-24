# Terraform — TrueNAS infrastructure

This path owns the TrueNAS resources that host the single k3s environment:

- platform dataset and VM zvol;
- the k3s VM and its disk/NIC devices;
- a protected periodic snapshot task for platform data.

It does not own live TrueNAS Apps, media datasets, Jellyfin metadata, Vault
objects, Argo Applications, or Kubernetes workloads. Those ownership
boundaries prevent an infrastructure apply from touching the existing Apps
deployment.

## Provider and state

The configuration uses the official `truenas/truenas` provider and the
versioned TrueNAS WebSocket API. Credentials are supplied through a private
tfvars file or environment variables. The provider supports TrueNAS 25.04+
and is fully tested by its maintainers against 26.0; the installed beta must
still be verified before an apply.

The committed `.terraform.lock.hcl` pins the provider selection and checksums.
Review lock-file changes as dependency changes; do not regenerate it during a
live apply without review.

Terraform state is remote from the operator and CI process but local to the
NAS: it uses the native TrueNAS S3 object-storage service with S3 lockfiles.
Create the state dataset, bucket, dedicated non-root S3 user/key, TLS listener,
and bucket versioning in the TrueNAS UI/API as the one-time backend bootstrap.
The official Terraform provider does not currently expose those S3 bucket and
access-key objects, so they are deliberately documented as a precondition
instead of being represented by fake Terraform resources. Keep an independent
backup of the state bucket.

TrueNAS currently documents its S3 service as experimental. The backend must
be tested with a state write, lock contention test, version recovery test, and
restore test before the first VM apply.

## Safe initialization and apply

```bash
cd infrastructure/terraform/environments/streamnest
cp backend.hcl.example backend.hcl
cp terraform.tfvars.example terraform.tfvars

# Provide AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY from the protected
# operator environment. Never put them in backend.hcl or Git.
terraform init -backend-config=backend.hcl
terraform fmt -check -recursive ../../
terraform validate
terraform plan -out=streamnest.tfplan
terraform show -no-color streamnest.tfplan
terraform apply streamnest.tfplan
```

For a new VM, the first apply uses `vm_running = false` so the disk and NIC
can be attached while the VM is stopped. After the plan succeeds, change only
that private variable to `true`, create a new reviewed plan, and apply it.

Existing resources must be imported before ownership is claimed. Use the
TrueNAS provider's import documentation and verify every imported plan is
empty before changing any value. Never use `terraform destroy` for routine
operations. The VM and platform datasets have `prevent_destroy` safeguards.

## CI policy

Pull requests may run formatting, initialization without a backend, validate,
and a plan against an isolated test configuration. Production applies require
a reviewed plan, protected environment approval, a protected runner with NAS
reachability, and the NAS API credentials outside GitHub pull-request builds.
