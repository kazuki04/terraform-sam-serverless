data "aws_region" "current" {}

locals {
  runtime_language        = element(split(":", var.runtime_version_for_frontend), 0)
  runtime_version         = element(split(":", var.runtime_version_for_frontend), 1)
  ddb_survey_tabale_name  = element(split("/", var.dynamodb_table_survey_arn), 1)
  ddb_question_table_name = element(split("/", var.dynamodb_table_question_arn), 1)
  ddb_result_table_name   = element(split("/", var.dynamodb_table_result_arn), 1)
}

################################################################################
# Frontend
################################################################################
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
          - '_next/**/*'
          - index.html
          - 404.html
          - vercel.svg
          - favicon.ico
        base-directory: $CODEBUILD_SRC_DIR/program/frontend/${var.frontend_app_name}/out
    EOT
  }

  source_version = "master"

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-cbproject-frontend"
  }
}

################################################################################
# SAM
################################################################################
resource "aws_codebuild_project" "sam_package" {
  name          = "${var.service_name}-${var.environment_identifier}-cbproject-sam-package"
  description   = "${var.service_name} CodeBuild project for sam package in ${var.environment_identifier}"
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
      group_name  = "/aws/codebuild/${var.service_name}-${var.environment_identifier}-cbproject-sam-package"
      stream_name = "cbproject-sam-package"
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
        build:
          commands:
            - echo Build phase...
            - cd $CODEBUILD_SRC_DIR/program/sam/survey
            - echo Building...
            - sam build
            - echo Creating template-configuration.json...
            - touch template-configuration.json
            - echo "{" > template-configuration.json
            - echo "  \"Parameters\":{" >> template-configuration.json
            - echo "    \"ServiceName\":\"${var.service_name}\"," >> template-configuration.json
            - echo "    \"EnvironmentIdentifier\":\"${var.environment_identifier}\"," >> template-configuration.json
            - echo "    \"DdbSurveyTableName\":\"${local.ddb_survey_tabale_name}\"," >> template-configuration.json
            - echo "    \"DdbQuestionTableName\":\"${local.ddb_question_table_name}\"," >> template-configuration.json
            - echo "    \"DdbResultTableName\":\"${local.ddb_result_table_name}\"" >> template-configuration.json
            - echo "  }" >> template-configuration.json
            - echo "}" >> template-configuration.json
            - cat >> template-configuration.json
            - echo Packaging...
            - sam package
              --s3-bucket "${var.service_name}-${var.environment_identifier}-common-s3"
              --output-template-file output-template.yaml
      artifacts:
        files:
          - output-template.yaml
          - template-configuration.json
        base-directory: $CODEBUILD_SRC_DIR/program/sam/survey
    EOT
  }

  source_version = "master"

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-cbproject-sam-package"
  }
}

resource "aws_codebuild_project" "sam_deploy" {
  name          = "${var.service_name}-${var.environment_identifier}-cbproject-sam-deploy"
  description   = "${var.service_name} CodeBuild project for sam deploy in ${var.environment_identifier}"
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
      group_name  = "/aws/codebuild/${var.service_name}-${var.environment_identifier}-cbproject-sam-deploy"
      stream_name = "cbproject-sam-deploy"
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
        build:
          commands:
            - echo Build phase...
            - ls
            - cd $CODEBUILD_SRC_DIR/program/sam/survey
            - echo Deploying...
            - sam deploy
              --template output-template.yaml
              --stack-name "${var.service_name}-${var.environment_identifier}-sam"
              --s3-bucket "${var.service_name}-${var.environment_identifier}-common-s3"
              --s3-prefix "${var.service_name}-${var.environment_identifier}-sam"
              --region ${data.aws_region.current.name}
              --no-confirm-changeset true
              --no-disable-rollback true
              --capabilities LIST "CAPABILITY_IAM"
        base-directory: $CODEBUILD_SRC_DIR/program/sam/survey
    EOT
  }

  source_version = "master"

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-cbproject-sam-deploy"
  }
}
