## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Output the private and public IPs of the instance

output "BastionPublicIP" {
  value = oci_core_instance.BastionHost.public_ip
}

output "Kibana_URL_via_LBaaS" {
  value = "http://${oci_load_balancer_load_balancer.ES-LB.ip_addresses[0]}:${var.KibanaPort}/"
}

output "Elasticsearch_URL_via_LBaaS" {
  value = "http://${oci_load_balancer_load_balancer.ES-LB.ip_addresses[0]}:${var.ESDataPort}/"
}

output "generated_ssh_private_key" {
  value = tls_private_key.public_private_key_pair.private_key_pem
  sensitive = true
}

