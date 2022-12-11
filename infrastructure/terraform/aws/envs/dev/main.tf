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
  region = var.region

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

  iam_role_codebuild_arn      = module.iam.iam_role_codebuild_arn
  iam_role_codepipeline_arn   = module.iam.iam_role_codepipeline_arn
  kms_key_arn                 = module.kms.kms_key_arn
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
}

module "cloudfront" {
  source                 = "../../modules/cloudfront"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier

  default_root_object                           = var.default_root_object
  s3_bucket_cloudfront_log_id                   = module.s3.s3_bucket_cloudfront_log_id
  s3_bucket_hosting_bucket_regional_domain_name = module.s3.s3_bucket_hosting_bucket_regional_domain_name
  s3_bucket_hosting_id                          = module.s3.s3_bucket_hosting_id
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

module "codepipeline" {
  source                 = "../../modules/codepipeline"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier

  repository_name                = var.repository_name
  iam_role_codepipeline_arn      = module.iam.iam_role_codepipeline_arn
  codebuild_project_frontend_arn = module.codebuild.codebuild_project_frontend_arn
  kms_key_arn                    = module.kms.kms_key_arn
  s3_bucket_hosting_id           = module.s3.s3_bucket_hosting_id
  s3_bucket_artifact_id          = module.s3.s3_bucket_artifact_id
}

module "cloudwatch" {
  source                 = "../../modules/cloudwatch"
  service_name           = var.service_name
  environment_identifier = var.environment_identifier
}
