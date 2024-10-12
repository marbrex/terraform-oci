# Configure the OCI Provider
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.api_private_key_path
  fingerprint      = var.api_fingerprint
  region           = var.region
}
