variable "deployment_suffix" {
}

variable "data_lake_project" {
  default = "qubole-on-gcp"
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

variable "qubole_public_key" {
  default = "<get your own>"
}

variable "account_ssh_key" {
  default = "<get your own>"
}