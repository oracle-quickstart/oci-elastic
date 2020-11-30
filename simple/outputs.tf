output "ELK_VM_public_IP" {
  value = "${data.oci_core_vnic.elk_vnic.public_ip_address}"
}

output "generated_ssh_private_key" {
  value = tls_private_key.public_private_key_pair.private_key_pem
}


