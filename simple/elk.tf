data "template_file" "ELK" {
  template = "${file("./scripts/elk.sh")}"
}

resource "oci_core_instance" "ELK" {
  count               = "${var.NumInstances}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "ELK-${count.index}"
  shape               = "${var.instance_shape}"

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.ELKSubnet.id}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "elk-${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.images[var.region]}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(data.template_file.ELK.rendered)}"
  }
}
