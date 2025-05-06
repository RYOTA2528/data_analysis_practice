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
②