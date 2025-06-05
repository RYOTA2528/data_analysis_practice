import boto3
from boto3.dynamodb.conditions import Key, Attr

print('Loading function')  # Lambda の初期実行時に出力されるログ

# DynamoDBと接続（resourceで高レベルAPIを使用）
dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
    # 操作対象の DynamoDB テーブル名を指定
    table_name = "testdb"

    # イベントから 'id' を取得（API GatewayやSQSから渡ってくる想定）
    # 安全性を高めるために get() を使用し、存在しない場合は early return
    id_value = event.get("id")
    if not id_value:
        return {
            "statusCode": 400,
            "body": "Error: 'id' is required in the event input."
        }

    # パーティションキーを指定して検索用キーを構成
    partition_key = {"id": id_value}

    # DynamoDB テーブルオブジェクトを取得
    dynamotable = dynamodb.Table(table_name)

    # get_item を使って、指定されたキーのアイテムを取得
    try:
        response = dynamotable.get_item(Key=partition_key)
        item = response.get("Item")
        
        # 該当アイテムが存在しない場合の処理
        if not item:
            return {
                "statusCode": 404,
                "body": f"Item with id '{id_value}' not found."
            }

        # 正常にアイテムを取得した場合は返却
        return {
            "statusCode": 200,
            "body": item
        }

    except Exception as e:
        # エラー発生時のログとエラーレスポンス
        print(f"Error getting item: {e}")
        return {
            "statusCode": 500,
            "body": f"Internal server error: {str(e)}"
        }

