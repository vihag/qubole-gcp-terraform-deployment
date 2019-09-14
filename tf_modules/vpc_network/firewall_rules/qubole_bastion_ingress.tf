/*
Creates a Firewall Rule that
 1. Allows ingress to the Bastion Host from Qubole's Tunneling NAT
 2. Allows ingress to the Bastion Host from the Private Subnet in the Qubole Dedicated VPC

 This is for the following reason:
 1. Qubole Control Plane will talk(e.g. command submissions) to the Qubole Clusters via the Bastion Host
*/

resource "google_compute_firewall" "bastion_ingress_from_qubole_nat" {
  name = "bastion-ingress-from-bastion"
  network = google_compute_network.qubole_dedicated_vpc.self_link

  allow {
    protocol = "tcp"
    ports = [
      "22"]
  }
  source_ranges = [
    "34.73.1.130/32"]
  target_tags = [
    "qubole-bastion-host"]

}

resource "google_compute_firewall" "bastion_ingress_from_qubole_private_subnet" {
  name = "bastion-ingress-from-qubole-private-subnet"
  network = google_compute_network.cloud_sql_proxy_vpc.self_link

  allow {
    protocol = "tcp"
    ports = [
      "7000"]
  }
  source_ranges = [
    google_compute_subnetwork.qubole_dedicated_vpc_public_subnetwork.ip_cidr_range]
  target_tags = [
    "qubole-bastion-host"]
}
