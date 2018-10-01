resource "oci_core_instance" "BastionHost" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "BastionHost"
  shape               = "${var.BastionShape}"

  create_vnic_details {
        subnet_id = "${oci_core_subnet.BastionSubnetAD1.id}"
        skip_source_dest_check = true
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file(var.BastionBootStrap))}"
  }

  source_details {
    source_id = "${var.InstanceImageOCID[var.region]}"
    source_type = "image"
    }

  timeouts {
   create = "${var.create_timeout}"
   }
}

resource "oci_core_instance" "ESMasterNode1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "ESMasterNode1"
  shape               = "${var.MasterNodeShape}"
  depends_on          = ["oci_core_instance.BastionHost"]
  
 create_vnic_details {
       subnet_id = "${oci_core_subnet.PrivSubnetAD1.id}"
       assign_public_ip = false
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file(var.ESBootStrap))}"
  }

  source_details {
    source_id = "${var.InstanceImageOCID[var.region]}"
    source_type = "image"
    boot_volume_size_in_gbs = "${var.BootVolSize}"
    }
  
  timeouts {
   create = "${var.create_timeout}"
   }
}

resource "oci_core_instance" "ESMasterNode2" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "ESMasterNode2"
  shape               = "${var.MasterNodeShape}"
  depends_on          = ["oci_core_instance.BastionHost"]

 create_vnic_details {
       subnet_id = "${oci_core_subnet.PrivSubnetAD2.id}"
       assign_public_ip = false
  }
 
 metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file(var.ESBootStrap))}"
  }

  source_details {
    source_id = "${var.InstanceImageOCID[var.region]}"
    source_type = "image"
    boot_volume_size_in_gbs = "${var.BootVolSize}"
    }

  timeouts {
   create = "${var.create_timeout}"
   }
}

resource "oci_core_instance" "ESMasterNode3" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[2],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "ESMasterNode3"
  shape               = "${var.MasterNodeShape}"
  depends_on          = ["oci_core_instance.BastionHost"]

 create_vnic_details {
       subnet_id = "${oci_core_subnet.PrivSubnetAD3.id}"
       assign_public_ip = false
  }
  
 metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file(var.ESBootStrap))}"
  }

  source_details {
    source_id = "${var.InstanceImageOCID[var.region]}"
    source_type = "image"
    boot_volume_size_in_gbs = "${var.BootVolSize}"
    }

  timeouts {
   create = "${var.create_timeout}"
   }
}

resource "oci_core_instance" "ESDataNode1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "ESDataNode1"
  shape               = "${var.DataNodeShape}"
  depends_on          = ["oci_core_instance.BastionHost"]
 
  create_vnic_details {
       subnet_id = "${oci_core_subnet.PrivSubnetAD1.id}"
       assign_public_ip = false
  }
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file(var.ESBootStrap))}"
  }

  source_details {
    source_id = "${var.InstanceImageOCID[var.region]}"
    source_type = "image"
    boot_volume_size_in_gbs = "${var.BootVolSize}"
    }

  timeouts {
   create = "${var.create_timeout}"
   }
}

resource "oci_core_instance" "ESDataNode2" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "ESDataNode2"
  shape               = "${var.DataNodeShape}"
  depends_on          = ["oci_core_instance.BastionHost"]

 create_vnic_details {
       subnet_id = "${oci_core_subnet.PrivSubnetAD1.id}"
       assign_public_ip = false
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file(var.ESBootStrap))}"
  }

  source_details {
    source_id = "${var.InstanceImageOCID[var.region]}"
    source_type = "image"
    boot_volume_size_in_gbs = "${var.BootVolSize}"
    }

  timeouts {
   create = "${var.create_timeout}"
   }
}

resource "oci_core_instance" "ESDataNode3" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "ESDataNode3"
  shape               = "${var.DataNodeShape}"
  depends_on          = ["oci_core_instance.BastionHost"]

 create_vnic_details {
       subnet_id = "${oci_core_subnet.PrivSubnetAD2.id}"
       assign_public_ip = false
  }
  
 metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file(var.ESBootStrap))}"
  }

  source_details {
    source_id = "${var.InstanceImageOCID[var.region]}"
    source_type = "image"
    boot_volume_size_in_gbs = "${var.BootVolSize}"
    }

  timeouts {
   create = "${var.create_timeout}"
   }
}

resource "oci_core_instance" "ESDataNode4" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "ESDataNode4"
  shape               = "${var.DataNodeShape}"
  depends_on          = ["oci_core_instance.BastionHost"]

 create_vnic_details {
       subnet_id = "${oci_core_subnet.PrivSubnetAD2.id}"
       assign_public_ip = false
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file(var.ESBootStrap))}"
  }

  source_details {
    source_id = "${var.InstanceImageOCID[var.region]}"
    source_type = "image"
    boot_volume_size_in_gbs = "${var.BootVolSize}"
    }

  timeouts {
   create = "${var.create_timeout}"
   }
}
