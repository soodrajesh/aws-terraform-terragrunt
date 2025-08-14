#!/bin/bash

# Terraform/Terragrunt Configuration Validation Script
# This script validates the Terraform and Terragrunt configuration and checks prerequisites

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log function
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if Terraform is installed
check_terraform() {
    log "Checking Terraform installation..."
    if command -v terraform &> /dev/null; then
        local version=$(terraform version -json | jq -r '.terraform_version')
        success "Terraform is installed (version: $version)"
    else
        error "Terraform is not installed"
        echo "Please install Terraform from https://www.terraform.io/downloads.html"
        exit 1
    fi
}

# Check if Terragrunt is installed
check_terragrunt() {
    log "Checking Terragrunt installation..."
    if command -v terragrunt &> /dev/null; then
        local version=$(terragrunt --version | head -n1)
        success "Terragrunt is installed ($version)"
    else
        error "Terragrunt is not installed"
        echo "Please install Terragrunt from https://terragrunt.gruntwork.io/docs/getting-started/install/"
        exit 1
    fi
}

# Check if AWS CLI is installed
check_aws_cli() {
    log "Checking AWS CLI installation..."
    if command -v aws &> /dev/null; then
        local version=$(aws --version)
        success "AWS CLI is installed ($version)"
    else
        error "AWS CLI is not installed"
        echo "Please install AWS CLI from https://aws.amazon.com/cli/"
        exit 1
    fi
}

# Check AWS credentials
check_aws_credentials() {
    log "Checking AWS credentials..."
    if aws sts get-caller-identity &> /dev/null; then
        local account=$(aws sts get-caller-identity --query 'Account' --output text)
        local user=$(aws sts get-caller-identity --query 'Arn' --output text)
        success "AWS credentials are configured"
        log "Account: $account"
        log "User: $user"
    else
        error "AWS credentials are not configured or invalid"
        echo "Please configure AWS credentials using: aws configure"
        exit 1
    fi
}

# Check required files
check_files() {
    log "Checking required files..."
    
    local required_files=(
        "aws-terraform-terragrunt/modules/s3-bucket/main.tf"
        "aws-terraform-terragrunt/modules/s3-bucket/variables.tf"
        "aws-terraform-terragrunt/modules/s3-bucket/outputs.tf"
        "aws-terraform-terragrunt/envs/dev/terragrunt.hcl"
        "aws-terraform-terragrunt/envs/dev/backend.hcl"
        "aws-terraform-terragrunt/envs/dev/provider.tf"
        "aws-terraform-terragrunt/envs/dev/variables.tf"
        "aws-terraform-terragrunt/envs/prod/terragrunt.hcl"
        "aws-terraform-terragrunt/envs/prod/backend.hcl"
        "aws-terraform-terragrunt/envs/prod/provider.tf"
        "aws-terraform-terragrunt/envs/prod/variables.tf"
    )
    
    for file in "${required_files[@]}"; do
        if [[ -f "$file" ]]; then
            success "Found $file"
        else
            error "Missing required file: $file"
            exit 1
        fi
    done
}

# Check for sensitive data in configuration
check_sensitive_data() {
    log "Checking for sensitive data in configuration..."
    
    # Check for hardcoded AWS profiles
    if grep -r "rsood-private\|account1-admin\|account2-admin" aws-terraform-terragrunt/ 2>/dev/null | grep -v ".git" | grep -v ".terragrunt-cache"; then
        warning "Hardcoded AWS profile names found"
        echo "Please replace with placeholder values"
    else
        success "No hardcoded AWS profile names found"
    fi
    
    # Check for hardcoded S3 bucket names
    if grep -r "terraform-state-r1w9v5\|terraform-state-dev" aws-terraform-terragrunt/ 2>/dev/null | grep -v ".git" | grep -v ".terragrunt-cache"; then
        warning "Hardcoded S3 bucket names found"
        echo "Please replace with placeholder values"
    else
        success "No hardcoded S3 bucket names found"
    fi
    
    # Check for sensitive patterns
    if grep -r "password\|secret\|key\|token\|credential\|access_key\|secret_key" aws-terraform-terragrunt/ 2>/dev/null | grep -v ".git" | grep -v ".terragrunt-cache" | grep -v "description" | grep -v "terraform.tfvars.example"; then
        warning "Potential sensitive data found"
    else
        success "No obvious sensitive data found"
    fi
}

# Validate Terraform configuration
validate_terraform() {
    log "Validating Terraform configuration..."
    
    cd aws-terraform-terragrunt/modules/s3-bucket
    
    if terraform validate; then
        success "Terraform configuration is valid"
    else
        error "Terraform configuration validation failed"
        exit 1
    fi
    
    cd ../../..
}

# Check Terragrunt configuration
validate_terragrunt() {
    log "Validating Terragrunt configuration..."
    
    # Check development environment
    cd aws-terraform-terragrunt/envs/dev
    
    if terragrunt terragrunt-info &> /dev/null; then
        success "Development Terragrunt configuration is valid"
    else
        warning "Development Terragrunt configuration may have issues"
    fi
    
    cd ../..
    
    # Check production environment
    cd aws-terraform-terragrunt/envs/prod
    
    if terragrunt terragrunt-info &> /dev/null; then
        success "Production Terragrunt configuration is valid"
    else
        warning "Production Terragrunt configuration may have issues"
    fi
    
    cd ../..
}

# Check backend configuration
check_backend() {
    log "Checking backend configuration..."
    
    # Check development backend
    if grep -q "your-terraform-state-bucket" aws-terraform-terragrunt/envs/dev/backend.hcl; then
        warning "Development backend uses placeholder bucket name"
    else
        success "Development backend configured"
    fi
    
    # Check production backend
    if grep -q "your-prod-terraform-state-bucket" aws-terraform-terragrunt/envs/prod/backend.hcl; then
        warning "Production backend uses placeholder bucket name"
    else
        success "Production backend configured"
    fi
}

# Check provider configuration
check_provider() {
    log "Checking provider configuration..."
    
    # Check development provider
    if grep -q "your-dev-profile" aws-terraform-terragrunt/envs/dev/provider.tf; then
        warning "Development provider uses placeholder profile name"
    else
        success "Development provider configured"
    fi
    
    # Check production provider
    if grep -q "your-prod-profile" aws-terraform-terragrunt/envs/prod/provider.tf; then
        warning "Production provider uses placeholder profile name"
    else
        success "Production provider configured"
    fi
}

# Check CI/CD configuration
check_cicd() {
    log "Checking CI/CD configuration..."
    
    if [[ -f "aws-terraform-terragrunt/ci-cd/jenkins/terraform-pipeline.groovy" ]]; then
        success "Jenkins pipeline found"
        
        # Check for placeholder values
        if grep -q "your-dev-profile\|your-prod-profile" aws-terraform-terragrunt/ci-cd/jenkins/terraform-pipeline.groovy; then
            warning "Jenkins pipeline uses placeholder profile names"
        fi
        
        if grep -q "your-repo.git" aws-terraform-terragrunt/ci-cd/jenkins/terraform-pipeline.groovy; then
            warning "Jenkins pipeline uses placeholder repository URL"
        fi
    else
        warning "Jenkins pipeline not found"
    fi
}

# Main validation function
main() {
    echo "=========================================="
    echo "Terraform/Terragrunt Configuration Validation"
    echo "=========================================="
    echo
    
    check_terraform
    check_terragrunt
    check_aws_cli
    check_aws_credentials
    check_files
    check_sensitive_data
    validate_terraform
    validate_terragrunt
    check_backend
    check_provider
    check_cicd
    
    echo
    echo "=========================================="
    success "Validation completed!"
    echo "=========================================="
    echo
    echo "Next steps:"
    echo "1. Update placeholder values in configuration files"
    echo "2. Create terraform.tfvars files from examples"
    echo "3. Configure AWS profiles and S3 buckets"
    echo "4. Test deployment in development environment"
    echo "5. Set up Jenkins pipeline for automation"
}

# Run main function
main "$@"
