//Snowflakeでまずはストレージ統合を作成

/*
ストレージ統合とは、Snowflake と外部ストレージ（この場合は AWS S3）との認証情報やアクセス権を一元管理する仕組み。
*/

create STORAGE INTEGRATION s3_int_s3_access_logs
  TYPE = EXTERNAL_STAGE --外部ステージ用（外部ストレージとの接続）であることを指定。
  STORAGE_PROVIDER = S3 
  ENABLED = TRUE -- 統合を 有効化（active）
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<AWS_ACCOUNT_NUMBER>:role/<RoleName>' --「Snowflake が使える IAM ロール」を作っておき、そのロールの「ARN（Amazon Resource Name）」を Snowflake に教える
  STORAGE_ALLOED_LOCATIONS = ('s3://<BUCKET_NAME>/<PREFIX>/'); --S3 バケットのパス（場所） を指定するパラメータ



DESC INTEGRATION s3_int_s3_access_logs;
-- STORAGE_AWS_IAM_USER_ARN
-- STORAGE_AWS_EXTERNAL_IDをメモ
  //（補足）そもそも「ARN」って何？
  -- ARN（Amazon Resource Name） は AWS 内のリソース（ユーザー、ロール、バケットなど）を一意に識別するための名前。

-- IAMロールのARNの例：
-- arn:aws:iam::123456789012:role/SnowflakeS3AccessRole



/*
SnowflakeS3AccessRoleというIAMロール(信頼ポリシー・アクセス許可ポリシーの２つ)の設定例
*/
/* IAMロールの「信頼ポリシー（Trust Policy）」の例*/
-- Snowflake がロールを引き受けられるように設定する。
/*
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<SNOWFLAKE_ACCOUNT_ID>:root" --Snowflakeの指定アカウントにのみAssumeRoleを許可する
      },
      "Action": "sts:AssumeRole",　-- 一時的に引き受けて（AssumeRole）AWSリソースにアクセスできるようにする設定
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<SnowflakeExternalId>" --外部ID（ExternalId）が一致する場合にのみ許可
        }
      }
    }
  ]
}

*/

/*
「IAMロールの「アクセス許可ポリシー（Permissions Policy）」の例」
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowS3ReadAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::<BUCKET_NAME>",
        "arn:aws:s3:::<BUCKET_NAME>/<PREFIX>/*"
      ]
    }
  ]
}

*/


