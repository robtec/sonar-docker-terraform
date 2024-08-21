terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "sonar-terraform-state-54321"
    key            = "sonar-docker.tfstate"
    region         = "eu-west-1"
  }
}