terraform {
  source = "../../modules/s3-bucket"

  extra_arguments "common_vars" {
    commands = ["plan", "apply", "destroy"]
    arguments = [
      "-var-file=${get_terragrunt_dir()}/terraform.tfvars"
    ]
  }
}


remote_state {
  backend = "s3"
  config = {
    bucket  = "terraform-state-r1w9v5"
    key     = "dev/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
  }
}

# Include any inputs that should be passed to the module
inputs = {
  # You can override or add to variables from tfvars files here
  env = "dev"
}
