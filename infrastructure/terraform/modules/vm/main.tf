# Provider is declared by calling environments. This module is validation/shape-only until Phase 3.

variable "name" {
  type        = string
  description = "VM name"
}

variable "description" {
  type    = string
  default = ""
}

variable "memory_bytes" {
  type        = number
  description = "Guest RAM in bytes"
  validation {
    condition     = var.memory_bytes >= 2147483648 && var.memory_bytes <= 17179869184
    error_message = "memory_bytes must be between 2 GiB and 16 GiB for this host budget."
  }
}

variable "vcpus" {
  type    = number
  default = 1
}

variable "cores" {
  type = number
}

variable "threads" {
  type    = number
  default = 1
}

variable "autostart" {
  type    = bool
  default = false
}

variable "zvol_name" {
  type        = string
  description = "Existing or managed zvol full name, e.g. WD_Black_1TB_SSD/vms/k3s-staging-disk"
}

variable "nic_attach" {
  type    = string
  default = "enp4s0"
}

variable "running" {
  type    = bool
  default = false
}

# Concrete resource blocks are enabled in Phase 3 after API key + plan review.
# This module documents the intended shape and input validation only until then.

output "planned_name" {
  value = var.name
}

output "planned_memory_bytes" {
  value = var.memory_bytes
}

output "planned_autostart" {
  value = var.autostart
}
