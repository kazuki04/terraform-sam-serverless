data "aws_codecommit_repository" "this" {
  repository_name = var.repository_name
}

resource "aws_codepipeline" "program" {
  name     = "${var.service_name}-${var.environment_identifier}-pipeline-program"
  role_arn = var.iam_role_codepipeline_arn

  artifact_store {
    location = var.s3_bucket_artifact_id
    type     = "S3"

    encryption_key {
      id   = var.kms_key_arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      input_artifacts  = []
      output_artifacts = ["SourceOutput"]

      configuration = {
        RepositoryName       = data.aws_codecommit_repository.this.repository_name
        BranchName           = "release/${var.environment_identifier}"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "BuildFrontend"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = var.codebuild_project_frontend_arn
      }
    }
  }

  stage {
    name = "Approve"

    action {
      name     = "Approve"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "DeployFrontend"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "S3"
      input_artifacts  = ["BuildArtifact"]
      output_artifacts = []
      version          = "1"

      configuration = {
        BucketName = var.s3_bucket_hosting_id
        Extract    = true
        # ObjectKey
        # KMSEncryptionKeyARN
        # CannedACL
        # CacheControl
      }
    }
  }
}
