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

output "compute_service_account" {
  value =module.account_integration.qubole_compute_service_account
}

output "instance_service_account" {
  value =module.account_integration.qubole_instance_service_account
}

output "qubole_defloc" {
  value =module.account_integration.qubole_defloc_bucket_name
}

output "qubole_dedicated_vpc" {
  value = module.network_infrastructure.qubole_dedicated_vpc_link
}

output "qubole_dedicated_bastion" {
  value = module.network_infrastructure.qubole_bastion_external_ip
}

output "qubole_bastion_user" {
  value = "bastion-user"
}

output "hive_metastore_ip" {
  value = module.hive_metastore.cloud_sql_proxy_networkIP
}

output "hive_metastore_db_schema" {
  value = module.hive_metastore.hive_metastore_schema
}

output "hive_metastore_db_user" {
  value = module.hive_metastore.hive_metastore_user
}

output "hive_metastore_db_user_password" {
  value = module.hive_metastore.hive_metastore_user_password
}
