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
    bucket         = "terraform-state-dev"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
