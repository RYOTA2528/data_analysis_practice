# SNS 通知コードを PySpark スクリプトの最後に追加
# PySpark 処理（前半部分）で、データ読み込み・加工・S3への書き出しなどを実行済みとする

# ===== SNS 通知の準備と送信 =====

import boto3  # AWS サービスと連携するための SDK（SNS 用）
import json   # 辞書を JSON 文字列に変換するための標準ライブラリ
import sys    # Glue ジョブ実行時の引数（sys.argv）を取得するために使用

# Glue ジョブの引数から job_run_id を取得（Step Functions から渡される想定）
args = sys.argv
job_run_id = args[1] if len(args) > 1 else "unknown"  # 引数がない場合は 'unknown' を代入

# SNS クライアントを作成
sns = boto3.client('sns')

# SNS トピックに JSON 形式のメッセージを送信
sns.publish(
    TopicArn='arn:aws:sns:ap-northeast-1:123456789012:glue-job-notify',  # 通知先SNSトピックのARN
    Message=json.dumps({  # メッセージ本体をJSON文字列に変換して送信
        "table": "orders",  # 処理対象のテーブル名
        "s3_path": "s3://my-bucket/staging/orders/2025-06-05/",  # 出力先のS3パス
        "job_run_id": job_run_id  # 実行中のジョブID（GlueやStep Functions連携用）
    })
)