locals {
  runtime_language = element(split(":", var.runtime_version_for_frontend), 0)
  runtime_version  = element(split(":", var.runtime_version_for_frontend), 1)
}

resource "aws_codebuild_project" "frontend" {
  name          = "${var.service_name}-${var.environment_identifier}-cbproject-frontend"
  description   = "${var.service_name} CodeBuild project in ${var.environment_identifier}"
  build_timeout = var.build_timeout
  service_role  = var.iam_role_codebuild_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.service_name}-${var.environment_identifier}-cbproject-frontend"
      stream_name = "cbproject-frontend"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = <<-EOT
      version: '0.2'
      phases:
        install:
          runtime-versions:
            ${local.runtime_language}: ${local.runtime_version}
          commands: 
            - echo Install phase...
            - echo Installing dependency...
            - cd $CODEBUILD_SRC_DIR/program/frontend/${var.frontend_app_name}
            - yarn
        build:
          commands:
            - echo Build phase...
            - echo Compiling the Next.js
            - cd $CODEBUILD_SRC_DIR/program/frontend/${var.frontend_app_name}
            - yarn build
      artifacts:
        files:
          - $CODEBUILD_SRC_DIR/program/frontend/${var.frontend_app_name}/out/**/*
    EOT
  }

  source_version = "master"

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-cbproject-frontend"
  }
}
