## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "template_file" "setup_esbootstrap" {
  depends_on = [oci_core_instance.ESMasterNode1, oci_core_instance.ESMasterNode2, oci_core_instance.ESMasterNode3, oci_core_instance.ESDataNode1, oci_core_instance.ESDataNode2, oci_core_instance.ESDataNode3, oci_core_instance.ESDataNode4]
  
  template = file(var.ESBootStrap)

  vars = {
    elasticsearch_download_url      = var.elasticsearch_download_url
    kibana_download_url             = var.kibana_download_url
    elasticsearch_download_version  = var.elasticsearch_download_version
    kibana_download_version         = var.kibana_download_version
    ESDataPort                      = var.ESDataPort
    ESDataPort2                     = var.ESDataPort2
    KibanaPort                      = var.KibanaPort
    esmasternode1_private_ip        = data.oci_core_vnic.ESMasterNode1Vnic.private_ip_address
    esmasternode2_private_ip        = data.oci_core_vnic.ESMasterNode2Vnic.private_ip_address
    esmasternode3_private_ip        = data.oci_core_vnic.ESMasterNode3Vnic.private_ip_address
    esdatanode1_private_ip          = data.oci_core_vnic.ESDataNode1Vnic.private_ip_address 
    esdatanode2_private_ip          = data.oci_core_vnic.ESDataNode2Vnic.private_ip_address
    esdatanode3_private_ip          = data.oci_core_vnic.ESDataNode3Vnic.private_ip_address
    esdatanode4_private_ip          = data.oci_core_vnic.ESDataNode4Vnic.private_ip_address
  }
}

resource "null_resource" "ESMasterNode1_BootStrap" {
  depends_on = [oci_core_instance.BastionHost, oci_core_instance.ESMasterNode1, oci_core_instance.ESMasterNode2, oci_core_instance.ESMasterNode3, oci_core_instance.ESDataNode1, oci_core_instance.ESDataNode2, oci_core_instance.ESDataNode3, oci_core_instance.ESDataNode4]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.ESMasterNode1Vnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.BastionHost.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = data.template_file.setup_esbootstrap.rendered
    destination = "~/esbootstrap.sh"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.ESMasterNode1Vnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.BastionHost.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = [
      "chmod +x ~/esbootstrap.sh",
      "sudo ~/esbootstrap.sh",
    ]
  }
}

resource "null_resource" "ESMasterNode2_BootStrap" {
  depends_on = [oci_core_instance.BastionHost, oci_core_instance.ESMasterNode1, oci_core_instance.ESMasterNode2, oci_core_instance.ESMasterNode3, oci_core_instance.ESDataNode1, oci_core_instance.ESDataNode2, oci_core_instance.ESDataNode3, oci_core_instance.ESDataNode4]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.ESMasterNode2Vnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.BastionHost.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = data.template_file.setup_esbootstrap.rendered
    destination = "~/esbootstrap.sh"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.ESMasterNode2Vnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.BastionHost.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = [
      "chmod +x ~/esbootstrap.sh",
      "sudo ~/esbootstrap.sh",
    ]
  }
}

resource "null_resource" "ESMasterNode3_BootStrap" {
  depends_on = [oci_core_instance.BastionHost, oci_core_instance.ESMasterNode1, oci_core_instance.ESMasterNode2, oci_core_instance.ESMasterNode3, oci_core_instance.ESDataNode1, oci_core_instance.ESDataNode2, oci_core_instance.ESDataNode3, oci_core_instance.ESDataNode4]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.ESMasterNode3Vnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.BastionHost.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = data.template_file.setup_esbootstrap.rendered
    destination = "~/esbootstrap.sh"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.ESMasterNode3Vnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.BastionHost.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = [
      "chmod +x ~/esbootstrap.sh",
      "sudo ~/esbootstrap.sh",
    ]
  }
}

resource "null_resource" "ESDataNode1_BootStrap" {
  depends_on = [oci_core_instance.BastionHost, oci_core_instance.ESMasterNode1, oci_core_instance.ESMasterNode2, oci_core_instance.ESMasterNode3, oci_core_instance.ESDataNode1, oci_core_instance.ESDataNode2, oci_core_instance.ESDataNode3, oci_core_instance.ESDataNode4]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.ESDataNode1Vnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.BastionHost.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = data.template_file.setup_esbootstrap.rendered
    destination = "~/esbootstrap.sh"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.ESDataNode1Vnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.BastionHost.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = [
      "chmod +x ~/esbootstrap.sh",
      "sudo ~/esbootstrap.sh",
    ]
  }
}

resource "null_resource" "ESDataNode2_BootStrap" {
  depends_on = [oci_core_instance.BastionHost, oci_core_instance.ESMasterNode1, oci_core_instance.ESMasterNode2, oci_core_instance.ESMasterNode3, oci_core_instance.ESDataNode1, oci_core_instance.ESDataNode2, oci_core_instance.ESDataNode3, oci_core_instance.ESDataNode4]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.ESDataNode2Vnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.BastionHost.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = data.template_file.setup_esbootstrap.rendered
    destination = "~/esbootstrap.sh"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.ESDataNode2Vnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.BastionHost.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = [
      "chmod +x ~/esbootstrap.sh",
      "sudo ~/esbootstrap.sh",
    ]
  }
}

resource "null_resource" "ESDataNode3_BootStrap" {
  depends_on = [oci_core_instance.BastionHost, oci_core_instance.ESMasterNode1, oci_core_instance.ESMasterNode2, oci_core_instance.ESMasterNode3, oci_core_instance.ESDataNode1, oci_core_instance.ESDataNode2, oci_core_instance.ESDataNode3, oci_core_instance.ESDataNode4]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.ESDataNode3Vnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.BastionHost.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = data.template_file.setup_esbootstrap.rendered
    destination = "~/esbootstrap.sh"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.ESDataNode3Vnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.BastionHost.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = [
      "chmod +x ~/esbootstrap.sh",
      "sudo ~/esbootstrap.sh",
    ]
  }
}

resource "null_resource" "ESDataNode4_BootStrap" {
  depends_on = [oci_core_instance.BastionHost, oci_core_instance.ESMasterNode1, oci_core_instance.ESMasterNode2, oci_core_instance.ESMasterNode3, oci_core_instance.ESDataNode1, oci_core_instance.ESDataNode2, oci_core_instance.ESDataNode3, oci_core_instance.ESDataNode4]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.ESDataNode4Vnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.BastionHost.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    content     = data.template_file.setup_esbootstrap.rendered
    destination = "~/esbootstrap.sh"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.ESDataNode4Vnic.private_ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
      bastion_host = oci_core_instance.BastionHost.public_ip
      bastion_port = "22"
      bastion_user = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = [
      "chmod +x ~/esbootstrap.sh",
      "sudo ~/esbootstrap.sh",
    ]
  }
}