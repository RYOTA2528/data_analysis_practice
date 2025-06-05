import pandas as pd            # データをDataFrameとして扱うためにpandasを使用
import boto3                   # AWSのS3およびSNS操作のためにboto3を使用
import os                      # 環境変数の取得やパス構築に使用
import sys                     # エラーメッセージの出力に使用
import json                    # SNS通知用に辞書をJSON文字列へ変換するために使用
from datetime import datetime  # 処理実行時のタイムスタンプ生成に使用
from sqlalchemy import create_engine  # PostgreSQLなどのRDBに接続するためのSQLAlchemyを使用

# =============================================
# 環境変数から接続情報や出力設定を取得（設定されていない場合はデフォルト値を使用）
# 本番環境では export DB_URL=... のように環境変数を設定して使う
# =============================================
DB_URL = os.getenv("DB_URL", "postgresql://user:password@host:5432/dbname")  # DB接続URL
S3_BUCKET = os.getenv("S3_BUCKET", "my-bucket")                               # アップロード先S3バケット
S3_PREFIX = os.getenv("S3_PREFIX", "exports")                                 # S3のプレフィックスパス
DB_NAME = os.getenv("DB_NAME", "sales_db")                                    # 論理DB名（S3パス構成に使用）
SCHEMA = os.getenv("SCHEMA", "public")                                        # スキーマ名（同上）
EXECUTION_NAME = os.getenv("EXECUTION_NAME", f"run_{datetime.now().strftime('%Y%m%d_%H%M%S')}")  # 実行名（出力ディレクトリ用）
SNS_TOPIC_ARN = os.getenv("SNS_TOPIC_ARN")                                    # 通知送信用SNSトピックARN（任意）

TABLES = ["orders", "customers"]  # 処理対象のテーブル名一覧

# =============================================
# 指定したSQLクエリをDBに投げてデータを取得し、pandasのDataFrameで返す
# =============================================
def fetch_data_from_db(query: str) -> pd.DataFrame:
    engine = create_engine(DB_URL)
    with engine.connect() as conn:
        return pd.read_sql(query, conn)

# =============================================
# DataFrameをローカル（/tmp）にParquet形式で保存する（GlueやLambda実行環境でも使える）
# =============================================
def save_parquet_local(df: pd.DataFrame, local_path: str):
    df.to_parquet(local_path, index=False)
    print(f"[INFO] Saved to local parquet: {local_path}")

# =============================================
# ローカルに保存したParquetファイルをS3にアップロードする
# =============================================
def upload_to_s3(local_path: str, s3_path: str):
    s3 = boto3.client('s3')
    bucket = s3_path.replace("s3://", "").split("/")[0]        # バケット名だけ抽出
    key = "/".join(s3_path.replace("s3://", "").split("/")[1:])  # オブジェクトキーを構築
    s3.upload_file(local_path, bucket, key)
    print(f"[INFO] Uploaded to S3: {s3_path}")

# =============================================
# SNSトピックへ通知メッセージを送信（SNS_TOPIC_ARNが定義されていれば）
# =============================================
def send_sns_notification(table_name: str, s3_path: str):
    if not SNS_TOPIC_ARN:
        return  # ARNがなければ通知をスキップ
    sns = boto3.client('sns')
    message = {
        "table": table_name,
        "s3_path": s3_path,
        "execution": EXECUTION_NAME
    }
    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Message=json.dumps(message)
    )
    print(f"[INFO] SNS Notification sent: {table_name}")

# =============================================
# 指定されたテーブル名に対して以下の処理を実施：
# - データをDBから取得
# - Parquet形式で保存
# - S3へアップロード
# - SNS通知送信（任意）
# =============================================
def process_table(table_name: str):
    try:
        print(f"[START] Processing table: {table_name}")
        query = f"SELECT * FROM {table_name}"
        df = fetch_data_from_db(query)

        local_path = f"/tmp/{table_name}.parquet"  # GlueやLambdaのために/tmpを使用
        s3_path = f"s3://{S3_BUCKET}/{S3_PREFIX}/{DB_NAME}/{SCHEMA}/diff/{table_name}/execution_name={EXECUTION_NAME}/data.parquet"

        save_parquet_local(df, local_path)
        upload_to_s3(local_path, s3_path)
        send_sns_notification(table_name, s3_path)

        print(f"[DONE] {table_name} ")

    except Exception as e:
        print(f"[ERROR] Failed processing {table_name}: {e}", file=sys.stderr)

# =============================================
# メイン関数：すべてのテーブルを1つずつ処理
# =============================================
def main():
    for table in TABLES:
        process_table(table)

# =============================================
# このスクリプトが直接実行された場合のみ main() を呼ぶ
# モジュールとしてimportされた場合は実行されない
# =============================================
if __name__ == '__main__':
    main()
