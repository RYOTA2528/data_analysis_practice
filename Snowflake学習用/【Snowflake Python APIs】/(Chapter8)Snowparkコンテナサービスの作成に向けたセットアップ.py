# 【概要】
# Snowpark Container Services は、
# Snowflakeエコシステム内におけるコンテナー化されたアプリケーションの展開、管理、スケーリングを容易にするように設計されたフルマネージドコンテナーサービス


# 1 Jupyter notebookに以下実行
from snowflake.core.database import Database
from snowflake.core.schema import Schema

database = root.database.create(Database(name="spcs_python_api_db"), mode="orreplace")
schema = database.schemas.create(Schema(name="public"), mode="orreplace")

