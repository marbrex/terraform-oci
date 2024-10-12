module "vcn" {
  source = "oracle-terraform-modules/vcn/oci"

  # provider identity parameters
  region = var.region

  # general oci parameters
  compartment_id = var.compartment_ocid
  label_prefix   = var.label_prefix

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags

  # vcn parameters
  create_internet_gateway = true
  create_nat_gateway      = false
  create_service_gateway  = false

  vcn_cidrs     = var.vcn_cidrs
  vcn_dns_label = var.vcn_dns_label
  vcn_name      = var.vcn_name

  # gateways parameters
  internet_gateway_display_name = var.internet_gateway_display_name
  nat_gateway_display_name      = var.nat_gateway_display_name
  service_gateway_display_name  = var.service_gateway_display_name

  # subnets
  subnets = var.subnets
}

module "worker_nodes" {
  source = "oracle-terraform-modules/compute-instance/oci"

  # general oci parameters
  compartment_ocid = var.compartment_ocid
  
  freeform_tags    = var.freeform_tags
  defined_tags     = var.defined_tags

  # compute instance parameters
  ad_number                   = null
  instance_count              = 4
  instance_display_name       = "worker_node"
  instance_state              = var.instance_state
  shape                       = var.shape
  source_type                 = var.source_type
  source_ocid                 = var.source_ocid
  instance_flex_memory_in_gbs = 6 # only used if shape is Flex type
  instance_flex_ocpus         = 1 # only used if shape is Flex type

  # operating system parameters
  ssh_public_keys = var.ssh_public_keys

  # networking parameters
  public_ip = var.public_ip # NONE, RESERVED or EPHEMERAL
  subnet_ocids = [
    module.vcn.subnet_id.subnet1
  ]

  # storage parameters
  boot_volume_backup_policy  = var.boot_volume_backup_policy
  block_storage_sizes_in_gbs = var.block_storage_sizes_in_gbs
  preserve_boot_volume       = false
}

output "vcn_summary" {
  description = "vcn and gateways information"
  value = {
    internet_gateway_id          = module.vcn.internet_gateway_id
    internet_gateway_route_id    = module.vcn.ig_route_id
    nat_gateway_id               = module.vcn.nat_gateway_id
    nat_gateway_route_id         = module.vcn.nat_route_id
    service_gateway_id           = module.vcn.service_gateway_id
    vcn_dns_label                = module.vcn.vcn_all_attributes.dns_label
    vcn_default_security_list_id = module.vcn.vcn_all_attributes.default_security_list_id
    vcn_default_route_table_id   = module.vcn.vcn_all_attributes.default_route_table_id
    vcn_default_dhcp_options_id  = module.vcn.vcn_all_attributes.default_dhcp_options_id
    vcn_id                       = module.vcn.vcn_id
  }
}

output "subnets_summary" {
  description = "subnets info"
  value       = module.vcn.subnet_id
}

output "worker_nodes_summary" {
  description = "IP information of the instances provisioned by this module."
  value       = module.worker_nodes.instances_summary
}
