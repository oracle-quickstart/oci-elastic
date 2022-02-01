## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


resource "oci_core_instance" "BastionHost" {
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  fault_domain        = data.oci_identity_fault_domains.FDs.fault_domains[0]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "BastionHost"
  shape               = var.BastionShape

  dynamic "shape_config" {
    for_each = local.is_flexible_bastion_shape ? [1] : []
    content {
      memory_in_gbs = var.Bastion_Flex_Shape_Memory
      ocpus = var.Bastion_Flex_Shape_OCPUS
    }
  }

  create_vnic_details {
    subnet_id              = oci_core_subnet.BastionSubnet.id
    skip_source_dest_check = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = data.template_cloudinit_config.cloud_init_bastion.rendered
  }

  source_details {
    source_id   = lookup(data.oci_core_images.InstanceImageOCID_Bastion.images[0], "id")
    source_type = "image"
  }

  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

  timeouts {
    create = var.create_timeout
  }
}

resource "oci_core_instance" "ESMasterNode1" {
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  fault_domain        = data.oci_identity_fault_domains.FDs.fault_domains[0]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESMasterNode1"
  shape               = var.MasterNodeShape

  dynamic "shape_config" {
    for_each = local.is_flexible_masternode_shape ? [1] : []
    content {
      memory_in_gbs = var.MasterNode_Flex_Shape_Memory
      ocpus = var.MasterNode_Flex_Shape_OCPUS
    }
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnet.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = data.template_cloudinit_config.cloud_init.rendered
  }

  source_details {
    source_id               = lookup(data.oci_core_images.InstanceImageOCID_MasterNode.images[0], "id")
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

  timeouts {
    create = var.create_timeout
  }
}

resource "oci_core_instance" "ESMasterNode2" {
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  fault_domain        = data.oci_identity_fault_domains.FDs.fault_domains[1]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESMasterNode2"
  shape               = var.MasterNodeShape

  dynamic "shape_config" {
    for_each = local.is_flexible_masternode_shape ? [1] : []
    content {
      memory_in_gbs = var.MasterNode_Flex_Shape_Memory
      ocpus = var.MasterNode_Flex_Shape_OCPUS
    }
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnet.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = data.template_cloudinit_config.cloud_init.rendered
  }

  source_details {
    source_id               = lookup(data.oci_core_images.InstanceImageOCID_MasterNode.images[0], "id")
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

  timeouts {
    create = var.create_timeout
  }
}

resource "oci_core_instance" "ESMasterNode3" {
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  fault_domain        = data.oci_identity_fault_domains.FDs.fault_domains[2]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESMasterNode3"
  shape               = var.MasterNodeShape

  dynamic "shape_config" {
    for_each = local.is_flexible_masternode_shape ? [1] : []
    content {
      memory_in_gbs = var.MasterNode_Flex_Shape_Memory
      ocpus = var.MasterNode_Flex_Shape_OCPUS
    }
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnet.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = data.template_cloudinit_config.cloud_init.rendered
  }

  source_details {
    source_id               = lookup(data.oci_core_images.InstanceImageOCID_MasterNode.images[0], "id")
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

  timeouts {
    create = var.create_timeout
  }
}

resource "oci_core_instance" "ESDataNode1" {
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  fault_domain        = data.oci_identity_fault_domains.FDs.fault_domains[0]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESDataNode1"
  shape               = var.DataNodeShape

  dynamic "shape_config" {
    for_each = local.is_flexible_datanode_shape ? [1] : []
    content {
      memory_in_gbs = var.DataNode_Flex_Shape_Memory
      ocpus = var.DataNode_Flex_Shape_OCPUS
    }
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnet.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = data.template_cloudinit_config.cloud_init.rendered
  }

  source_details {
    source_id               = lookup(data.oci_core_images.InstanceImageOCID_DataNode.images[0], "id")
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

  timeouts {
    create = var.create_timeout
  }
}

resource "oci_core_instance" "ESDataNode2" {
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  fault_domain        = data.oci_identity_fault_domains.FDs.fault_domains[1]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESDataNode2"
  shape               = var.DataNodeShape

  dynamic "shape_config" {
    for_each = local.is_flexible_datanode_shape ? [1] : []
    content {
      memory_in_gbs = var.DataNode_Flex_Shape_Memory
      ocpus = var.DataNode_Flex_Shape_OCPUS
    }
  }

  depends_on          = [oci_core_instance.BastionHost]

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnet.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = data.template_cloudinit_config.cloud_init.rendered
  }

  source_details {
    source_id               = lookup(data.oci_core_images.InstanceImageOCID_DataNode.images[0], "id")
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

  timeouts {
    create = var.create_timeout
  }
}

resource "oci_core_instance" "ESDataNode3" {
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  fault_domain        = data.oci_identity_fault_domains.FDs.fault_domains[2]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESDataNode3"
  shape               = var.DataNodeShape

  dynamic "shape_config" {
    for_each = local.is_flexible_datanode_shape ? [1] : []
    content {
      memory_in_gbs = var.DataNode_Flex_Shape_Memory
      ocpus = var.DataNode_Flex_Shape_OCPUS
    }
  }
  
  depends_on          = [oci_core_instance.BastionHost]

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnet.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = data.template_cloudinit_config.cloud_init.rendered
  }

  source_details {
    source_id               = lookup(data.oci_core_images.InstanceImageOCID_DataNode.images[0], "id")
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

  timeouts {
    create = var.create_timeout
  }
}

