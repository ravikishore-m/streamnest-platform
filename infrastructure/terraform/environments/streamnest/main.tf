terraform {
  required_version = ">= 1.11.0"
  # Enable provider when applying with a local API key (never commit keys):
  # required_providers {
  #   truenas = { source = "truenas/truenas", version = ">= 1.0.0, < 2.0.0" }
  # }
}

module "k3s_streamnest" {
  source = "../../modules/vm"

  name         = "streamnest"
  description  = "Single-env k3s for streamnest-platform"
  memory_bytes = 8589934592 # 8 GiB
  vcpus        = 1
  cores        = 6
  threads      = 1
  autostart    = true
  running      = false
  # Real zvol name only in *.tfvars (gitignored) or -var
  zvol_name  = var.zvol_name
  nic_attach = var.nic_attach
}

variable "zvol_name" {
  type        = string
  description = "Zvol for the VM disk (set via tfvars; do not commit real pool paths)"
  default     = "CONFIG_POOL/vms/streamnest-disk"
}

variable "nic_attach" {
  type    = string
  default = "NIC_OR_BRIDGE"
}

output "streamnest_vm" {
  value = {
    name      = module.k3s_streamnest.planned_name
    memory    = module.k3s_streamnest.planned_memory_bytes
    autostart = module.k3s_streamnest.planned_autostart
  }
}
