# 概要
TerraformとSAMを組み合わせたサーバレスアプリケーションを構築するためのリポジトリ。LambdaとAPI GatewayはSAMで管理し、それ以外のAWSリソースはTerraformで管理する。(Terraform用パイプラインやプロジェクト共通で使用するAWSリソースはCloudFormationで管理する。)

# 環境構築
## インフラリソースの作成・更新
1. infrastructure/cloudformation/cloudformation-common.yamlからStackを作成して、プロジェクトにおいて共通で使用するリソースを作成する。(CodeCommitリポジトリやCloudFormationのパッケージ化で使用するS3バケットなど)
2. 以下コマンドを実行してTerraform用パイプライン構築のためのCloudFormationテンプレートをパッケージ化する。
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

## プログラムデプロイ
### フロントエンドのデプロイ
「\${service name}-${environment identifier}-pipeline-program」というCodePipelineリソースの変更をリリースする。パイプラインが起動すると、Next.jsアプリのビルドが行われ、S3にビルドされたファイルがアップロードされる。

### SAMのデプロイ
「\${service name}-${environment identifier}-pipeline-sam」というCodePipelineリソースの変更をリリースする。パイプラインが起動すると、samのビルド、パッケージ化が行われ、パッケージ化されたファイルをもとにChangeSetが作成される。Approve後にChangeSetが実行されてSAMのリソースがデプロイされる。

# ディレクトリ構成
ディレクトリ構成は以下の通り。

```
.
├── README.md
├── infrastructure
│   ├── cloudformation
│   │   ├── cloudformation-common.yaml
│   │   └── terraform-environment
│   │       ├── terraform-backend.yaml
│   │       ├── terraform-common.yaml
│   │       ├── terraform-environment.yaml
│   │       └── terraform-pipeline.yaml
│   └── terraform
│       └── aws
│           ├── envs
│           └── modules
└── program
    ├── frontend
    │   └── app
    └── sam
        └── survey

```
## infrastructureディレクトリ
インフラリソースを作成するファイルを配置するディレクトリ。SAMで管理するLambda, API Gateway以外のインフラリソースを作成するファイルは、infrastructureディレクトリ配下に配置する。

## infrastructure/cloudformationディレクトリ
cloudformationディレクトリには、Terraform用パイプライン、CodeCommitやS3などの共通で使用されるリソースを作成するファイルを配置する。

## infrastructure/terraformディレクトリ
terraformディレクトリには、terraformで管理するインフラに関するファイルを配置する。terraformディレクトリ直下は各プロバイダーのディレクトリを作成する。

## programディレクトリ
プログラムに関するファイルを配置するディレクトリ。フロントエンドやSAMなどのプログラムに関わるファイルを配置する。

# アーキテクチャ図
![terraform_sam_serverless_architecture](https://user-images.githubusercontent.com/63912049/208443329-a6b8f534-9489-4b85-b3bc-2d2aec023b3e.png)


## アクセス経路
CloudFrontの前段にCloudflareを配置する。AWS WAFでCloudflareのIPのみアクセスを許可する。
CloudFrontのオリジンにNext.jsの静的サイトをホストするS3とAPI Gatewayを指定する。リクエストのパスに応じてCloudFrontのオリジンに振り分ける。

## プログラム
フロントエンドはS3に静的サイトとしてホスティングする。S3へのアクセス制御にはorigin access control(OAC)を使用する。

APIはSAMで構成する。APIに関するAWS LambdaとAPI Gatewayに関するリソースはSAMで管理し、それ以外のAWSリソースはCloudFoamtionとTerraformで管理する。

## CI/CD
CI/CDパイプラインは以下3つ。

■**CI/CDパイプラン**
- フロントエンド用パイプラン
- SAM用パイプライン
- Terraform用パイプラン

### フロントエンド用パイプラン
CodeBuildでNext.jsのアプリをビルドする。Approveステージで承認を行えば、ビルドして生成された静的ファイルがCodePipelineを通してS3にデプロイされる。

### SAM用パイプライン
CodeBuildでSAMテンプレートのビルド、パッケージ化を行う。パッケージ化されたSAMテンプレートをもとに、CloudFormationのChangeSetを作成する。Approveステージで承認を行えば、ChangeSetが実行されてSAM関連のリソースがデプロイされる。

### Terraform用パイプラン
以下アーキテクチャ図で構成する。Terraformで管理されているAWSリソースに関しても、CI/CDパイプランで反映を行う。Terraform用のパイプラインは、infrastructure/cloudformation/terraform-environment/terraform-environment.yamlのCloudFormationスタックから作成される。
まずtfsecでリソースの脆弱性をチェックする。脆弱性に問題なければCodeBuildでterraform planが実行され、Approveステージで承認を行えばterraform applyが実行される。

![terraform_pipeline](https://user-images.githubusercontent.com/63912049/208441531-8df30ede-4c09-4a93-857f-f02a22f4c35e.png)

