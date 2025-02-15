#!/bin/bash -e

# Define the directory structure
DIRS=(
  "aws-terraform-terragrunt/modules/s3-bucket"
  "aws-terraform-terragrunt/envs/dev"
  "aws-terraform-terragrunt/envs/prod"
  "aws-terraform-terragrunt/ci-cd/jenkins"
)

# Define the files to be created
FILES=(
  "aws-terraform-terragrunt/modules/s3-bucket/main.tf"
  "aws-terraform-terragrunt/modules/s3-bucket/variables.tf"
  "aws-terraform-terragrunt/modules/s3-bucket/outputs.tf"
  "aws-terraform-terragrunt/envs/dev/terragrunt.hcl"
  "aws-terraform-terragrunt/envs/dev/backend.hcl"
  "aws-terraform-terragrunt/envs/dev/provider.tf"
  "aws-terraform-terragrunt/envs/dev/variables.tf"
  "aws-terraform-terragrunt/envs/dev/terraform.tfvars"
  "aws-terraform-terragrunt/envs/prod/terragrunt.hcl"
  "aws-terraform-terragrunt/envs/prod/backend.hcl"
  "aws-terraform-terragrunt/envs/prod/provider.tf"
  "aws-terraform-terragrunt/envs/prod/variables.tf"
  "aws-terraform-terragrunt/envs/prod/terraform.tfvars"
  "aws-terraform-terragrunt/ci-cd/jenkins/terraform-pipeline.groovy"
)

# Create directories
for dir in "${DIRS[@]}"; do
  mkdir -p "$dir"
done

# Create empty files
for file in "${FILES[@]}"; do
  touch "$file"
done

echo "Terraform AWS project structure created successfully."
