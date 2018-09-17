terraform {
  required_version = "~> 0.11"
}

provider "aws" {
  region  = "eu-central-1"
  profile = "inovex-dev"
}

provider "template" {}
