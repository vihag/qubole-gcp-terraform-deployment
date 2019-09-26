variable "deployment_suffix" {
}

variable "data_lake_project" {
}

variable "data_lake_project_number" {
}

variable "data_lake_project_region" {
  default = "asia-southeast1"
}

variable "qubole_bastion_host_vm_type" {
  default = "f1-micro"
}

variable "qubole_bastion_host_vm_zone" {
  default = "asia-southeast1-a"
}

variable "qubole_tunnel_nat" {
  default = "34.73.1.130/32"
}

variable "qubole_public_key" {
  default = "get from account"
}

variable "account_ssh_key" {
  default = "get from account"
}