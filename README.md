
# AWS Terraform Terragrunt Infrastructure Project

This project demonstrates a scalable and maintainable approach to managing AWS infrastructure using Terraform and Terragrunt. It provides a modular structure for managing S3 buckets across multiple environments with proper state management and CI/CD integration.

## 🏗️ Architecture Overview

The project follows a modular architecture with:
- **Reusable Terraform modules** for infrastructure components
- **Environment-specific configurations** for development and production
- **Terragrunt** for DRY (Don't Repeat Yourself) configuration management
- **Jenkins CI/CD pipeline** for automated deployments
- **Remote state management** using S3 backend

## 📁 Project Structure

```
aws-terraform-terragrunt/
├── aws-terraform-terragrunt/
│   ├── modules/
│   │   └── s3-bucket/           # Reusable S3 bucket module
│   │       ├── main.tf          # Main Terraform configuration
│   │       ├── variables.tf     # Input variables
│   │       └── outputs.tf       # Output values
│   ├── envs/
│   │   ├── dev/                 # Development environment
│   │   │   ├── terragrunt.hcl   # Terragrunt configuration
│   │   │   ├── backend.hcl      # Backend configuration
│   │   │   ├── provider.tf      # AWS provider configuration
│   │   │   └── variables.tf     # Environment variables
│   │   └── prod/                # Production environment
│   │       ├── terragrunt.hcl   # Terragrunt configuration
│   │       ├── backend.hcl      # Backend configuration
│   │       ├── provider.tf      # AWS provider configuration
│   │       └── variables.tf     # Environment variables
│   └── ci-cd/
│       └── jenkins/
│           └── terraform-pipeline.groovy  # Jenkins pipeline
├── script.sh                    # Project setup script
├── README.md                    # This file
└── .gitignore                   # Git ignore rules
```

## 🚀 Features

### Infrastructure Components
- **S3 Buckets**: Secure, private S3 buckets with public access blocking
- **State Management**: Remote state storage in S3 with encryption
- **Environment Isolation**: Separate configurations for dev and prod
- **Security**: Proper IAM roles, security groups, and access controls

### DevOps Features
- **Terragrunt**: DRY configuration management
- **Modular Design**: Reusable Terraform modules
- **CI/CD Pipeline**: Automated deployment with Jenkins
- **Environment Management**: Consistent deployment across environments

## 📋 Prerequisites

### Required Tools
- **Terraform** (>= 1.0.0)
- **Terragrunt** (>= 0.35.0)
- **AWS CLI** (>= 2.0.0)
- **Jenkins** (for CI/CD pipeline)

### AWS Requirements
- AWS account with appropriate permissions
- S3 bucket for Terraform state storage
- IAM roles and policies for Terraform execution
- AWS credentials configured locally

### Jenkins Requirements
- Jenkins server with required plugins
- AWS credentials configured in Jenkins
- Git repository access

## 🔧 Setup Instructions

### 1. Clone and Configure Repository

```bash
git clone <your-repository-url>
cd aws-terraform-terragrunt
```

### 2. Configure AWS Credentials

1. **Set up AWS profiles**:
   ```bash
   aws configure --profile your-dev-profile
   aws configure --profile your-prod-profile
   ```

2. **Update provider configurations**:
   - Edit `envs/dev/provider.tf` and replace `your-dev-profile`
   - Edit `envs/prod/provider.tf` and replace `your-prod-profile`

### 3. Configure State Management

1. **Create S3 buckets for state storage**:
   ```bash
   # Development state bucket
   aws s3 mb s3://your-terraform-state-bucket --region us-west-2
   aws s3api put-bucket-versioning --bucket your-terraform-state-bucket --versioning-configuration Status=Enabled
   
   # Production state bucket
   aws s3 mb s3://your-prod-terraform-state-bucket --region us-east-1
   aws s3api put-bucket-versioning --bucket your-prod-terraform-state-bucket --versioning-configuration Status=Enabled
   ```

2. **Update backend configurations**:
   - Edit `envs/dev/backend.hcl` and `envs/dev/terragrunt.hcl`
   - Edit `envs/prod/backend.hcl` and `envs/prod/terragrunt.hcl`
   - Replace bucket names with your actual S3 bucket names

### 4. Configure Environment Variables

1. **Create terraform.tfvars files**:
   ```bash
   # Development
   cp envs/dev/variables.tf envs/dev/terraform.tfvars
   # Edit envs/dev/terraform.tfvars with your values
   
   # Production
   cp envs/prod/variables.tf envs/prod/terraform.tfvars
   # Edit envs/prod/terraform.tfvars with your values
   ```

2. **Set required variables**:
   - `bucket_name`: Base name for your S3 bucket
   - `tags`: Environment-specific tags

### 5. Configure Jenkins Pipeline

1. **Update pipeline configuration**:
   - Edit `ci-cd/jenkins/terraform-pipeline.groovy`
   - Replace `your-dev-profile` and `your-prod-profile`
   - Update repository URL

2. **Set up Jenkins job**:
   - Create new Pipeline job
   - Configure SCM to point to your repository
   - Set pipeline script from SCM

## 🚀 Usage

### Manual Deployment

#### Development Environment
```bash
cd aws-terraform-terragrunt/envs/dev

# Initialize Terragrunt
terragrunt init

# Plan changes
terragrunt plan

# Apply changes
terragrunt apply
```

#### Production Environment
```bash
cd aws-terraform-terragrunt/envs/prod

# Initialize Terragrunt
terragrunt init

# Plan changes
terragrunt plan

# Apply changes
terragrunt apply
```

### Automated Deployment

1. **Trigger Jenkins pipeline**:
   - Go to Jenkins dashboard
   - Select your Terraform pipeline job
   - Choose environment (dev/prod)
   - Click "Build with Parameters"

2. **Monitor deployment**:
   - Check Jenkins build logs
   - Verify AWS resources creation
   - Review Terraform outputs

## 🔒 Security Considerations

### ⚠️ **IMPORTANT: Security Best Practices**

1. **Never commit sensitive information**:
   - AWS access keys and secret keys
   - Passwords and tokens
   - Private keys and certificates
   - Database credentials

2. **Use secure credential management**:
   - Store credentials in Jenkins credentials store
   - Use AWS IAM roles when possible
   - Rotate credentials regularly

3. **Follow the principle of least privilege**:
   - Grant minimal required permissions
   - Use IAM policies to restrict access
   - Regular permission reviews

4. **Monitor and audit**:
   - Enable CloudTrail logging
   - Monitor access patterns
   - Regular security assessments

### Security Features Implemented

- ✅ **S3 Bucket Security**: Public access blocking enabled
- ✅ **State Encryption**: Remote state stored with encryption
- ✅ **Environment Isolation**: Separate state and configurations
- ✅ **IAM Roles**: Proper role-based access control
- ✅ **No Hardcoded Secrets**: All sensitive data externalized

## 📊 Module Documentation

### S3 Bucket Module

The S3 bucket module creates a secure, private S3 bucket with the following features:

#### Input Variables
- `bucket_name`: Base name for the S3 bucket
- `env`: Environment name (dev/prod)
- `tags`: Map of tags to apply to the bucket

#### Outputs
- `bucket_id`: The name of the created bucket
- `bucket_arn`: The ARN of the created bucket

#### Security Features
- Private ACL
- Public access blocking
- Encryption enabled
- Versioning enabled

## 🔧 Configuration

### Environment-Specific Configuration

Each environment has its own configuration files:

#### Development (`envs/dev/`)
- **Region**: us-west-2
- **Profile**: your-dev-profile
- **State Bucket**: your-terraform-state-bucket
- **State Key**: dev/terraform.tfstate

#### Production (`envs/prod/`)
- **Region**: us-east-1
- **Profile**: your-prod-profile
- **State Bucket**: your-prod-terraform-state-bucket
- **State Key**: prod/terraform.tfstate

### Terragrunt Configuration

Terragrunt is used to:
- Manage remote state configuration
- Pass common variables to modules
- Ensure consistent deployment across environments
- Reduce code duplication

## 🛠️ Troubleshooting

### Common Issues

#### Terragrunt Init Fails
- Verify S3 bucket exists and is accessible
- Check AWS credentials and permissions
- Ensure backend configuration is correct

#### AWS Profile Issues
- Verify AWS profiles are configured correctly
- Check profile permissions
- Ensure credentials are valid

#### State Lock Issues
- Check if another process is using the state
- Verify DynamoDB table exists (if using state locking)
- Check IAM permissions for state operations

### Debug Commands

```bash
# Check AWS credentials
aws sts get-caller-identity --profile your-dev-profile

# Check S3 bucket access
aws s3 ls s3://your-terraform-state-bucket

# Validate Terraform configuration
terragrunt validate

# Show Terragrunt configuration
terragrunt terragrunt-info
```

## 📈 Best Practices

### Infrastructure Management
1. **Use modules** for reusable components
2. **Version your modules** for consistency
3. **Use remote state** for team collaboration
4. **Implement proper tagging** for resource management

### Security
1. **Follow least privilege principle**
2. **Use IAM roles instead of access keys**
3. **Enable CloudTrail logging**
4. **Regular security audits**

### CI/CD
1. **Automate deployments** with proper approvals
2. **Use environment-specific configurations**
3. **Implement proper testing** before production
4. **Monitor deployments** and rollback procedures

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test in development environment
5. Submit a pull request
6. Ensure all tests pass

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues and questions:
1. Check the troubleshooting section
2. Review Terraform and Terragrunt documentation
3. Contact the DevOps team
4. Check AWS support if needed

## 📚 Resources

- [Terraform Documentation](https://www.terraform.io/docs/)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Jenkins Pipeline Documentation](https://www.jenkins.io/doc/book/pipeline/)


