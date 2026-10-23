terraform {
  required_version = ">= 1.11.0"
  # Enable provider when Phase 3 apply is approved:
  # required_providers {
  #   truenas = { source = "truenas/truenas", version = ">= 1.0.0, < 2.0.0" }
  # }
  # backend — configure before first apply; never commit state
}

# provider "truenas" {
#   endpoint = var.truenas_endpoint
#   api_key  = var.truenas_api_key
#   username = var.truenas_username
# }

module "k3s_staging" {
  source = "../../modules/vm"

  name         = "k3s-staging"
  description  = "Staging k3s — idle-off when not validating"
  memory_bytes = 4294967296 # 4 GiB
  vcpus        = 1
  cores        = 4
  threads      = 1
  autostart    = false
  running      = false
  zvol_name    = "WD_Black_1TB_SSD/vms/k3s-staging-disk"
  nic_attach   = "enp4s0"
}

output "staging_vm" {
  value = {
    name      = module.k3s_staging.planned_name
    memory    = module.k3s_staging.planned_memory_bytes
    autostart = module.k3s_staging.planned_autostart
  }
}
