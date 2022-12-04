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
  region  = var.region

  default_tags {
    tags = {
      Environment = var.environment_identifier
      Service     = var.service_name
    }
  }
}

module "iam" {
  source                 = "../../modules/iam"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier
}

module "kms" {
  source                 = "../../modules/kms"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier
}

module "s3" {
  source                 = "../../modules/s3"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier
}

module "codebuild" {
  source                 = "../../modules/codebuild"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier

  build_timeout                = var.build_timeout
  frontend_app_name            = var.frontend_app_name
  runtime_version_for_frontend = var.runtime_version_for_frontend
  iam_role_codebuild_arn       = module.iam.iam_role_codebuild_arn
}

module "cloudwatch" {
  source                 = "../../modules/cloudwatch"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier
}
