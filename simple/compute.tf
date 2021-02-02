data "template_file" "ELK" {
  template = "${file("./scripts/elk.sh")}"

  vars = {
    elasticsearch_download_url  = var.elasticsearch_download_url
    kibana_download_url         = var.kibana_download_url
    logstash_download_url       = var.logstash_download_url
    KibanaPort                  = var.KibanaPort
    ESDataPort                  = var.ESDataPort
  }

}

resource "oci_core_instance" "ELK" {
  availability_domain = var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "ELK"
  shape               = var.instance_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.ELKSubnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "elk"
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.InstanceImageOCID.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
    user_data           = base64encode(data.template_file.ELK.rendered)
  }
}
