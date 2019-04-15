output "ELK VM public IP" {
  value = "${data.oci_core_vnic.elk_vnic.public_ip_address}"
}
