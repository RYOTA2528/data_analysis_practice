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

-------------------------------------------------------
④先に作成した PYTHON_API_TABLE テーブルの詳細を取得する

table_details = table.fetch()

# 出来上がったオブジェクトに対して .to_dict() を呼び出すと、その詳細情報を表示することができます。
table_details.to_dict()

# ノートブックは、このような PYTHON_API_TABLE テーブルに関するメタデータを含むディクショナリを表示
{
    "name": "PYTHON_API_TABLE",
    "kind": "TABLE",
    "enable_schema_evolution": False,
    "change_tracking": False,
    "data_retention_time_in_days": 1,
    "max_data_extension_time_in_days": 14,
    "default_ddl_collation": "",
    "columns": [
        {"name": "TEMPERATURE", "datatype": "NUMBER(38,0)", "nullable": False},
        {"name": "LOCATION", "datatype": "VARCHAR(16777216)", "nullable": True},
    ],
    "created_on": datetime.datetime(
        2024, 5, 9, 8, 59, 15, 832000, tzinfo=datetime.timezone.utc
    ),
    "database_name": "PYTHON_API_DB",
    "schema_name": "PYTHON_API_SCHEMA",
    "rows": 0,
    "bytes": 0,
    "owner": "ACCOUNTADMIN",
    "automatic_clustering": False,
    "search_optimization": False,
    "owner_role_type": "ROLE",
}

