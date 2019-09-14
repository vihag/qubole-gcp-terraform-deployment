/*
Creates a Static Internal IP address for
 1. The GCE VM hosting the Cloud SQL Proxy Process

 This is for the following reason:
 1. Once enabling Private IP peering via GCP Deployment Manager is possible, this static IP will be used for communication with CloudSQL
*/

resource "google_compute_address" "qubole_bastion_internal_ip" {
  name = "qubole-bastion-internal-ip"
  region = var.qubole_bastion_host_internal_ip_region
  address_type = "INTERNAL"
  purpose = "GCE_ENDPOINT"
  subnetwork = google_compute_subnetwork.qubole_dedicated_vpc_public_subnetwork.self_link
}
