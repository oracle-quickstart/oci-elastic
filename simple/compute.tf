## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "template_file" "ELK" {
  template = file("./scripts/elk.sh")

  vars = {
    elasticsearch_download_url      = var.elasticsearch_download_url
    kibana_download_url             = var.kibana_download_url
    logstash_download_url           = var.logstash_download_url
    elasticsearch_download_version  = var.elasticsearch_download_version
    kibana_download_version         = var.kibana_download_version
    logstash_download_version       = var.logstash_download_version
    KibanaPort                      = var.KibanaPort
    ESDataPort                      = var.ESDataPort
    ssh_public_key                  = tls_private_key.public_private_key_pair.public_key_openssh
  }

}

resource "oci_core_instance" "ELK" {
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "ELK"
  shape               = var.instance_shape
  
  dynamic "shape_config" {
    for_each = local.is_flexible_shape ? [1] : []
    content {
      memory_in_gbs = var.instance_flex_shape_memory
      ocpus = var.instance_flex_shape_ocpus
    }
  }

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

  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
