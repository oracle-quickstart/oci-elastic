# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

# Gets a list of vNIC attachments on the bastion host
data "oci_core_vnic_attachments" "BastionVnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  instance_id         = oci_core_instance.BastionHost.id
}

# Gets the OCID of the first vNIC on the bastion host
data "oci_core_vnic" "BastionVnic" {
  vnic_id = data.oci_core_vnic_attachments.BastionVnics.vnic_attachments[0]["vnic_id"]
}

# Get the Private of bastion host
data "oci_core_private_ips" "BastionPrivateIPs" {
  ip_address = data.oci_core_vnic.BastionVnic.private_ip_address
  subnet_id  = oci_core_subnet.BastionSubnetAD1.id
}


# Gets a list of vNIC attachments on the ESMasterNode1 
data "oci_core_vnic_attachments" "ESMasterNode1Vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  instance_id         = oci_core_instance.ESMasterNode1.id
}

# Gets the OCID of the first vNIC on the ESMasterNode1
data "oci_core_vnic" "ESMasterNode1Vnic" {
  vnic_id = data.oci_core_vnic_attachments.ESMasterNode1Vnics.vnic_attachments.0.vnic_id
}


# Gets a list of vNIC attachments on the ESMasterNode2 
data "oci_core_vnic_attachments" "ESMasterNode2Vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[1]["name"]
  instance_id         = oci_core_instance.ESMasterNode2.id
}

# Gets the OCID of the first vNIC on the ESMasterNode2
data "oci_core_vnic" "ESMasterNode2Vnic" {
  vnic_id = data.oci_core_vnic_attachments.ESMasterNode2Vnics.vnic_attachments.0.vnic_id
}

# Gets a list of vNIC attachments on the ESMasterNode3 
data "oci_core_vnic_attachments" "ESMasterNode3Vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[2]["name"]
  instance_id         = oci_core_instance.ESMasterNode3.id
}

# Gets the OCID of the first vNIC on the ESMasterNode3
data "oci_core_vnic" "ESMasterNode3Vnic" {
  vnic_id = data.oci_core_vnic_attachments.ESMasterNode3Vnics.vnic_attachments.0.vnic_id
}

# Gets a list of vNIC attachments on the ESDataNode1 
data "oci_core_vnic_attachments" "ESDataNode1Vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  instance_id         = oci_core_instance.ESDataNode1.id
}

# Gets the OCID of the first vNIC on the ESMasterNode1
data "oci_core_vnic" "ESDataNode1Vnic" {
  vnic_id = data.oci_core_vnic_attachments.ESDataNode1Vnics.vnic_attachments.0.vnic_id
}


# Gets a list of vNIC attachments on the ESDataNode2 
data "oci_core_vnic_attachments" "ESDataNode2Vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  instance_id         = oci_core_instance.ESDataNode2.id
}

# Gets the OCID of the first vNIC on the ESMasterNode2
data "oci_core_vnic" "ESDataNode2Vnic" {
  vnic_id = data.oci_core_vnic_attachments.ESDataNode2Vnics.vnic_attachments.0.vnic_id
}


# Gets a list of vNIC attachments on the ESDataNode3 
data "oci_core_vnic_attachments" "ESDataNode3Vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[1]["name"]
  instance_id         = oci_core_instance.ESDataNode3.id
}

# Gets the OCID of the first vNIC on the ESMasterNode3
data "oci_core_vnic" "ESDataNode3Vnic" {
  vnic_id = data.oci_core_vnic_attachments.ESDataNode3Vnics.vnic_attachments.0.vnic_id
}

# Gets a list of vNIC attachments on the ESDataNode4 
data "oci_core_vnic_attachments" "ESDataNode4Vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[1]["name"]
  instance_id         = oci_core_instance.ESDataNode4.id
}

# Gets the OCID of the first vNIC on the ESMasterNode4
data "oci_core_vnic" "ESDataNode4Vnic" {
  vnic_id = data.oci_core_vnic_attachments.ESDataNode4Vnics.vnic_attachments.0.vnic_id
}

data "oci_core_images" "InstanceImageOCID" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

