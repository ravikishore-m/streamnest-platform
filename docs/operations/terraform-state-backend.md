# Runbook — Terraform state on TrueNAS S3

Terraform state is remote to the operator workstation but remains on the
TrueNAS host. The backend uses the native TrueNAS S3 service, not a local
state file and not MinIO. The official TrueNAS Terraform provider currently
does not expose S3 bucket or access-key resources, so this is a one-time
operator precondition rather than a fabricated Terraform resource.

## One-time NAS bootstrap

Create, using the TrueNAS UI or its supported API, all of the following:

1. A dedicated dataset for the state service with a quota and periodic
   snapshots.
2. A dedicated S3 bucket named by the private backend configuration.
3. Bucket versioning and, where supported, object-lock/retention policy.
4. A dedicated non-root S3 identity limited to that bucket.
5. TLS for the S3 endpoint using a certificate trusted by the Terraform
   runner.
6. An independent backup/export of the bucket before the first infrastructure
   apply.

Do not reuse the TrueNAS administrator credential. Do not put the endpoint,
access key, secret key, pool name, or certificate path in Git.

## Operator initialization

From a protected operator host, copy the example files to ignored local files:

```text
infrastructure/terraform/environments/streamnest/backend.hcl.example
  -> backend.hcl
infrastructure/terraform/environments/streamnest/terraform.tfvars.example
  -> terraform.tfvars
```

Export the S3 credentials only in the protected process environment, then run:

```bash
cd infrastructure/terraform/environments/streamnest
export AWS_ACCESS_KEY_ID='provided-by-private-secret-store'
export AWS_SECRET_ACCESS_KEY='provided-by-private-secret-store'
terraform init -backend-config=backend.hcl
terraform fmt -check -recursive ../../
terraform validate
terraform plan -out=streamnest.tfplan
terraform show -no-color streamnest.tfplan
terraform apply streamnest.tfplan
```

The plan file and local backend file are ignored. Do not paste their contents
into chat, CI logs, or Telegram.

## Verification and recovery

Before applying the VM, verify a state write and lock acquisition. Use two
short-lived Terraform processes against a harmless validation workspace to
confirm that a second lock attempt fails safely. Verify that the S3 bucket has
multiple object versions after a controlled state update.

For recovery, stop applies, preserve the current state object and its version
history, identify the last known-good version, and restore it through the S3
service's version-recovery workflow. Run `terraform plan` before any apply.
Never delete state versions as a routine cleanup action.
