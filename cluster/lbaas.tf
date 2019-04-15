resource "oci_load_balancer_load_balancer" "ES-LB" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "ES-LB"
    shape = "${var.lb_shape}"
    subnet_ids = ["${oci_core_subnet.LBSubnetAD1.id}", "${oci_core_subnet.LBSubnetAD2.id}"]
    is_private = "false"
    depends_on = ["oci_core_instance.ESDataNode1","oci_core_instance.ESDataNode2","oci_core_instance.ESDataNode3","oci_core_instance.ESDataNode4","oci_core_instance.ESMasterNode1","oci_core_instance.ESMasterNode2","oci_core_instance.ESMasterNode3"]
}

resource "oci_load_balancer_backend_set" "ESKibana" {
    health_checker {
        protocol = "TCP"
        interval_ms = "${var.backend_set_health_checker_interval_ms}"
        port = "22"
    }

    load_balancer_id = "${oci_load_balancer_load_balancer.ES-LB.id}"
    name = "ESKibana"
    policy = "ROUND_ROBIN"

    session_persistence_configuration {
        cookie_name = "*"
        }
}

resource "oci_load_balancer_backend_set" "ES-Data" {
    health_checker {
        protocol = "TCP"
        interval_ms = "${var.backend_set_health_checker_interval_ms}"
        port = "22"
    }

    load_balancer_id = "${oci_load_balancer_load_balancer.ES-LB.id}"
    name = "ES-Data"
    policy = "ROUND_ROBIN"

     session_persistence_configuration {
        cookie_name = "*"
        }
}

resource "oci_load_balancer_backend" "DataNode1" {
    backendset_name = "ES-Data"
    ip_address = "${oci_core_instance.ESDataNode1.private_ip}"
    load_balancer_id = "${oci_load_balancer_load_balancer.ES-LB.id}"
    port = "${var.ESDataPort}"
    depends_on = ["oci_load_balancer_backend_set.ES-Data"]
    }

resource "oci_load_balancer_backend" "DataNode2" {
    backendset_name = "ES-Data"
    ip_address = "${oci_core_instance.ESDataNode2.private_ip}"
    load_balancer_id = "${oci_load_balancer_load_balancer.ES-LB.id}"
    port = "${var.ESDataPort}"
    depends_on = ["oci_load_balancer_backend_set.ES-Data"]
    }

resource "oci_load_balancer_backend" "DataNode3" {
    backendset_name = "ES-Data"
    ip_address = "${oci_core_instance.ESDataNode3.private_ip}"
    load_balancer_id = "${oci_load_balancer_load_balancer.ES-LB.id}"
    port = "${var.ESDataPort}"
    depends_on = ["oci_load_balancer_backend_set.ES-Data"]
    }

resource "oci_load_balancer_backend" "DataNode4" {
    backendset_name = "ES-Data"
    ip_address = "${oci_core_instance.ESDataNode4.private_ip}"
    load_balancer_id = "${oci_load_balancer_load_balancer.ES-LB.id}"
    port = "${var.ESDataPort}"
    depends_on = ["oci_load_balancer_backend_set.ES-Data"]
    }

resource "oci_load_balancer_backend" "ESMaster1" {
    backendset_name = "ESKibana"
    ip_address = "${oci_core_instance.ESMasterNode1.private_ip}"
    load_balancer_id = "${oci_load_balancer_load_balancer.ES-LB.id}"
    port = "${var.KibanaPort}"
    depends_on = ["oci_load_balancer_backend_set.ESKibana"]
    }

resource "oci_load_balancer_backend" "ESMaster2" {
    backendset_name = "ESKibana"
    ip_address = "${oci_core_instance.ESMasterNode2.private_ip}"
    load_balancer_id = "${oci_load_balancer_load_balancer.ES-LB.id}"
    port = "${var.KibanaPort}"
    depends_on = ["oci_load_balancer_backend_set.ESKibana"]
    }

resource "oci_load_balancer_backend" "ESMaster3" {
    backendset_name = "ESKibana"
    ip_address = "${oci_core_instance.ESMasterNode3.private_ip}"
    load_balancer_id = "${oci_load_balancer_load_balancer.ES-LB.id}"
    port = "${var.KibanaPort}"
    depends_on = ["oci_load_balancer_backend_set.ESKibana"]
    }


resource "oci_load_balancer_listener" "KibanaLS" {
    default_backend_set_name = "ESKibana"
    load_balancer_id = "${oci_load_balancer_load_balancer.ES-LB.id}"
    name = "KibanaLS"
    port = "${var.KibanaPort}"
    protocol = "HTTP"
    depends_on = ["oci_load_balancer_backend_set.ESKibana"]
}

resource "oci_load_balancer_listener" "ESDataLS" {
    default_backend_set_name = "ES-Data"
    load_balancer_id = "${oci_load_balancer_load_balancer.ES-LB.id}"
    name = "ESDataLS"
    port = "${var.ESDataPort}"
    protocol = "HTTP"
    depends_on = ["oci_load_balancer_backend_set.ES-Data"]
}
