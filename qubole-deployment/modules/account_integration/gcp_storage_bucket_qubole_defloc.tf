/*
Creates a Google Cloud Storage Bucket that will act as the "default location" for the Qubole account
 Qubole saves
 1. Cluster Start/Scale Logs
 2. Engine Logs
 3. Results
 4. Notebooks
 5. Py/R environments
 in this location

 This is for the following reason:
 1. Qubole performs Cluster Lifecycle Management. Which means it terminates idle clusters, downscales VMs to save cost and recreates clusters in catastrophic failures
 2. Qubole also makes available the logs, results, command histories, command UIs offline (and indefinetly)
 3. Qubole achieves this by storing all the above data in the defloc and loading it when the user requests for it

 Caveats:
 1. Deleting content from this location can have unintended consequences on the platform including loss of work and data
 2. Consult Qubole Support before moving this location
*/

resource "google_storage_bucket" "qubole_defloc_bucket" {
  name = "qubole_defloc"
  project = var.data_lake_project
  location = var.data_lake_project_region

}

data "google_iam_policy" "qubole_defloc_bucket_policy_data" {
  binding {
    role = google_project_iam_custom_role.qubole_custom_storage_role.id
    #Created as part of account IAM setup
    members = [
      "serviceAccount:${google_service_account.qubole_instance_service_acc.email}",
      "serviceAccount:${google_service_account.qubole_compute_service_acc.email}"]
  }
}

resource "google_storage_bucket_iam_policy" "qubole_defloc_bucket_policy" {
  bucket = google_storage_bucket.qubole_defloc_bucket.name
  policy_data = data.google_iam_policy.qubole_defloc_bucket_policy_data.policy_data
}

output "qubole_defloc_bucket_name" {
  value = google_storage_bucket.qubole_defloc_bucket.name
}
