provider "google" {
  credentials = file("${path.module}/google_credentials/qubole-on-gcp-8216806add0f.json")
}

provider "google-beta" {
  credentials = file("${path.module}/google_credentials/qubole-on-gcp-8216806add0f.json")
}

module "account_integration" {
  source = "./modules/account_integration"
}

module "network_infrastructure" {
  source = "./modules/network_infrastucture"
}

module "hive_metastore" {
  source = "./modules/hive_metastore"

  qubole_dedicated_vpc = module.network_infrastructure.qubole_dedicated_vpc_link
  qubole_bastion_internal_ip = module.network_infrastructure.qubole_bastion_internal_ip
  qubole_private_subnet_cidr = module.network_infrastructure.qubole_vpc_private_subnetwork_cidr
}