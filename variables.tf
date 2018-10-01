variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}

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

variable "InstanceImageOCID" {
  type = "map"

  default = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    // Oracle-provided image "Oracle-Linux-7.4-2018.02.21-1"
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaasez4lk2lucxcm52nslj5nhkvbvjtfies4yopwoy4b3vysg5iwjra"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaa2tq67tvbeavcmioghquci6p3pvqwbneq3vfy7fe7m7geiga4cnxa"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaakzrywmh7kwt7ugj5xqi5r4a7xoxsrxtc7nlsdyhmhqyp7ntobjwq"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaalsdgd47nl5tgb55sihdpqmqu2sbvvccjs6tmbkr4nx2pq5gkn63a"
  }
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

variable "PrivSubnetAD2CIDR" {
  default = "192.168.0.32/28"
}

variable "PrivSubnetAD3CIDR" {
  default = "192.168.0.48/28"
}

variable "LBSubnetAD1CIDR" {
  default = "192.168.0.64/28"
}

variable "LBSubnetAD2CIDR" {
  default = "192.168.0.80/28"
}

variable "ESBootStrap" {
  default = "./userdata/ESBootStrap.sh"
}

variable "BastionBootStrap" {
  default = "./userdata/BastionBootStrap.sh"
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

variable "create_timeout" {
  default ="60000m"
}

variable "DataVolSize" {
  default = "200"
}

variable "volume_attachment_attachment_type" {
  default = "iscsi"
}
