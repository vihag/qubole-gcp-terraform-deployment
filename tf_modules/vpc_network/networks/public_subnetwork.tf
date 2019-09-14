/*
Creates a SubNetwork in the Qubole Dedicated VPC.
 1. This will be the notional public subnetwork in which a Bastion Host will reside

 This is for the following reason:
 1. The Bastion host is the secure gateway through which Qubole will talk to the clusters running in the customer's project/network
*/

resource "google_compute_subnetwork" "cloud_sql_proxy_public_subnetwork" {
  name = "cloud-sql-proxy-public-subnetwork"
  ip_cidr_range = "10.2.0.0/24"
  region = var.qubole_dedicated_vpc_public_subnetwork_region
  network = google_compute_network.qubole_dedicated_vpc.self_link
  private_ip_google_access = true
}
