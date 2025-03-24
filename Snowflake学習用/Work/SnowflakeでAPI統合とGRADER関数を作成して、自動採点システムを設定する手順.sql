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




/*
2. GRADER関数を作成する
このSQLコードは、GRADER関数を作成するためのものです。GRADER関数は、
Snowflake内で自動採点を行うために外部APIにリクエストを送信する役割

(以下command解説)
CREATE OR REPLACE EXTERNAL FUNCTION:
EXTERNAL FUNCTION: Snowflakeでは、
外部APIと連携するための関数を作成することができます。
このEXTERNAL FUNCTIONを使うことで、Snowflake内から外部のサービス
（この場合、AWS API Gatewayを通じて提供されるAPI）にアクセスすることができます。

関数の引数:
step VARCHAR: 処理のステップを示す文字列型の引数。

actual BOOLEAN: 実際の結果（真偽値）を示す引数。

actual_int INT: 実際の数値（整数型）を示す引数。

expected_int INT: 期待される結果の数値（整数型）を示す引数。

description VARCHAR: 説明を示す文字列型の引数。

RETURNS VARIANT:
この関数はVARIANT型のデータを返します。
VARIANTはSnowflakeで使われる柔軟なデータ型で、JSONやその他のデータ形式を格納できます。
外部APIから返されるレスポンスは様々な形式を取る可能性があるため、
VARIANT型で受け取ります

API_INTEGRATION = dora_api_integration:
API_INTEGRATIONで、先ほど作成したAPI統合（dora_api_integration）を指定しています。
これにより、Snowflakeが外部APIにアクセスする際の設定を指示します。

CONTEXT_HEADERS = (CURRENT_TIMESTAMP, CURRENT_ACCOUNT, CURRENT_STATEMENT, CURRENT_ACCOUNT_NAME):
CONTEXT_HEADERSでは、リクエストに関連する情報をヘッダーとして送信します。
ここでは、次の4つのコンテキスト情報を含めています：
CURRENT_TIMESTAMP: 現在のタイムスタンプ（リクエストを送信した日時）
CURRENT_ACCOUNT: 現在のアカウントID
CURRENT_STATEMENT: 現在実行中のSQLステートメント
CURRENT_ACCOUNT_NAME: 現在のアカウント名

URL = 'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/grader':
この部分では、リクエストを送信するAPIエンドポイントのURLを指定しています。
このURLは、AWS API Gatewayを介して提供されるAPIのエンドポイントで、
/dev/edu_dora/graderというパスが含まれています。
これにより、grader関数はこのURLに対してHTTPリクエストを送信し、
外部APIの結果を受け取ります。
*/

-- ACCOUNTADMIN ロールを使用
USE ROLE accountadmin;

-- GRADER 関数の作成
CREATE OR REPLACE EXTERNAL FUNCTION util_db.public.grader(
      step VARCHAR
    , passed boolean
    , actual integer
    , expected integer
    , description varchar)
  RETURNS VARIANT
  API_INTEGRATION = dora_api_integration
  CONTEXT_HEADERS = (CURRENT_TIMESTAMP, CURRENT_ACCOUNT, CURRENT_STATEMENT, CURRENT_ACCOUNT_NAME)
  URL = 'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/grader';


-- GRADER関数を使用して、動作確認を行う
SELECT 
    grader(step, 
           (actual = expected), 
           actual, 
           expected, 
           description) AS graded_results 
FROM
(
  -- テストデータを選択し、GRADER関数に渡す
  SELECT 
    'DORA_IS_WORKING' AS step,       -- ステップ名（テスト用の名前）
    (SELECT 123) AS actual,          -- 実際の結果（ここでは単に数字123を返す）
    123 AS expected,                 -- 期待される結果（同じく123）
    'Dora is working!' AS description -- 説明（動作確認のメッセージ）
);



-- 元のスキーマで作業していた場合は以下でリネームすること
ALTER FUNCTION GARDEN_PLANTS.VEGGIE.GRADER RENAME TO UTIL_DB.PUBLIC.GRADER 