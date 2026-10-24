resource "truenas_dataset" "platform" {
  name        = var.platform_dataset_name
  compression = "zstd"
  atime       = "OFF"
  share_type  = "GENERIC"
  comments    = "Streamnest platform data managed by Terraform"

  lifecycle {
    prevent_destroy = true

    precondition {
      condition     = startswith(var.platform_dataset_name, "${var.pool_name}/")
      error_message = "platform_dataset_name must be below pool_name."
    }
  }
}

resource "truenas_zvol" "vm_disk" {
  name        = var.vm_disk_name
  volsize     = var.vm_disk_size_bytes
  compression = "zstd"
  sparse      = true
  comments    = "Streamnest k3s VM disk managed by Terraform"

  lifecycle {
    prevent_destroy = true

    precondition {
      condition     = startswith(var.vm_disk_name, "${var.pool_name}/")
      error_message = "vm_disk_name must be below pool_name."
    }
  }
}

resource "truenas_vm" "k3s" {
  name        = var.name
  description = var.description
  memory      = var.memory_bytes
  vcpus       = var.vcpus
  cores       = var.cores
  threads     = var.threads
  bootloader  = "UEFI"
  cpu_mode    = "HOST-PASSTHROUGH"
  autostart   = var.autostart
  running     = var.running

  lifecycle {
    prevent_destroy = true
  }
}

resource "truenas_vm_device" "disk" {
  vm = truenas_vm.k3s.id
  attributes = jsonencode({
    dtype = "DISK"
    path  = "/dev/zvol/${truenas_zvol.vm_disk.name}"
    type  = "VIRTIO"
  })
  order      = 1000
  depends_on = [truenas_zvol.vm_disk]
}

resource "truenas_vm_device" "nic" {
  vm = truenas_vm.k3s.id
  attributes = jsonencode({
    dtype      = "NIC"
    type       = "VIRTIO"
    nic_attach = var.nic_attach
  })
  order = 2000
}

resource "truenas_periodic_snapshot_task" "platform" {
  dataset        = truenas_dataset.platform.name
  recursive      = true
  lifetime_value = 14
  lifetime_unit  = "DAY"
  naming_schema  = "streamnest-%Y-%m-%d_%H-%M"
  enabled        = true

  schedule = {
    minute = "15"
    hour   = "2"
    dom    = "*"
    month  = "*"
    dow    = "*"
  }
}
