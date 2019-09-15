/*
Creates a Google Compute Engine VM that will host a Cloud SQL Proxy process to connect to the Cloud SQL
 Features(Ideal)
 1. A networkIP i.e. a static internal address
 2. No network interfaces i.e. no external IP address
 3. Instead of a single node GCE setup, setup a GKE to make the Cloud SQL Proxy Highly Available
 In the ideal scenario, we will use Private IP Service Networking between the VPC hosting this Cloud SQL Proxy instance
 Any external application desiring to connect to the Cloud SQL instance, will use the Cloud SQL proxy
 With the private IP setup, we can make sure that neither the Cloud SQL Instance, nor the Proxy has an external IP, hence making connections
   very secure and removing latency
*/

resource "google_compute_instance" "cloud_sq_proxy_host" {
    name         = "cloud-sql-proxy-host"
    machine_type = var.cloud_sql_proxy_host_vm_type
    zone         = var.cloud_sql_proxy_host_vm_zone

    tags = ["cloud-sql-proxy-host"]

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-9"
        }
    }

    // Local SSD disk
    scratch_disk {
    }

    network_interface {
        network = google_compute_network.cloud_sql_proxy_vpc.self_link
        subnetwork = google_compute_subnetwork.cloud_sql_proxy_private_subnetwork.self_link
        network_ip = google_compute_address.cloud_sql_proxy_internal_ip.address
        access_config {
            //No public NIC
        }
    }

    metadata = {
        cloud_sql_instance = google_sql_database_instance.cloud_sql_for_hive_metastore.name
        startup-script = file("${path.module}/scripts/cloud_sql_proxy_startup.sh")
    }

}
