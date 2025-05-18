# 【概要】
# Snowpark Container Services は、
# Snowflakeエコシステム内におけるコンテナー化されたアプリケーションの展開、管理、スケーリングを容易にするように設計されたフルマネージドコンテナーサービス


# 1 Jupyter notebookに以下実行
from snowflake.core.database import Database
from snowflake.core.schema import Schema

database = root.database.create(Database(name="spcs_python_api_db"), mode="orreplace")
schema = database.schemas.create(Schema(name="public"), mode="orreplace")

# 【全体の流れとコンテナサービスの概要】
1. イメージリポジトリ（Image Repository）
目的：アプリケーションのコンテナイメージを格納するSnowflake内のストレージ。

使い方：

Docker CLIやSnowSQLなどのOCI準拠クライアントで接続。

イメージをSnowflakeアカウントにアップロードしたり、管理したりできる。

イメージ形式：OCI v2（Dockerと同じ形式）。



🖥️ 2. コンピューティングプール（Computing Pool）
目的：コンテナを実行するための仮想マシン（VM）リソースの集合。

特徴：

Snowflakeのウェアハウスと似ているが、コンテナ専用。

必要な処理能力に応じて、小規模（軽量処理）〜大規模（GPUや多数コア）まで選べる。

用途：コンテナベースのアプリやサービス（例：NGINX）を物理的に実行する基盤。



🚀 3. サービス（Service）
目的：コンテナをSnowflake上で実際に動かす仕組み。

必要な構成：

YAML形式の仕様（どのイメージを使うか、ポート、エンドポイントなど）

コンピューティングプール（どこで動かすか）

実行例：Webアプリ、APIサービス、データ前処理など。

🔄 全体の流れ（ざっくり）
コンテナイメージを作成（ローカルで）

Snowflakeのイメージリポジトリにアップロード

コンピューティングプールを準備

サービス仕様（YAML）を定義

Snowflakeでサービスを実行・公開