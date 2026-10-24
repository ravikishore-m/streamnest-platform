provider "truenas" {
  endpoint = var.truenas_endpoint
  username = var.truenas_username
  api_key  = var.truenas_api_key

  ca_cert  = var.truenas_ca_cert != "" ? var.truenas_ca_cert : null
  insecure = var.truenas_insecure
}
