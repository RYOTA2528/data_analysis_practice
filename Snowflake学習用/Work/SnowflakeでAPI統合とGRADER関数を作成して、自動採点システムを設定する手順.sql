/*
【SnowflakeでAPI統合とGRADER関数を作成して、自動採点システムを設定する手順】

*/


/*
1. API統合を作成する
最初に行うのは、API統合の作成です。
このSQL文は、AWS API Gatewayを介してSnowflakeと外部API（edu_dora）
との接続を設定するためのものです。設定されたAPI統合を有効にし、
指定されたIAMロールを使用して、
指定されたAPIエンドポイントにアクセスすることができるようになります。
これにより、Snowflakeから外部APIに対してリクエストを送信したり、
外部APIからのレスポンスをSnowflakeで処理したりすることが可能になります。

(以下command解説)
API INTEGRATION: SnowflakeにAPI統合を作成するためのSQLステートメントです。
これにより、Snowflakeが外部APIと通信するための設定を行います。

api_provider: AWS API Gateway を指定。

api_aws_role_arn: SnowflakeがAPIと通信するためのAWS IAMロールARN。

enabled: この統合が有効かどうか（TRUEに設定）。

api_allowed_prefixes: Snowflakeからアクセス可能なAPIのURLプレフィックス。
*/

-- ACCOUNTADMIN ロールを使用
USE ROLE accountadmin;

-- API 統合の作成
CREATE OR REPLACE API INTEGRATION dora_api_integration
  API_PROVIDER = 'aws_api_gateway'
  API_AWS_ROLE_ARN = 'arn:aws:iam::321463406630:role/snowflakeLearnerAssumedRole'
  ENABLED = TRUE
  API_ALLOWED_PREFIXES = ('https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora');

