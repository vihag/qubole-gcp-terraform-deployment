# Terraform: Qubole Deployment 

<h2>What is <a href="https://www.terraform.io/">Terraform</a>?</h2>
<p>
    Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. 
    Terraform can manage existing and popular service providers as well as custom in-house solutions.
</p>

<h2>What is <a href="https://www.qubole.com/">Qubole</a>?</h2>
<p>
    Qubole is a Single platform for end-to-end big data processing
    It is the only cloud-native platform to deliver deep analytics, AI, and machine learning for your big data. 
    It provides easy-to-use end user tools such as SQL query tools, notebooks, and dashboards that leverage powerful open source engines. 
    Qubole provides a single, shared infrastructure that enables users to more efficiently conduct ETL, analytics, and AI/ML workloads 
    across best-of-breed open source engines including Apache Spark, TensorFlow, Presto, Airflow, Hadoop, Hive, and more.
</p>

<h2>What is the purpose of this project?</h2>
<p>
    When an organization or a customer wants to use Qubole on GCP, they need to integrate their GCP Project with Qubole. This includes
    
    * IAM permissions
        * Compute
        * Storage
        * Big Query
    * Dedicated networking components
        * VPC Network
        * Subnetworks
        * Firewall Rules
        * NAT Gateways
    * Hive Metastore
    
    That said, The purpose of this project is two-fold
    Using the DRY principle promoted by Terraform, create re-usable, customizable Terraform modules that
    1. Create IAM Roles, Service Accounts and Policies that 
        i. Allow Qubole to Create Clusters and perform complete life cycle management
        ii. Allow the clusters to write audit data, command logs/results/resources onto Google Cloud Storage
        iii. Allow the clusters to read data from Big Query
    2. Create infrastructure dedicated for use by Qubole(hence isolating it from other resources)
        i. A dedicated VPC network with a public and private subnet
        ii. A bastion host for securing communications with Qubole
        iii. A NAT Gateway to secure outbound communications in the private subnet
        iv. Associated firewall rules to secure inter-component communications
        
    Additionally, the project also contains a module to spin up a Hive Metastore if the customer or organization does not already have one.
    The module will do the following
    1. Create a Cloud SQL Instance (MySQL Gen 2) with a database configured as the Hive Metastore
    2. Create a GCE VM and run Cloud SQL Proxy on it, creating a proxy connection to the Cloud SQL instance
    3. Establish Private IP connectivity between the Cloud SQL Proxy and the Cloud SQL Instance hosting the Hive Metastore
    4. Peer the Cloud SQL VPC with the Qubole dedicated VPC for secure access
    3. Additionally, the templates will whitelist the private subnet and bastion host to be able to access the Cloud SQL Proxy
</p>       

<h2>How does the integration look like?</h2>
<p>
    <img src="./readme_files/qubole_gcp_integration_diagram.png" title="Qubole GCP Integration Reference Architecture">
</p>

<h2>How to use the project?</h2>
<p>
    All the modules are tf files(in HCL) in the modules folder. Each tf file has detailed documentation on its purpose in life and its use to the Qubole deployment
    The main.tf can be customized to cherry pick which modules to deploy.
</p>

### Prerequisites

#### Create a Service Account with JSON Credentials

Ensure the following permissions are enabled in the Service Account:
```
Compute Admin
Role Administrator
Service Account Admin
Project IAM Admin
Service Networking Admin
Storage Admin
Cloud SQL Admin
```

Update `qubole-gcp-terraform-deployment/qubole-deployment/google_credentials/terraform_credentials.json` with the JSON credentials.

#### Ensure the following GCP APIs are enabled:
```
https://console.cloud.google.com/apis/api/iam.googleapis.com/overview
https://console.developers.google.com/apis/api/compute.googleapis.com/overview
https://console.cloud.google.com/apis/api/cloudresourcemanager.googleapis.com/overview
https://console.developers.google.com/apis/api/servicenetworking.googleapis.com/overview
https://console.developers.google.com/apis/api/sqladmin.googleapis.com/overview
```

#### Edit Parameters

In `qubole-gcp-terraform-deployment/qubole-deployment/main.tf`:

1. `data_lake_project`: GCP project ID
2. `data_lake_project_number`: GCP project number.

In `qubole-gcp-terraform-deployment/qubole-deployment/modules/account_integration/variables.tf`:

1. `qubole_service_account`: Your QSA in Qubole account settings

In `qubole-gcp-terraform-deployment/qubole-deployment/modules/network_infrastucture/variables.tf`:

1. `qubole_public_key`: You can retrieve this by navigating to the Advanced Configuration page of a cluster and scroll down to security settings.
2. `account_ssh_key`: https://docs.qubole.com/en/latest/rest-api/account_api/account-SSH-key.html

### There are 3 modules

#### 1. The account_integration module
```
i. Setup a custom compute role with minimum compute permissions
ii. Setup a custom storage role with minimum storage permissions
iii. Setup a service account that will act as the Compute Service Account
iv. Setup a service account that will act as the Instance Service Account
v. Authorize the Qubole Service Account to be able to use the Compute Service Account
vi. Authorize the Compute Service Account to be able to use the Instance Service Account
vii. Authorize the Service Accounts to be able to read Big Query Datasets
viii. Create a Cloud Storage Bucket which will be the account's Default Location
```
#### 2. The network_infrastructure module
```
i. Setup a VPC Network with a public and private subnet
ii. Setup a Bastion host in the public subnet and whitelist Qubole ingress to it
iii. Setup a Cloud NAT to allow clusters spun up in the private subnet access to the internet
```
#### 3. The hive_metastore module
```
i. Setup a Cloud SQL Instance hosting the Hive Metastore, exposed via a Cloud SQL Proxy Service
ii. Peer the Cloud SQL Proxy VPC to the Qubole Dedicated VPC for secure access
iii. Whitelist Bastion ingress and private subnet ingress to the Cloud SQL Proxy Service
iv. Setup Private IP connection between the SQL proxy and the Cloud SQL instance for maximum security and performance
```
#### Deploy the modules as follows
```
1. Navigate to the qubole-deployment folder
2. Edit the main.tf to choose which modules to deploy
3. Add the credentials file of the Service Account to be used by Terraform at ./google_credentials
4. Review the variables in each module and update as required
5. terraform init
6. terraform plan
7. terraform apply
```


<p>That's all folks</p>
