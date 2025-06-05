def lambda_handler(event, context):
    import boto3, json  # boto3: AWS SDK（SNS操作）、json: 辞書→JSON文字列変換

    sns = boto3.client('sns')  # SNS クライアントを作成（AWSアカウント上のSNSと連携）

    sns.publish(
        TopicArn='arn:aws:sns:ap-northeast-1:123456789012:glue-job-notify',  # 通知を送る対象のSNSトピックARN
        Message=json.dumps({  # メッセージ本体をJSON形式に変換して送信（SNSは文字列しか受け取れない）
            "table": event["table"],         # 処理対象のテーブル名（例: "orders"）
            "s3_path": event["s3_path"],     # S3出力先のパス（例: "s3://my-bucket/staging/orders/..."）
            "job_run_id": event["job_run_id"]  # Glueジョブの実行ID（追跡用）
        })
    )

    return {"statusCode": 200, "body": "SNS通知送信完了"}  # 正常終了レスポンス（API Gatewayなどと連携可）
