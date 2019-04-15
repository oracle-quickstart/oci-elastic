variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "compartment_ocid" {}
variable "ssh_public_key" {}

# Defines the number of instances to deploy
variable "NumInstances" {
  default = "1"
}

# Choose an Availability Domain
variable "availability_domain" {
  default = "1"
}

variable "instance_shape" {
  default = "VM.Standard2.4"
}

// https://docs.cloud.oracle.com/iaas/images/image/cf34ce27-e82d-4c1a-93e6-e55103f90164/
// Oracle-Linux-7.6-2019.03.22-1
variable "images" {
  type = "map"

  default = {
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa2n5z4nmkqjf27btkbdibflwvximz5i3rsz57c3gowckozrdshnua"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaavxqdkuyamlnrdo3q7qa7q3tsd6vnyrxjy3nmdbpv7fs7um53zh5q"
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaapxvrtwbpgy3lchk2usn462ekarljwg4zou2acmundxlkzdty4bjq"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaaaxnnrqke453ur5katouvfn2i6oweuwpixx6mm5e4nqtci7oztx5a"
    ca-toronto-1   = "ocid1.image.oc1.ca-toronto-1.aaaaaaaaqopv4wgbh54jrqoa4bjpkng2y2npzoe2jaj5pdne37ljdxbbbdka"
  }
}
