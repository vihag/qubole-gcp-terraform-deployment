#!/usr/bin/env bash

cd ~
mkdir cloudsql
mkdir cloudsqldir
cd cloudsql
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
chmod +x cloud_sql_proxy

cloud_sql_instance_name=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/cloud_sql_instance -H "Metadata-Flavor: Google")
credentials_json=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/credentials_data -H "Metadata-Flavor: Google")

project_name=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/project_name -H "Metadata-Flavor: Google")
region=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/region -H "Metadata-Flavor: Google")

echo ${credentials_json} >> credentials.json

cloud_sql_instance_name="${project_name}:${region}:${cloud_sql_instance_name}"

./cloud_sql_proxy -credential_file=credentials.json -ip_address_types=PRIVATE -instances=${cloud_sql_instance_name}=tcp:0.0.0.0:3306 &> /tmp/cloud_sql_proxy.log
