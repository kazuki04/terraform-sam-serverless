# 概要

# 環境構築
## インフラリソースの作成・更新
1. infrastructure/cloudformation/cloudformation-common.yamlからStackを作成して、プロジェクトにおいて共通で使用するリソースを作成する。(CodeCommitリポジトリやS3バケット)
2. 以下コマンドを実行してTerraform用パイプラインを構築するCloudFormationテンプレートをパッケージ化する。
    ```
    aws cloudformation package --template-file terraform-environment.yaml --s3-bucket ${service name}-${environment identifier}-common-s3 --s3-prefix terraform-environment/${environment identifier}--output-template-file out-terraform-environment.yaml
    ```

3. パッケージ化されたout-terraform-environment.yamlを元に、Terraformパイプライン用のStackを作成する。

4. 以下コマンドを実行してS3バケットにtfvarsファイルをアップロードする。
    ```
    aws s3 cp ./terraform.tfvars s3://${service name-${environment identifier}-tfe-s3-tfvars/${service name}/dev/terraform.tfvars
    ```
5. 作成されたTerraformパイプライン「\${service name}-${environment identifier}-tfe-tf-pipeline」を実行してインフラリソースの作成・更新を行う。

    ※ Terraformパイプラインのソースはrelease/${environment identifier}ブランチ。
