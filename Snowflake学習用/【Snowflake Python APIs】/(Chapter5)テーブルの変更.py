①テーブル列の追加
# PYTHON_API_TABLE テーブルには現在、 TEMPERATURE と LOCATION の2つの列があります。このシナリオでは、 
# int 型の ELEVATION という新しい列を追加し、
# それをテーブルの主キーに設定

table_details.columns.append(
    TableColumn(
      name="elevation",
      datatype="int",
      nullable=False,
      constraints=[PrimaryKey()],
    )
)


-------------------------------------------------------
②　上記修正を反映
table.create_or_alter(table_details)

-------------------------------------------------------
③　変更の確認

table.fetch().to_dict()

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
        {"name": "ELEVATION", "datatype": "NUMBER(38,0)", "nullable": False},
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
    "constraints": [
        {"name": "ELEVATION", "column_names": ["ELEVATION"], "constraint_type": "PRIMARY KEY"}
    ]
}

# columns の値と constraints の値を見直すと、両者とも ELEVATION 列を含むようになっています。