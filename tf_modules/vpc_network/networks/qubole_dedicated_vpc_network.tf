/*
Creates a VPC that will be dedicated to use by Qubole.
*/

resource "google_compute_network" "qubole_dedicated_vpc" {
  name = "qubole-dedicated-vpc"
  auto_create_subnetworks = false
}
