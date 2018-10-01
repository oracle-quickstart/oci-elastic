resource "oci_core_volume" "ESData1Vol1" {
    availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
    compartment_id = "${var.compartment_ocid}"
    size_in_gbs = "${var.DataVolSize}"
    display_name = "ESData1Vol1"
 }

resource "oci_core_volume" "ESData2Vol2" {
    availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
    compartment_id = "${var.compartment_ocid}"
    size_in_gbs = "${var.DataVolSize}"
    display_name = "ESData2Vol2"
 }

resource "oci_core_volume" "ESData3Vol3" {
    availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
    compartment_id = "${var.compartment_ocid}"
    size_in_gbs = "${var.DataVolSize}"
    display_name = "ESData3Vol3"
 }

resource "oci_core_volume" "ESData4Vol4" {
    availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
    compartment_id = "${var.compartment_ocid}"
    size_in_gbs = "${var.DataVolSize}"
    display_name = "ESData4Vol4"
 }


resource "oci_core_volume_attachment" "Attach_ESData1Vol1" {
    attachment_type = "${var.volume_attachment_attachment_type}"
    instance_id = "${oci_core_instance.ESDataNode1.id}"
    volume_id = "${oci_core_volume.ESData1Vol1.id}"
}

resource "oci_core_volume_attachment" "Attach_ESData2Vol2" {
    attachment_type = "${var.volume_attachment_attachment_type}"
    instance_id = "${oci_core_instance.ESDataNode2.id}"
    volume_id = "${oci_core_volume.ESData2Vol2.id}"
}

resource "oci_core_volume_attachment" "Attach_ESData3Vol3" {
    attachment_type = "${var.volume_attachment_attachment_type}"
    instance_id = "${oci_core_instance.ESDataNode3.id}"
    volume_id = "${oci_core_volume.ESData3Vol3.id}"
}

resource "oci_core_volume_attachment" "Attach_ESData4Vol4" {
    attachment_type = "${var.volume_attachment_attachment_type}"
    instance_id = "${oci_core_instance.ESDataNode4.id}"
    volume_id = "${oci_core_volume.ESData4Vol4.id}"
}
