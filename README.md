
# AWS Terraform Terragrunt Project

This project uses Terraform and Terragrunt to manage AWS infrastructure, specifically focusing on S3 bucket creation.


### Modules

The `modules` directory contains reusable Terraform modules. Currently, there's one module:

- `s3-bucket`: Defines an AWS S3 bucket with associated resources.

### Environments

The `envs` directory contains environment-specific configurations:

- `dev`: Development environment configuration
- `prod`: Production environment configuration

Each environment directory contains:

- `backend.hcl`: Defines the Terraform backend configuration
- `provider.tf`: Specifies the AWS provider configuration
- `terraform.tfvars`: Contains environment-specific variable values
- `terragrunt.hcl`: Terragrunt configuration file
- `variables.tf`: Declares input variables for the Terraform configuration

### CI/CD

The `ci-cd` directory contains CI/CD related files:

- `jenkins/terraform-pipeline.groovy`: Jenkins pipeline script for automating Terraform/Terragrunt operations

## Usage

To apply changes to an environment:

1. Navigate to the desired environment directory (e.g., `cd envs/dev`)
2. Run Terragrunt commands:

```
terragrunt init  
terragrunt plan  
terragrunt apply
```

## Notes

- Ensure AWS credentials are properly configured before running Terragrunt commands.
- Review and update `terraform.tfvars` files in each environment directory to set appropriate variable values.
- The Jenkins pipeline can be used to automate the deployment process across environments.


