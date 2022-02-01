## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Get list of availability domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

data "oci_identity_fault_domains" "FDs" {
    #Required
    availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
    compartment_id = var.compartment_ocid
}


# Gets a list of vNIC attachments on the bastion host
data "oci_core_vnic_attachments" "BastionVnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  instance_id         = oci_core_instance.BastionHost.id
}

# Gets the OCID of the first vNIC on the bastion host
data "oci_core_vnic" "BastionVnic" {
  vnic_id = data.oci_core_vnic_attachments.BastionVnics.vnic_attachments[0]["vnic_id"]
}

# Get the Private of bastion host
data "oci_core_private_ips" "BastionPrivateIPs" {
  ip_address = data.oci_core_vnic.BastionVnic.private_ip_address
  subnet_id  = oci_core_subnet.BastionSubnet.id
}


# Gets a list of vNIC attachments on the ESMasterNode1 
data "oci_core_vnic_attachments" "ESMasterNode1Vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  instance_id         = oci_core_instance.ESMasterNode1.id
}

# Gets the OCID of the first vNIC on the ESMasterNode1
data "oci_core_vnic" "ESMasterNode1Vnic" {
  vnic_id = data.oci_core_vnic_attachments.ESMasterNode1Vnics.vnic_attachments.0.vnic_id
}


# Gets a list of vNIC attachments on the ESMasterNode2 
data "oci_core_vnic_attachments" "ESMasterNode2Vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  instance_id         = oci_core_instance.ESMasterNode2.id
}

# Gets the OCID of the first vNIC on the ESMasterNode2
data "oci_core_vnic" "ESMasterNode2Vnic" {
  vnic_id = data.oci_core_vnic_attachments.ESMasterNode2Vnics.vnic_attachments.0.vnic_id
}

# Gets a list of vNIC attachments on the ESMasterNode3 
data "oci_core_vnic_attachments" "ESMasterNode3Vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  instance_id         = oci_core_instance.ESMasterNode3.id
}

# Gets the OCID of the first vNIC on the ESMasterNode3
data "oci_core_vnic" "ESMasterNode3Vnic" {
  vnic_id = data.oci_core_vnic_attachments.ESMasterNode3Vnics.vnic_attachments.0.vnic_id
}

# Gets a list of vNIC attachments on the ESDataNode1 
data "oci_core_vnic_attachments" "ESDataNode1Vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  instance_id         = oci_core_instance.ESDataNode1.id
}

# Gets the OCID of the first vNIC on the ESMasterNode1
data "oci_core_vnic" "ESDataNode1Vnic" {
  vnic_id = data.oci_core_vnic_attachments.ESDataNode1Vnics.vnic_attachments.0.vnic_id
}


# Gets a list of vNIC attachments on the ESDataNode2 
data "oci_core_vnic_attachments" "ESDataNode2Vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  instance_id         = oci_core_instance.ESDataNode2.id
}

# Gets the OCID of the first vNIC on the ESMasterNode2
data "oci_core_vnic" "ESDataNode2Vnic" {
  vnic_id = data.oci_core_vnic_attachments.ESDataNode2Vnics.vnic_attachments.0.vnic_id
}


# Gets a list of vNIC attachments on the ESDataNode3 
data "oci_core_vnic_attachments" "ESDataNode3Vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  instance_id         = oci_core_instance.ESDataNode3.id
}

# Gets the OCID of the first vNIC on the ESMasterNode3
data "oci_core_vnic" "ESDataNode3Vnic" {
  vnic_id = data.oci_core_vnic_attachments.ESDataNode3Vnics.vnic_attachments.0.vnic_id
}

data "oci_core_images" "InstanceImageOCID_Bastion" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.BastionShape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

data "oci_core_images" "InstanceImageOCID_MasterNode" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.MasterNodeShape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

data "oci_core_images" "InstanceImageOCID_DataNode" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.DataNodeShape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}


data "oci_identity_region_subscriptions" "home_region_subscriptions" {
    tenancy_id = var.tenancy_ocid

    filter {
      name   = "is_home_region"
      values = [true]
    }
}

# This Terraform script provisions a compute instance

data "template_file" "key_script" {
  template = file("./scripts/sshkey.tpl")
  vars = {
    ssh_public_key = tls_private_key.public_private_key_pair.public_key_openssh
  }
}

data "template_cloudinit_config" "cloud_init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "ainit.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.key_script.rendered
  }
}


data "template_file" "key_script_bastion" {
  template = file("./scripts/BastionBootStrap.sh")
  vars = {
    ssh_public_key = tls_private_key.public_private_key_pair.public_key_openssh
  }
}

data "template_cloudinit_config" "cloud_init_bastion" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "ainit.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.key_script_bastion.rendered
  }
}
