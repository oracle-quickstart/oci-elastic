# OCI Elasticsearch Quick Start

Quick Start a Highly Available Elasticsearch Cluster on OCI. 

## Prerequisites
First off you'll need to do some pre deploy setup.  That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

Architecture Brief
==================
This deploys an Elasticsearch cluster with 3 master nodes in all 3 ADs and 4 data nodes in 2 ADs. Necessary Elasticsearch [configuration](https://www.elastic.co/guide/en/elasticsearch/reference/current/allocation-awareness.html) is in place to make sure primary and replica of the same same index sharda are never stored in the same AD.

OCI LBaaS is used for load balancing index operations onto the data nodes and Kibana access to master nodes, by using 2 different listeners one for Kibana and other for index data access. 
Currently 200GB additional volume is added to data nodes for index, this can be modified by editing variabes.tf.

LBaaS is launched into public subnet with public IP, this can be modified by modifying the lbaas.tf to make it private LBaaS.

How to Launch the Cluster.
=========================
1. Download files to your local machine with Terraform installed 
2. Edit env-vars file and fill your OCI credentials
3. Exceute . ./env-vars to set OCI crendials in your environment 
4. Edit variables.tf and change any parameter values like VM/BM, LBaaS shape and data volume size
5. Run below terraform commands to deploy the cluster.
   
   terraform apply
    
Once the launchs is finished use bastion public IP to access the Elasticsearch cluster nodes and use LBaaS IP address to accees 
Elasticsearch and Kibana as shown below.

http://<LBaaS IP>:9200/_cat     <==== Elasticsearch URL from browser or use curl intead.
http://<LBaaS IP>:5601        <==== Kibana URL from browser 
