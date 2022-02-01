## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


resource "oci_core_virtual_network" "OCI_ES_VCN" {
  cidr_block     = var.VCN-CIDR
  compartment_id = var.compartment_ocid
  display_name   = "OCI_ES_VCN"
  dns_label      = "OCIESVCN"
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_nat_gateway" "natgtw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.OCI_ES_VCN.id
  display_name   = "OCI_ES_NAT"
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_internet_gateway" "OCI_ES_IGW" {
  compartment_id = var.compartment_ocid
  display_name   = "OCI_ES_IGW"
  vcn_id         = oci_core_virtual_network.OCI_ES_VCN.id
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_route_table" "OCI_PUB_RTB" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.OCI_ES_VCN.id
  display_name   = "OCI_PUB_RTB"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.OCI_ES_IGW.id
  }
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_route_table" "OCI_ES_RTB" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.OCI_ES_VCN.id
  display_name   = "OCI_ES_RTB"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.natgtw.id
  }
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_security_list" "LBSecList" {
  compartment_id = var.compartment_ocid
  display_name   = "LBSecList"
  vcn_id         = oci_core_virtual_network.OCI_ES_VCN.id

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    tcp_options {
      max = var.ESDataPort
      min = var.ESDataPort
    }

    protocol = "6"
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    tcp_options {
      max = var.KibanaPort
      min = var.KibanaPort
    }

    protocol = "6"
    source   = "0.0.0.0/0"
  }
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_security_list" "PrivSecList" {
  compartment_id = var.compartment_ocid
  display_name   = "PrivSecList"
  vcn_id         = oci_core_virtual_network.OCI_ES_VCN.id

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    tcp_options {
      max = var.ESDataPort
      min = var.ESDataPort
    }

    protocol = "6"
    source   = var.VCN-CIDR
  }
  ingress_security_rules {
    tcp_options {
      max = var.ESDataPort2
      min = var.ESDataPort2
    }

    protocol = "6"
    source   = var.VCN-CIDR
  }
  ingress_security_rules {
    tcp_options {
      max = 5601
      min = 5601
    }

    protocol = "6"
    source   = var.VCN-CIDR
  }
  ingress_security_rules {
    tcp_options {
      max = 22
      min = 22
    }

    protocol = "6"
    source   = var.VCN-CIDR
  }
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_security_list" "BastionSecList" {
  compartment_id = var.compartment_ocid
  display_name   = "BastionSecList"
  vcn_id         = oci_core_virtual_network.OCI_ES_VCN.id

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    tcp_options {
      max = 22
      min = 22
    }

    protocol = "6"
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol = "all"
    source   = var.VCN-CIDR
  }
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_subnet" "LBSubnet" {
  cidr_block          = var.LBSubnetCIDR
  display_name        = "LB-Subnet"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.OCI_ES_VCN.id
  route_table_id      = oci_core_route_table.OCI_PUB_RTB.id
  security_list_ids   = [oci_core_security_list.LBSecList.id]
  dhcp_options_id     = oci_core_virtual_network.OCI_ES_VCN.default_dhcp_options_id
  dns_label           = "lbnet"
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}


resource "oci_core_subnet" "PrivSubnet" {
  cidr_block                 = var.PrivSubnetCIDR
  display_name               = "Private-Subnet"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.OCI_ES_VCN.id
  route_table_id             = oci_core_route_table.OCI_ES_RTB.id
  security_list_ids          = [oci_core_security_list.PrivSecList.id]
  dhcp_options_id            = oci_core_virtual_network.OCI_ES_VCN.default_dhcp_options_id
  prohibit_public_ip_on_vnic = "true"
  dns_label                  = "privatenet"
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}


resource "oci_core_subnet" "BastionSubnet" {
  cidr_block          = var.BastSubnetCIDR
  display_name        = "BastionSubnet"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.OCI_ES_VCN.id
  route_table_id      = oci_core_route_table.OCI_PUB_RTB.id
  security_list_ids   = [oci_core_security_list.BastionSecList.id]
  dhcp_options_id     = oci_core_virtual_network.OCI_ES_VCN.default_dhcp_options_id
  dns_label           = "bastnet"
}

