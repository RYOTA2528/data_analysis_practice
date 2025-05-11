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

