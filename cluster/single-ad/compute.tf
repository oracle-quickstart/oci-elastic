data "template_file" "setup_esbootstrap" {
  template = file("${var.ESBootStrap}")

  vars = {
    elasticsearch_download_url  = var.elasticsearch_download_url
    kibana_download_url         = var.kibana_download_url
    ESDataPort                  = var.ESDataPort
    ESDataPort2                 = var.ESDataPort2
    KibanaPort                  = var.KibanaPort
  }
}

resource "oci_core_instance" "BastionHost" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  fault_domain = data.oci_identity_fault_domains.FDs.fault_domains[0]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "BastionHost"
  shape               = var.BastionShape

  create_vnic_details {
    subnet_id              = oci_core_subnet.BastionSubnetAD1.id
    skip_source_dest_check = true
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
    user_data           = base64encode(file(var.BastionBootStrap))
  }

  source_details {
    #source_id   = var.InstanceImageOCID[var.region]
    source_id   = data.oci_core_images.InstanceImageOCID.images[0].id
    source_type = "image"
  }

  timeouts {
    create = var.create_timeout
  }
}

resource "oci_core_instance" "ESMasterNode1" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  fault_domain = data.oci_identity_fault_domains.FDs.fault_domains[0]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESMasterNode1"
  shape               = var.MasterNodeShape
  #depends_on          = [oci_core_instance.BastionHost]

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnetAD1.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
    user_data           = base64encode(file(var.ESBootStrap))
  }

  source_details {
    source_id   = data.oci_core_images.InstanceImageOCID.images[0].id
    #source_id               = var.InstanceImageOCID[var.region]
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  timeouts {
    create = var.create_timeout
  }
}

resource "oci_core_instance" "ESMasterNode2" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  fault_domain = data.oci_identity_fault_domains.FDs.fault_domains[1]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESMasterNode2"
  shape               = var.MasterNodeShape
  #depends_on          = [oci_core_instance.BastionHost]

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnetAD1.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
    user_data           = base64encode(file(var.ESBootStrap))
  }

  source_details {
    source_id   = data.oci_core_images.InstanceImageOCID.images[0].id
    #source_id               = var.InstanceImageOCID[var.region]
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  timeouts {
    create = var.create_timeout
  }
}

resource "oci_core_instance" "ESMasterNode3" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  fault_domain = data.oci_identity_fault_domains.FDs.fault_domains[2]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESMasterNode3"
  shape               = var.MasterNodeShape
  #depends_on          = [oci_core_instance.BastionHost]

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnetAD1.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
    user_data           = base64encode(file(var.ESBootStrap))
  }

  source_details {
    source_id   = data.oci_core_images.InstanceImageOCID.images[0].id
    #source_id               = var.InstanceImageOCID[var.region]
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  timeouts {
    create = var.create_timeout
  }
}

resource "oci_core_instance" "ESDataNode1" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  fault_domain = data.oci_identity_fault_domains.FDs.fault_domains[0]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESDataNode1"
  shape               = var.DataNodeShape
  #depends_on          = [oci_core_instance.BastionHost]

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnetAD1.id
    assign_public_ip = false
  }
  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
    user_data           = base64encode(file(var.ESBootStrap))
  }

  source_details {
    source_id   = data.oci_core_images.InstanceImageOCID.images[0].id
    #source_id               = var.InstanceImageOCID[var.region]
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  timeouts {
    create = var.create_timeout
  }
}

resource "oci_core_instance" "ESDataNode2" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  fault_domain = data.oci_identity_fault_domains.FDs.fault_domains[1]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESDataNode2"
  shape               = var.DataNodeShape
  depends_on          = [oci_core_instance.BastionHost]

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnetAD1.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
    user_data           = base64encode(file(var.ESBootStrap))
  }

  source_details {
    source_id   = data.oci_core_images.InstanceImageOCID.images[0].id
    #source_id               = var.InstanceImageOCID[var.region]
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  timeouts {
    create = var.create_timeout
  }
}

resource "oci_core_instance" "ESDataNode3" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  fault_domain = data.oci_identity_fault_domains.FDs.fault_domains[2]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESDataNode3"
  shape               = var.DataNodeShape
  depends_on          = [oci_core_instance.BastionHost]

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnetAD1.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
    user_data           = base64encode(file(var.ESBootStrap))
  }

  source_details {
    source_id   = data.oci_core_images.InstanceImageOCID.images[0].id
    #source_id               = var.InstanceImageOCID[var.region]
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  timeouts {
    create = var.create_timeout
  }
}

