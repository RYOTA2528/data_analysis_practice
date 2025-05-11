# 1 イメージリポジトリを取得
image_repository = schema.image_repositories["MyImageRepository"]

# 2 サービスの仕様を定義
# `dedent()` を使って複数行の文字列からインデントを除去し、整ったYAMLとして扱えるようにしている
# f-string を使って、image に動的にリポジトリURLを挿入する
specification = dedent(f"""\ 
    spec:  # サービス全体の仕様ブロックの開始
      containers:  # 実行するコンテナのリスト（1つ以上定義可能）
      - name: web-server  # このコンテナの名前（任意名、識別に使用）
        image: {image_repository.fetch().repository_url}/amd64/nginx:latest  
        # 使用するコンテナイメージのパス（Snowflakeのイメージリポジトリから取得）
        # {image_repository.fetch().repository_url} で、イメージのベースURLを動的に取得
        # `/amd64/nginx:latest` は、イメージのパスとタグ（latestバージョン）

      endpoints:  # サービスが公開するネットワークエンドポイントのリスト
      - name: ui  # エンドポイント名（任意名）
        port: 80  # このサービスがリッスンするポート番号（ここ
        public: true # 外部からのアクセスを許可（true にするとインターネット経由でアクセス可能）
    """)

# この仕様に基づき、サービスはNginx WebサーバーをSnowflake上で起動し、ポート80経由で外部アクセスを受け付けるようになります。


# Snowflake上で実行するサービスを定義
service_def = Service(
    name="MyService",  # サービスの名前。後で識別するために使う（任意の名前でOK）
    compute_pool="MyComputePool",  # 使用するコンピューティングプール名。事前に作成しておく必要がある
    spec=ServiceSpecInlineText(specification),  
    # サービス仕様（YAMLで記述）をインラインで渡す。
    # 'ServiceSpecInlineText' は仕様がPythonコード内の文字列で定義されていることを示す
    min_instances=1,  # 起動するインスタンスの最小数（ここでは常に1インスタンスを維持）
    max_instances=1,  # 起動可能なインスタンスの最大数（スケーラブルにする場合は増やせる）
)

# 上で定義したサービスをSnowflakeのスキーマにデプロイ（作成）する
nginx_service = schema.services.create(service_def)

# このコードにより、Nginxコンテナが MyComputePool 上で起動し、サービス名 MyService で管理されます。


# 3 サービスの状態をチェックする
from pprint import pprint

pprint(nginx_service.get_service_status(timeout=5))
# 以下出力なる
{'auto_resume': True,
'auto_suspend_secs': 3600,
'instance_family': 'CPU_X64_XS',
'max_nodes': 1,
'min_nodes': 1,
'name': 'MyService'}