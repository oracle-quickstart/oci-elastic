resource "oci_core_virtual_network" "ELKVCN" {
  cidr_block     = var.VCN-CIDR
  compartment_id = var.compartment_ocid
  display_name   = "ELKVCN"
  dns_label      = "elkvcn"
}

resource "oci_core_subnet" "ELKSubnet" {
  #availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")
  availability_domain = var.availablity_domain_name
  cidr_block          = var.ELKSubnet-CIDR
  display_name        = "ELKSubnet"
  dns_label           = "elksubnet"
  security_list_ids   = [oci_core_security_list.ELKSecurityList.id]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.ELKVCN.id
  route_table_id      = oci_core_route_table.ELKRT.id
  dhcp_options_id     = oci_core_virtual_network.ELKVCN.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "ELKIG" {
  compartment_id = var.compartment_ocid
  display_name   = "ELKIG"
  vcn_id         = oci_core_virtual_network.ELKVCN.id
}

resource "oci_core_route_table" "ELKRT" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.ELKVCN.id
  display_name   = "ELKRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ELKIG.id
  }
}
