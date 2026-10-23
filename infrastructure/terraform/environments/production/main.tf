terraform {
  required_version = ">= 1.11.0"
  # Enable truenas provider when Phase 3 apply is approved (see staging/main.tf).
}

module "k3s_prod" {
  source = "../../modules/vm"

  name         = "k3s-prod"
  description  = "Production k3s"
  memory_bytes = 8589934592 # 8 GiB
  vcpus        = 1
  cores        = 6
  threads      = 1
  autostart    = false # enable only after acceptance
  running      = false
  zvol_name    = "WD_Black_1TB_SSD/vms/k3s-prod-disk"
  nic_attach   = "enp4s0"
}

output "production_vm" {
  value = {
    name      = module.k3s_prod.planned_name
    memory    = module.k3s_prod.planned_memory_bytes
    autostart = module.k3s_prod.planned_autostart
  }
}
