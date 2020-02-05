# oci-elastic

These are Terraform modules that deploy [Elastic](https://www.elastic.co/products/) on [Oracle Cloud Infrastructure (OCI)](https://cloud.oracle.com/en_US/cloud-infrastructure).  They are developed jointly by Oracle and Elastic.

* [simple](simple) deploys Elasticsearch, Kibana, and Logstash on a VM
* [multi-ad](cluster/multi-ad) deploys a highly available cluster across avaiability domains with Elasticsearch and Kibana
* [single-ad](cluster/single-ad) deploys a highly available cluster across fault domains with Elasticsearch and Kibana


Please follow the instructions in [simple](simple) or [cluster](cluster) folders to deploy.
