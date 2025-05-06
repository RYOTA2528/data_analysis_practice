①Snowflake の接続設定ファイル connections.toml を $HOME/.snowflake/connections.toml に作成するためのサンプル
[default]
account = "<YOUR ACCOUNT NAME>"           # アカウント名（例: abc12345.us-east-1）
user = "<YOUR ACCOUNT USER>"              # ユーザー名（Snowflake ログイン用）
password = "<YOUR ACCOUNT USER PASSWORD>" # ユーザーのパスワード

# オプション：使用するウェアハウス（計算リソース）を指定できます
# warehouse = "<YOUR COMPUTE WH>"         # 例: COMPUTE_WH

# オプション：初期接続時に使用するデータベースを指定できます
# database = "<YOUR DATABASE>"            # 例: MY_DB

# オプション：初期接続時に使用するスキーマを指定できます
# schema = "<YOUR SCHEMA>"                # 例: PUBLIC


-----------------------------------------------------------------------------
② ノートブックの最初のセルで、以下のインポートステートメントを実行

from datetime import timedelta  # Python標準のdatetimeモジュールから、時間の差（例: タスクの実行間隔など）を表すtimedeltaをインポート

from snowflake.snowpark import Session  # Snowflakeとの接続セッションを確立するためのSessionクラス（Snowpark用）
from snowflake.snowpark.functions import col  # Snowparkで列を操作するための関数（例: col("列名")）

from snowflake.core import Root, CreateMode  # Root: Snowflake全体のリソースにアクセスするためのエントリポイント
                                              # CreateMode: リソース作成時のモード（例: IF_NOT_EXISTS, OR_REPLACEなど）

from snowflake.core.database import Database  # データベースの作成・取得・削除などを行うためのクラス

from snowflake.core.schema import Schema  # スキーマ（スキーマ＝DB内の名前空間）の作成・取得・操作に使うクラス

from snowflake.core.stage import Stage  # ステージ（ファイルの一時保存場所）を操作するためのクラス（外部ファイルのロード・アンロード等）

from snowflake.core.table import Table, TableColumn, PrimaryKey  # Table: テーブル作成・操作用
                                                                 # TableColumn: テーブル定義のカラムを表す
                                                                 # PrimaryKey: 主キー制約の定義に使用

from snowflake.core.task import StoredProcedureCall, Task  # Task: 定期実行ジョブの作成・管理用
                                                           # StoredProcedureCall: タスクでストアドプロシージャを呼び出すときに使用

from snowflake.core.task.dagv1 import DAGOperation, DAG, DAGTask  # DAG: 複数タスクを依存関係でつなげるDAG（有向非巡回グラフ）を表す
                                                                  # DAGTask: DAG内の個別のタスクノード
                                                                  # DAGOperation: DAG定義の操作（追加・削除など）に使う

from snowflake.core.warehouse import Warehouse  # 仮想ウェアハウス（クエリを実行するコンピュートリソース）の作成・管理用
