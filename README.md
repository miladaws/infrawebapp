# Infrawebapp with Terraform 

This Terraform setup is designed for deploying a web application on AWS, establishing a connection between a container and a database within the infrastructure.

### Prerequisites

- AWS Account
- Terraform installed locally or in your CI/CD environment
- AWS CLI configured with appropriate credentials

1. Clone the repository:
   ```sh
   git clone https://github.com/miladaws/infrawebapp

## Installation
1. Navigate to the aws-backend folder:
cd aws-backend

2. Execute the following command in yout terminal:
terraform init
terraform plan
terraform apply (Confirm the apply action by typing yes when prompted)
§

3. Navigate to the root folder:
cd ..

4. Execute the following command in yout terminal:
(The password for PostgreSQL RDS instance is taken via input variable. Enter a password when prompted)

terraform init
terraform plan
terraform apply (Confirm the apply action by typing yes when prompted)

## Infrastructure Overview
The Terraform configuration includes the following key modules:

- database: Contains the setup for the PostgreSQL RDS instance.
- ecs_container: Contains the setup for the container setup.
- networking: Contains the setup for the network-related configurations and resources.



