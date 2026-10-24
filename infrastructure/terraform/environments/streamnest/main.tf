module "k3s_streamnest" {
  source = "../../modules/vm"

  name                  = var.vm_name
  description           = "Single-environment k3s guest"
  pool_name             = var.pool_name
  platform_dataset_name = var.platform_dataset_name
  vm_disk_name          = var.vm_disk_name
  vm_disk_size_bytes    = var.vm_disk_size_bytes
  memory_bytes          = var.vm_memory_bytes
  vcpus                 = var.vm_vcpus
  cores                 = var.vm_cores
  threads               = var.vm_threads
  nic_attach            = var.vm_nic_attach
  autostart             = var.vm_autostart
  running               = var.vm_running
}
