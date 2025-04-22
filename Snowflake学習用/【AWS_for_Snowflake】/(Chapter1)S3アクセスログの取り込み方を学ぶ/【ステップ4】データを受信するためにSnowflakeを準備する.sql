// データを受信するためにSnowflakeを準備する

-- 1分間操作がないと停止する中規模の単一クラスターウェアハウスを作成
create warehouse security_quickstart with 
  WAREHOUSE_SIZE = MEDIUM 
  AUTO_SUSPEND = 60;
  
  
-- 解析されていないログをインポートするためのファイル形式を作成
CREATE FILE FORMAT IF NOT EXISTS TEXT_FORMAT
TYPE = 'CSV'
FIELD_DELIMITER = NONE --区切り文字を使わない（','が多い）
SKIP_BLANK_LINES = TRUE --空行はスキップする
ESCAPE_UNENCLOSED_FIELD = NONE; --囲まれていないフィールド内のエスケープ文字を無効にする


-- ストレージ統合を使用し外部ステージを作成
create stage s3_access_logs
  url = 's3://<BUCKET_NAME>/<PREFIX>/' --STORAGE INTEGRATION で許可した STORAGE_ALLOWED_LOCATIONS と一致している必要があります。ズレてるとエラーになります
  storage_integration = s3_int_s3_access_logs --以前 CREATE STORAGE INTEGRATION で作成した統合名を指定。これで IAM ロールとの接続を使用
;

-- 外部ステージの中身を確認
LIST @s3_access_logs;


-- (おまけ)データを書き出し（Snowflake → S3）方法
COPY INTO @s3_access_logs/my_output.csv
FROM my_table
FILE_FORMAT = (TYPE = CSV);


-- 生のログを保存するテーブルを作成
create or replace table s3_access_logs_staging(
  raw TEXT,
  timestamp DATETIME
);

