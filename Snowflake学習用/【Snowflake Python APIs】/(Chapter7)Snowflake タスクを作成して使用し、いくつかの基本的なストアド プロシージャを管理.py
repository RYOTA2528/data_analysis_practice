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

#2 