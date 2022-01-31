## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_virtual_network" "ELKVCN" {
  cidr_block     = var.VCN-CIDR
  compartment_id = var.compartment_ocid
  display_name   = "ELKVCN"
  dns_label      = "elkvcn"
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_subnet" "ELKSubnet" {
  cidr_block          = var.ELKSubnet-CIDR
  display_name        = "ELKSubnet"
  dns_label           = "elksubnet"
  security_list_ids   = [oci_core_security_list.ELKSecurityList.id]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.ELKVCN.id
  route_table_id      = oci_core_route_table.ELKRT.id
  dhcp_options_id     = oci_core_virtual_network.ELKVCN.default_dhcp_options_id
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_internet_gateway" "ELKIG" {
  compartment_id = var.compartment_ocid
  display_name   = "ELKIG"
  vcn_id         = oci_core_virtual_network.ELKVCN.id
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
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
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
