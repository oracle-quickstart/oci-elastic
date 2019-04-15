# Output the private and public IPs of the instance

output "BastionPublicIP" {
   value = "${oci_core_instance.BastionHost.public_ip}"
}

output "LBaaSPublicIP" {
  value = "${oci_load_balancer_load_balancer.ES-LB.ip_addresses[0]}"
}
