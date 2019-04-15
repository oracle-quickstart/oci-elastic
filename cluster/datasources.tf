# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

# Gets a list of vNIC attachments on the bastion host
data "oci_core_vnic_attachments" "BastionVnics" {
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  instance_id         = "${oci_core_instance.BastionHost.id}"
}

# Gets the OCID of the first vNIC on the bastion host
data "oci_core_vnic" "BastionVnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.BastionVnics.vnic_attachments[0],"vnic_id")}"
}

# Get the Private of bastion host
data "oci_core_private_ips" "BastionPrivateIPs" {
    ip_address = "${data.oci_core_vnic.BastionVnic.private_ip_address}"
    subnet_id = "${oci_core_subnet.BastionSubnetAD1.id}"
}
