terraform {
  backend "s3" {
    bucket         = "terraform-state-r1w9v5"
    key            = "dev/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    use_lockfile   = true
  }
}
