//ガイド説明
Apache Iceberg を中心に、AWS Glue および Snowflake を連携させたオープンな分析基盤の構築方法を解説します。特に、既存の Parquet データを Iceberg 形式へ変換 し、その後 Snowflake からもクエリ可能にするまでのプロセスを段階的に実装します。


//Apache Iceberg とは？
Apache Iceberg（アパッチ・アイスバーグ）とは、大規模データ分析のためのオープンなテーブル形式で、Hadoopやクラウドデータレイク上でACIDトランザクションを可能にする次世代のストレージフォーマット
特徴	内容
オープンテーブル形式	Hive、Parquetの制約を超えた、モダンなテーブル管理方式。
ACID準拠	複数ユーザー/プロセスの並列書き込み、更新、削除が衝突せず安全に行える。
スキーマ進化が容易	スキーマ変更（列の追加・削除・リネームなど）を安全に実行可能。
パーティションの自動管理	手動でディレクトリを分ける必要がなく、クエリで最適にアクセス可能。
高パフォーマンス	メタデータが効率的に管理されており、スナップショットベースのクエリが高速。
マルチエンジン対応	Spark、Flink、Trino、Presto、Hive、Dremio、Snowflake、Athenaなどと連携可。



//Iceberg の基本構成
Iceberg テーブルは、以下のような構成で管理されます：

データファイル（例：Parquet）

マニフェストファイル（データファイルのリスト）

スナップショットファイル（テーブル状態の時点コピー）

メタデータファイル（スキーマ、パーティション情報など）

これにより、バージョニング、タイムトラベル、インクリメンタル読み取りなどが実現


(ステップバイステップ解説)

①Parquetファイル配置先:
s3://my-insurance-data/quotes/


②Glue データベース作成:
aws glue create-database --database-input'{"Name":"insurance_db"}'


③Iceberg テーブル作成（Glue経由）:
AWS Glue StudioやPySparkを使用し、Parquetを読み込みつつIcebergテーブルへ変換。

--------------------------------------------------
import sys # 標準ライブラリのsysモジュールをインポート
from pyspark.context import SparkContext # SparkContext を作成（Sparkアプリケーションのエントリポイント）
from awsglue.context import GlueContext # AWS Glue の GlueContext を作成（Spark を AWS Glue 向けに拡張）
from awsglue.dynamicframe import DynamicFrame #DynamicFrame クラスを使うためのインポート

sc= SparckContext()

glueContext = GlueContext(sc) #GlueContext（Glue向けのSparkラッパー）を初期化

spark = glueContext.spark_session #SparkSessionを取得

df = spark.read.parquet("s3://my-insurance-data/quotes/") #S3上のParquetファイルをSpark DataFrameとして読み込み

#Icebergフォーマット書き出し
df.write.format("iceberg") \
	.mode("overwrite") \ #既存テーブルがあれば上書き
	.option("catalog", "glue_catalog") \ #使用する Iceberg カタログに Glue Catalog を指定
	.option("catalog-locaton", "s3://my-insurance-data/iceberg") \  # Iceberg テーブルのメタデータ保存場所
	.save("insurance_db.quotes_iceberg") # Glue Catalog 上で insurance_db データベース内の quotes_iceberg テーブルに保存

--------------------------------------------------


④Snowflakeストレージ統合、外部ボリュームの作成
-- S3にアクセスするためのストレージ統合オブジェクトを作成
CREATE OR REPLACE STORAGE INTEGRATION my_s3_int
  TYPE = EXTERNAL_STAGE --外部ステージ用のストレージ統合（S3などの外部ストレージ向け）
  STORAGE_PROVIDER = S3
  ENABLED = TRUE --この統合を有効
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/SnowflakeS3Access' --aws s3 ls s3://my-bucketでarn確認可能
  -- ↑SnowflakeからS3にアクセスするためのIAMロールのARNを指定
  STORAGE_ALLOWED_LOCATIONS = ('s3://my-insurance-data/iceberg/');
  -- アクセスを許可する S3 のパス（Iceberg テーブルが保存されている場所）
  
  
-- 外部ボリューム（External Volume）を作成し、Snowflake から S3 をマウント
CREATE EXTERNAL VOLUME my_iceberg_vol
  STORAGE_INTEGRATION = my_s3_int
  --↑先ほど作成したストレージ統合オブジェクトを使用
  URL = 's3://my-insurance-data/iceberg/'; ---- Iceberg テーブルのメタデータおよびデータファイルが格納されている S3 のパスを指定



---------------------------------------------------------------
この設定を行うことで、Snowflake から次のような操作が可能になります：

Glue Data Catalog にある Iceberg テーブルを 外部カタログ経由で参照

Iceberg テーブルを 非管理テーブル（external）としてクエリ

S3 上の Iceberg テーブルを Snowflake 管理の Iceberg テーブルに変換
 
 
⑤外部カタログを作成（Glue Catalog を参照）
CREATE OR REPLACE EXTERNAL CATALOG glue_cat
  TYPE = GLUE
  GLUE_CATALOG = 'aws'
  GLUE_REGION = 'us-west-2'
  STORAGE_INTEGRATION = my_s3_int;
  
-- これにより、Snowflake から以下のように直接 Glue Catalog 上の Iceberg テーブルにクエリを投げられるようになります：
SELECT
*
FROM glue_cat.insurance_db.quotes_iceberg;



