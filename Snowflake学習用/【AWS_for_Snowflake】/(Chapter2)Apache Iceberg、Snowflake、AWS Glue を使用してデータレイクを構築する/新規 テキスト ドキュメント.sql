/* ---------------------------------------------------------------------------
まず、SQL を実行するためのコンテキスト（ロール、データベース、ウェアハウス）を設定します。
----------------------------------------------------------------------------*/

USE ROLE HOL_ICE_RL;

USE HOL_ICE_DB.PUBLIC;

USE WAREHOUSE HOL_ICE_WH;


/* ---------------------------------------------------------------------------
外部ボリュームと Glue カタログ統合の設定  
----------------------------------------------------------------------------*/

CREATE OR REPLACE EXTERNAL VOLUME HOL_ICE_EXT_VOL
   STORAGE_LOCATIONS =
      (
         (
            NAME = 'my-s3-ice-ext-vol',
            STORAGE_PROVIDER = 'S3',
            STORAGE_BASE_URL = 's3://<あなたの S3 バケット名>/iceberg/',
            STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<あなたの AWS アカウント ID>:role/<作成したロール名>'
         )
      );

// AWSアカウントロールとの信頼関係を設定
-- 外部ボリュームの定義を確認
DESC EXTERNAL VOLUME HOL_ICE_EXT_VOL;


STORAGE_LOCATIONS出力行には、 次のようなJSON形式のプロパティ値が入ります。

{"NAME":"my-s3-ice-ext-vol",
"STORAGE_PROVIDER":"S3",
"STORAGE_BASE_URL":"s3://glue-snowflake-devday-lab-6546xxxxxxxx/iceberg/",
"STORAGE_ALLOWED_LOCATIONS":["s3://glue-snowflake-lab-6546xxxxxxxx/iceberg/*"],
"STORAGE_AWS_ROLE_ARN":"arn:aws:iam::65465xxxxxxx:role/glue-snowflake-GluesnowflakedevdayLabRole-crOqCT36mDB4",
"STORAGE_AWS_IAM_USER_ARN":"arn:aws:iam::90541xxxxxxxxxx:user/vvyk0000-s",
"STORAGE_AWS_EXTERNAL_ID":"YJB50193_SFCRole=2_f1IsD5b8/DAFxxxxxxxxxxxx",
"ENCRYPTION_TYPE":"NONE",
"ENCRYPTION_KMS_KEY_ID":""}

/*
  - 作成済みの S3 バケット名を STORAGE_BASE_URL に入力
  - AWS アカウント ID を STORAGE_AWS_ROLE_ARN に入力
  - 作成した IAM ロールの ARN を STORAGE_AWS_ROLE_ARN に入力
-------------------------------------------------------------------------*/

-- ※ Snowflake の IAM ユーザー ARN と External ID を使って、AWS IAM ロールの信頼ポリシーを更新してください
/*【以下手順で実施】*/
「信頼関係」タブをクリックし
AWS IAMにて「信頼ポリシーの編集」をクリックします。先ほどSnowflake上で確認した値を以下の<>に適宜入れながら編集
↓
※この時点では①②までの入力※
/*
{
  "Version": "2012-10-17",
  "Statement": [

    // ① Glue サービス（AWS Glue）がこのロールを引き受け可能にする設定
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },

    // ② Snowflake のストレージ統合用 IAM ユーザーが AssumeRole 可能にする設定
    // Snowflake 側で EXTERNAL VOLUME を作成するために使用される
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "<snowflake storage arn>"  // Snowflake が提供する IAM ユーザー ARN（ストレージ統合用）
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<snowflake external id ext volume>"  // Snowflake 側が指定する External ID（セキュリティ対策）
        }
      }
    },

    // ③ Snowflake の Glue カタログ統合用 IAM ユーザーが AssumeRole 可能にする設定
    // Snowflake から AWS Glue にある Iceberg テーブル情報へアクセスするために使用される
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "<snowflake glue arn>"  // Snowflake が提供する IAM ユーザー ARN（Glue カタログ統合用）
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<snowflake external id glue catalog>"  // Snowflake 側が指定する External ID（Glue 統合用）
        }
      }
    }

  ]
}
*/


-- Glue カタログ設定
-- AWS 側で Glue カタログ用のポリシーと IAM ロールを作成してください

/* ※ このセクションにはご自身の情報を入力してください：
   - AWS アカウント ID を GLUE_AWS_ROLE_ARN に入力
   - 作成した IAM ロールの ARN を STORAGE_AWS_ROLE_ARN に入力
   - AWS Glue カタログ ID を GLUE_CATALOG_ID に入力
-------------------------------------------------------------------------*/

CREATE or REPLACE CATALOG INTEGRATION HOL_ICE_GLUE_CAT_INT
  CATALOG_SOURCE = GLUE,
  CATALOG_NAMESPACE = 'iceberg', -- Glueの中でSnowflakeが参照する**データベース名（Namespace）**です
  TABLE_FORMAT = ICEBERG, -- テーブル形式が Apache Iceberg であることを示します。SnowflakeはIceberg形式のテーブルをネイティブにサポートしており、この指定で正しく解釈できます。
  GLUE_AWS_ROLE_ARN = 'arn:aws:iam::<あなたの AWS アカウント ID>:role/<作成したロール名>',
  GLUE_CATALOG_ID = '<あなたの AWS アカウント ID>',
  ENABLED = TRUE;
  
-- ※これでSnowflake内からこのカタログインテグレーションを利用して、
--   Glue上のIcebergテーブルに対してクエリを実行したり、仮想データベースとして参照できるようになります。

-- Glue カタログ統合の確認
DESC CATALOG INTEGRATION HOL_ICE_GLUE_CAT_INT;

-- ※ Snowflake IAM ユーザー ARN と External ID を使って、IAM ロールの信頼ポリシーを更新する必要があります

※信頼ポリシーの③④の中身の修正


/* ---------------------------------------------------------------------------
Glue カタログ統合を使って、管理されていない Iceberg テーブルを作成します。
----------------------------------------------------------------------------*/

CREATE OR REPLACE ICEBERG TABLE QUOTES_ICE
  EXTERNAL_VOLUME = 'HOL_ICE_EXT_VOL',
  CATALOG = 'HOL_ICE_GLUE_CAT_INT',
  CATALOG_TABLE_NAME = 'QUOTES';

-- Iceberg テーブルから10件データを確認
SELECT * FROM QUOTES_ICE LIMIT 10;


/*---------------------------------------------------------------------------
内部の Snowflake テーブル（CUSTOMER, POLICIES）と Iceberg テーブル（QUOTES_ICE）を
結合して分析できるようになります。
-----------------------------------------------------------------------------*/

-- 見積もりが5件を超える顧客を見積もり情報と結合する

SELECT C.FULLNAME, C.POSTCODE, C.CUSTID, C.IPID, C.PRODUCTNAME, C.QUOTECOUNT,
       Q.POLICYNO, Q.QUOTEDATE, Q.QUOTE_PRODUCT, Q.ORIGINALPREMIUM, Q.TOTALPREMIUMPAYABLE 
FROM CUSTOMER C, QUOTES_ICE Q
WHERE C.FULLNAME = Q.FULLNAME
  AND C.POSTCODE = Q.POSTCODE
  AND C.QUOTECOUNT > 5
ORDER BY C.QUOTECOUNT DESC;


-- 見積もりと顧客情報に加えて、ポリシーデータも結合することで、
-- 顧客がどんなポリシーをどんな見積もりで取得しているのかをより詳細に分析できます。

WITH CUSTQUOTE AS (
  SELECT C.FULLNAME, C.POSTCODE, C.CUSTID, C.IPID, C.PRODUCTNAME, C.QUOTECOUNT,
         Q.POLICYNO, Q.QUOTEDATE, Q.QUOTE_PRODUCT, Q.ORIGINALPREMIUM, Q.TOTALPREMIUMPAYABLE 
  FROM CUSTOMER C, QUOTES_ICE Q
  WHERE C.FULLNAME = Q.FULLNAME
    AND C.POSTCODE = Q.POSTCODE
    AND C.QUOTECOUNT > 5
)
SELECT CQ.FULLNAME, CQ.POSTCODE, CQ.CUSTID, CQ.IPID, CQ.PRODUCTNAME,
       CQ.QUOTECOUNT, CQ.POLICYNO, CQ.QUOTEDATE, CQ.QUOTE_PRODUCT,
       CQ.ORIGINALPREMIUM, CQ.TOTALPREMIUMPAYABLE, 
       P.CREATEDDATE, P.BRAND, P.BRANCHCODE, P.POLICY_STATUS_DESC,
       P.TYPEOFCOVER_DESC, P.INSURER_NAME, P.INCEPTIONDATE, P.RENEWALDATE
FROM CUSTQUOTE CQ, POLICIES P
WHERE CQ.CUSTID = P.CUSTID;


/*
Snowflake, Glue、または Iceberg をサポートする他のエンジンからも使用可能な、
管理された Iceberg テーブルを作成します（S3に保存される）。
*/

CREATE OR REPLACE ICEBERG TABLE QUOTE_ANALYSIS_ICE  
  CATALOG = 'SNOWFLAKE',
  EXTERNAL_VOLUME = 'HOL_ICE_EXT_VOL',
  BASE_LOCATION = 'quoteanalysisiceberg'
AS 
WITH CUSTQUOTE AS (
  SELECT C.FULLNAME, C.POSTCODE, C.CUSTID, C.IPID, C.PRODUCTNAME, C.QUOTECOUNT,
         Q.POLICYNO, Q.QUOTEDATE, Q.QUOTE_PRODUCT, Q.ORIGINALPREMIUM, Q.TOTALPREMIUMPAYABLE 
  FROM CUSTOMER C, QUOTES_ICE Q
  WHERE C.FULLNAME = Q.FULLNAME
    AND C.POSTCODE = Q.POSTCODE
    AND C.QUOTECOUNT > 5
)
SELECT CQ.FULLNAME, CQ.POSTCODE, CQ.CUSTID, CQ.IPID, CQ.PRODUCTNAME,
       CQ.QUOTECOUNT, CQ.POLICYNO, CQ.QUOTEDATE, CQ.QUOTE_PRODUCT,
       CQ.ORIGINALPREMIUM, CQ.TOTALPREMIUMPAYABLE, 
       P.CREATEDDATE, P.BRAND, P.BRANCHCODE, P.POLICY_STATUS_DESC,
       P.TYPEOFCOVER_DESC, P.INSURER_NAME, P.INCEPTIONDATE, P.RENEWALDATE
FROM CUSTQUOTE CQ, POLICIES P
WHERE CQ.CUSTID = P.CUSTID;


-- Snowflake 上で Iceberg テーブルを使って分析
SELECT DISTINCT CUSTID, FULLNAME, POSTCODE, IPID, PRODUCTNAME, QUOTECOUNT,
       POLICYNO, QUOTEDATE, QUOTE_PRODUCT, ORIGINALPREMIUM, TOTALPREMIUMPAYABLE,
       CREATEDDATE, BRAND, BRANCHCODE, POLICY_STATUS_DESC, TYPEOFCOVER_DESC,
       INSURER_NAME, INCEPTIONDATE, RENEWALDATE
FROM QUOTE_ANALYSIS_ICE
WHERE TOTALPREMIUMPAYABLE > 100
  AND POLICY_STATUS_DESC = 'Renewed'
ORDER BY CREATEDDATE DESC;