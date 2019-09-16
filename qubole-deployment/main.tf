provider "google" {
  credentials = file("${path.module}/google_credentials/terraform_credentials.json")
  project = "qubole-on-gcp"
}

provider "google-beta" {
  credentials = file("${path.module}/google_credentials/terraform_credentials.json")
  project = "qubole-on-gcp"
}

resource "random_id" "deployment_suffix" {
  byte_length = 4
}

module "account_integration" {
  source = "./modules/account_integration"
  deployment_suffix = random_id.deployment_suffix.hex
}

module "network_infrastructure" {
  source = "./modules/network_infrastucture"
  deployment_suffix = random_id.deployment_suffix.hex
}

module "hive_metastore" {
  source = "./modules/hive_metastore"
  deployment_suffix = random_id.deployment_suffix.hex
  qubole_dedicated_vpc = module.network_infrastructure.qubole_dedicated_vpc_link
  qubole_bastion_internal_ip = module.network_infrastructure.qubole_bastion_internal_ip
  qubole_private_subnet_cidr = module.network_infrastructure.qubole_vpc_private_subnetwork_cidr
}
