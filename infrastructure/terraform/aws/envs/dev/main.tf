terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.45.0"
    }
  }
  backend "s3" {
  }
}

provider "aws" {
  region  = "${var.region}"

  default_tags {
    tags = {
      Environment     = var.environment_identifier
      Service         = var.service_name
    }
  }
}

module "s3" {
  source = "../../modules/s3"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier
}
