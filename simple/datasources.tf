# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_vnic_attachments" "elk_vnics" {
  compartment_id      = var.compartment_ocid
#  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
  availability_domain = var.availablity_domain_name 
  instance_id         = oci_core_instance.ELK.id
}

data "oci_core_vnic" "elk_vnic" {
  vnic_id = lookup(data.oci_core_vnic_attachments.elk_vnics.vnic_attachments[0], "vnic_id")
}

# Gets the Id of a specific OS Images
data "oci_core_images" "InstanceImageOCID" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = var.OsImage
}