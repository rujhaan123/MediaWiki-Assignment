provider "google" {
  project = var.project
  region  = var.region
}

resource "google_compute_firewall" "firewall" {
  name    = "gritfy-firewall-externalssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22","443"]
  }

  source_ranges = ["0.0.0.0/0"] # Not So Secure. Limit the Source Range
  target_tags   = ["externalssh"]
}

resource "google_compute_network" "default" {
  name = "test-network"
}



# We create a public IP address for our google compute instance to utilize
resource "google_compute_address" "static" {
  name       = "vm-public-address"
  project    = var.project
  region     = var.region
  depends_on = [google_compute_firewall.firewall]
}


resource "google_compute_instance" "dev" {
  name         = "devserver"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"
  tags         = ["externalssh", "webserver"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  provisioner "file" {

    # source file name on the local machine where you execute terraform plan and apply
    source = "LAMP_Stack.sh"

    # destination is the file location on the newly created instance
    destination = "/tmp/LAMP_Stack.sh"

    connection {
      host = google_compute_address.static.address
      type = "ssh"
      # username of the instance would vary for each account refer the OS Login in GCP documentation
      user    = var.user
      timeout = "500s"
      # private_key being used to connect to the VM. ( the public key was copied earlier using metadata )
      private_key = file(var.privatekeypath)
    }
  }

  # to connect to the instance after the creation and execute few commands for provisioning
  # here you can execute a custom Shell script or Ansible playbook
  provisioner "remote-exec" {
    connection {
      host = google_compute_address.static.address
      type = "ssh"
      # username of the instance would vary for each account refer the OS Login in GCP documentation
      user    = var.user
      timeout = "500s"
      # private_key being used to connect to the VM. ( the public key was copied earlier using metadata )
      private_key = file(var.privatekeypath)
    }

    # Commands to be executed as the instance gets ready.
    # set execution permission and start the script
    inline = [
      "chmod a+x /tmp/LAMP_Stack.sh",
      "sed -i -e 's/\r$//' /tmp/LAMP_Stack.sh",
      "sudo /tmp/LAMP_Stack.sh"
    ]
  }

  # Ensure firewall rule is provisioned before server, so that SSH doesn't fail.
  depends_on = [google_compute_firewall.firewall]

  service_account {
    email  = var.email
    scopes = ["compute-ro"]
  }
  metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }
}