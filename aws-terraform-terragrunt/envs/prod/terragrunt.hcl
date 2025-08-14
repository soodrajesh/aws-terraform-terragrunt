terraform {
  source = "../../modules/s3-bucket"

  extra_arguments "common_vars" {
    commands = ["plan", "apply", "destroy"]
    arguments = [
      "-var-file=../../vars/dev.tfvars"
    ]
  }
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "your-prod-terraform-state-bucket"  # Replace with your production S3 bucket name
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
