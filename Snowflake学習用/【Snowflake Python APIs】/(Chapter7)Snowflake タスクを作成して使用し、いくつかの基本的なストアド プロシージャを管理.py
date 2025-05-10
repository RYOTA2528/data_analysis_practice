# Snowflake タスクを作成して使用し、いくつかの基本的なストアド プロシージャを管理

/*
(前提)
以下はChapter6までに完了済み
・開発環境を設定します。
・Snowflake Python APIs パッケージをインストールします。
・Snowflake接続を設定します。
・Python API チュートリアルに必要なすべてのモジュールをインポートします。
・API Root オブジェクトを作成します。
*/

# 1 PYTHON_API_DB という名前のデータベースと、そのデータベース内に PYTHON_API_SCHEMA という名前のスキーマを作成
database = root.database.create(
    Database(
        name="PYTHON_API_DB"),
        mode="CreateMode.or_replace"
    )

schema = database.schemas.cretae(
    Schema(
        name="PYTHON_API_SCHEMA"),
        mode=CreateMode.or_replace,
    )

#2 タスクが呼び出すストアドプロシージャと、ストアドプロシージャを保持するステージを設定

#  Snowflake Python APIs root オブジェクトを使って、以前に作成した PYTHON_API_DB データベースと PYTHON_API_SCHEMA スキーマにステージを作成
stages = root.database[database.name].schemas[schema.name].stages
stages.create(Stage(name="TASKS_STAGE"))

#3 タスクがストアドプロシージャとして実行する2つの基本的なPython関数を作成
dfrom snowflake.snowpark import Session
from snowflake.snowpark.functions import col

# 指定した件数だけ別テーブルにコピーする関数
def trunc(session: Session, from_table: str, to_table: str, count: int) -> str:
    (
        # from_table から count 件だけ取得し、
        # to_table という名前で新しいテーブルとして保存
        session.table(from_table).limit(count).write.save_as_table(to_table)
    )
    return "Truncated table successfully created!"  # 成功メッセージを返す

# L_SHIPMODE 列で指定されたモードに一致するデータを10件だけ抽出し、新しいテーブルを作成する関数
def filter_by_shipmode(session: Session, mode: str) -> str:
    (
        session
        # サンプルデータベースの lineitem テーブルを参照
        .table("snowflake_sample_data.tpch_sf100.lineitem")
        # L_SHIPMODE が mode と一致するレコードだけをフィルタリング
        .filter(col("L_SHIPMODE") == mode)
        # 上位10件に限定
        .limit(10)
        # 結果を "filter_table" という名前で保存
        .write.save_as_table("filter_table")
    )
    return "Filter table successfully created!"  # 成功メッセージを返す
