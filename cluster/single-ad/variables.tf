variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}

variable "BastionShape" {
  default = "VM.Standard2.1"
}

variable "MasterNodeShape" {
  default = "VM.Standard2.2"
}

variable "DataNodeShape" {
  default = "VM.Standard2.4"
}

variable "BootVolSize" {
  default = "100"
}

variable "lb_shape" {
  default = "100Mbps"
}

variable "OsImage" {
  default = "Oracle-Linux-7.8-2020.09.23-0"
}

variable "VCN-CIDR" {
  default = "192.168.0.0/25"
}

variable "BastSubnetAD1CIDR" {
  default = "192.168.0.0/28"
}

variable "PrivSubnetAD1CIDR" {
  default = "192.168.0.16/28"
}

variable "LBSubnetAD1CIDR" {
  default = "192.168.0.64/28"
}

variable "ESBootStrap" {
  default = "./scripts/ESBootStrap.sh"
}

variable "BastionBootStrap" {
  default = "./scripts/BastionBootStrap.sh"
}

variable "elasticsearch_download_url" {
  default = "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.7.1.rpm"
#  default = "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.0-x86_64.rpm"
}

variable "kibana_download_url" {
#  default = "https://artifacts.elastic.co/downloads/kibana/kibana-7.10.0-x86_64.rpm"
  default = "https://artifacts.elastic.co/downloads/kibana/kibana-6.7.1-x86_64.rpm"
}

variable "backend_set_health_checker_interval_ms" {
  default = "15000"
}

variable "KibanaPort" {
  default = "5601"
}

variable "ESDataPort" {
  default = "9200"
}

variable "ESDataPort2" {
  default = "9300"
}

variable "create_timeout" {
  default = "60000m"
}

variable "DataVolSize" {
  default = "200"
}

variable "volume_attachment_attachment_type" {
  default = "iscsi"
}

