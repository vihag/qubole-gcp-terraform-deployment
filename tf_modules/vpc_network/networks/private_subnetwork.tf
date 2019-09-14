/*
Creates a SubNetwork in the Qubole Dedicated VPC.
 1. This will be the notional private subnetwork in which Qubole will launch clusters without External IP

 This is for the following reason:
 1. Not having internet access can be an important security requirment
*/

resource "google_compute_subnetwork" "cloud_sql_proxy_private_subnetwork" {
  name = "cloud-sql-proxy-private-subnetwork"
  ip_cidr_range = "10.3.0.0/24"
  region = var.qubole_dedicated_vpc_private_subnetwork_region
  network = google_compute_network.qubole_dedicated_vpc.self_link
  private_ip_google_access = true
}
