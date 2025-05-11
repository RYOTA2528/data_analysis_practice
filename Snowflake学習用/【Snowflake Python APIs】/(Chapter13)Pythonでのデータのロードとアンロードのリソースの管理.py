# Pythonでのデータのロードとアンロードのリソースの管理

# 1 Snowflakeへの接続を作成
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

# 2 クラウドストレージ内のデータファイルの場所であるSnowflakeステージで管理
# ステージの作成
from snowflake.core.stage import Stage, StageEncryption

my_stage = Stage(
    name="my_stage",
    encryption=StageEncryption(type="SNOWFLAKE_SSE")
)
stages = root.database["my_db"].schemas["my_schema"].stages
stages.create(my_stage)

# ステージ詳細の取得
my_stage = root.database["my_db"].schemas["my_schema"].stages["my_stage"].fetch()
print(my_stage.to_dict())

# ステージの一覧表示(名前に my というテキストを含むステージを一覧表示)
from snowflake.core.stage import StageCollection

stages: StageCollection = root.database["my_db"].schemas["my_schema"].stages
stage_iter = stages.iter(like="my%")
for stage_obj in stage_iter:
  print(stage_obj.name)


# ステージの操作
# Snowflake内のステージリソースにアクセス
# データベース: my_db, スキーマ: my_schema, ステージ: my_stage
my_stage_res = root.databases["my_db"].schemas["my_schema"].stages["my_stage"]

# ローカルファイル './my-file.yaml' をステージにアップロード
# "/" はステージ内のルートディレクトリを示す
# auto_compress=False により自動圧縮なし
# overwrite=True により同名ファイルがあれば上書き
my_stage_res.put("./my-file.yaml", "/", auto_compress=False, overwrite=True)

# ステージ内にあるファイルの一覧を取得
stageFiles = root.databases["my_db"].schemas["my_schema"].stages["my_stage"].list_files()

# アップロードされたファイル（およびその他のファイル）を表示
for stageFile in stageFiles:
    print(stageFile)  # 例: 'my-file.yaml'

# ステージ自体を削除（中のファイルも含めてすべて消えるので注意！）
my_stage_res.drop()

