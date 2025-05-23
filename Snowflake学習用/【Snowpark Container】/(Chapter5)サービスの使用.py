# 1  Snowpark Container Servicesのエンドポイントのステータスをチェックする
import json, time
while True:
    public_endpoints = nginx_service.fetch().public_endpoints ## 最新のエンドポイント情報を取得
    try:
        endpoints = json.loads(public_endpoints) ## JSON形式に変換できるか確認
    except json.JSONDecodeError:
        print(public_endpoints)
        time.sleep(15) # 15秒待ってから再試行
    else:
        break  JSONに正しく変換できた＝エンドポイントの準備完了 → ループ終了

# 出力結果は以下
# Endpoints provisioning in progress... check back in a few minutes
# Endpoints provisioning in progress... check back in a few minutes
# Endpoints provisioning in progress... check back in a few minutes

# 2 エンドポイントのプロビジョニングが完了したら、ブラウザーでパブリック・エンドポイントを開く
import webbrowser

print(f"Visiting {endpoints['ui']} in your browser. You might need to log in there.")
webbrowser.open(f"https://{endpoints['ui']}")

# このURLを開くと、SnowflakeがホストしているNginx Webサービスにアクセスでき、HTMLの画面などが表示されるはずです

# 3 サービスを一時停止してからその状態を確認する
from time import sleep

nginx_service.suspend()
sleep(3)
print(nginx_service.get_service_status(timeout=5))

# 4 サービスを再開する
nginx_service.resume()
sleep(3)
print(nginx_service.get_service_status(timeout=5))

# コンピューティングプールとサービスを中断する
new_compute_pool_def.suspend()
nginx_service.suspend()

# コンピューティングプールとサービスを削除する
new_compute_pool_def.drop()
nginx_service.drop()