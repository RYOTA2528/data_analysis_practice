①root オブジェクトを使用して、Snowflake アカウントにデータベース、スキーマ、テーブルを作成

database = root.databases.create(
  Database(
    name="PYTHON_API_DB"),
    mode=CreateMode.or_replace
  )

# SQL コマンド CREATE OR REPLACE DATABASE PYTHON_API_DB と機能的に同等
# CreateMode.if_not_exists: 機能的に SQL の CREATE IF NOT EXISTS と同等です。
# CreateMode.error_if_exists: オブジェクトがすでにSnowflakeに存在する場合、例外を発生させます
-------------------------------------------------------
②データベースにスキーマを作成

schema = database.schemas.create(
  Schema(
    name="PYTHON_API_SCHEMA"),
    mode=CreateMode.or_replace,
  )

-------------------------------------------------------
③先ほど作成したスキーマにテーブルを作成
table = schema.tables.create(
  Table(
    name="PYTHON_API_TABLE",
    columns=[
      TableColumn(
        name="TEMPERATURE",
        datatype="int",
        nullable=False,
      ),
      TableColumn(
        name="LOCATION",
        datatype="string",
      ),
    ],
  ),
mode=CreateMode.or_replace
)