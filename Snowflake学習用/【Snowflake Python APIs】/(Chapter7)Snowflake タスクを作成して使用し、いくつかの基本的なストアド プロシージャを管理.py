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

# 4 以前に作成したPython関数をストアドプロシージャとして実行する2つのタスクを定義、作成
# タスク用のステージを指定（データベース名.スキーマ名.TASKS_STAGE）
tasks_stage = f"{database.name}.{schema.name}.TASKS_STAGE"

# task1: 1分ごとに実行されるタスクを定義
task1 = Task(
    name="task_python_api_trunc",  # タスクの名前
    definition=StoredProcedureCall(
        func=trunc,  # 実行するPython関数（テーブルの先頭n件をコピーする）
        stage_location=f"@{tasks_stage}",  # 関数コードを保存・実行するステージの場所（@マーク付き）
        packages=["snowflake-snowpark-python"],  # Snowparkを使うためのパッケージ指定
    ),
    warehouse="COMPUTE_WH",  # 実行に使用するSnowflakeの仮想ウェアハウス
    schedule=timedelta(minutes=1)  # 1分ごとにこのタスクをスケジューリング
)

# task2: スケジュールなしで定義されるタスク（必要に応じて起動）
task2 = Task(
    name="task_python_api_filter",  # タスクの名前
    definition=StoredProcedureCall(
        func=filter_by_shipmode,  # 出荷モードでフィルターする関数を実行
        stage_location=f"@{tasks_stage}",  # 実行ステージの場所（同じく@付き）
        packages=["snowflake-snowpark-python"],  # Snowparkライブラリを使用
    ),
    warehouse="COMPUTE_WH"  # 使用するウェアハウス（同じくCOMPUTE_WH）
    # スケジュールは指定されていないので、手動または他のタスクから起動される
)

# 5 データベーススキーマから TaskCollection オブジェクト（tasks）を取り出し、タスクコレクションで .create()しタスクを作成
# create the task in the Snowflake database
# `tasks` は `schema` オブジェクトの中のタスク管理オブジェクトを参照している
tasks = schema.tasks

# `task1` を Snowflake にタスクとして作成（すでに存在する場合は置き換え）
trunc_task = tasks.create(task1, mode=CreateMode.or_replace)

# `task2` の前に `trunc_task` を実行するように依存関係（前提条件）を設定
task2.predecessors = [trunc_task.name]

# `task2` を Snowflake にタスクとして作成（すでに存在する場合は置き換え）
filter_task = tasks.create(task2, mode=CreateMode.or_replace)

# 6 2つのタスクが存在することを確認
taskiter = tasks.iter()
for t in taskiter:
    print(t.name)


# 7 タスクを作成すると、そのタスクはデフォルトで一時停止されるため再開処理を追加
trunc_task.resume()

# 8 trunc_task タスクが開始されたことを確認する処理の追加
taskiter = tasks.iter()
for t in taskiter:
    print("Name: ", t.name, "| State: ", t.state)
# 以下出力結果となる
# Name:  TASK_PYTHON_API_FILTER | State:  suspended
# Name:  TASK_PYTHON_API_TRUNC | State:  started


※【重要】※
# タスクのステータスを確認したいときは、いつでもこのステップを繰り返すこと

# 9 タスク・リソースをクリーンアップするには、まずタスクを一時停止してからドロップ
trunc_task.suspend()
trunc_task.drop()
filter_task.drop()

# 9 Snowflake上でPython APIを使ってDAG（有向非巡回グラフ）形式でタスクを作成・デプロイする
# 多数のタスクの実行を調整するための機能
# DAG（タスクの依存関係を表すグラフ）の名前を指定
dag_name = "python_api_dag"

# 1日ごとにスケジュールされるDAGを作成
dag = DAG(name=dag_name, schedule=timedelta(days=1))

# `with` ブロック内でDAGにタスクを登録していく
with dag:
    # 1つ目のタスクを定義：`trunc` というPython関数を呼び出すストアドプロシージャを実行
    dag_task1 = DAGTask(
        name="task_python_api_trunc",  # タスク名
        definition=StoredProcedureCall(
            func=trunc,  # 呼び出すPython関数（あらかじめSnowflakeにアップロードされていることが前提）
            stage_location=f"@{tasks_stage}",  # ステージの場所（ファイルが格納されている）
            packages=["snowflake-snowpark-python"]  # Snowparkライブラリを使用
        ),
        warehouse="COMPUTE_WH",  # タスク実行時に使用するウェアハウス
    )

    # 2つ目のタスク：`filter_by_shipmode` 関数を呼び出すストアドプロシージャを実行
    dag_task2 = DAGTask(
        name="task_python_api_filter",
        definition=StoredProcedureCall(
            func=filter_by_shipmode,
            stage_location=f"@{tasks_stage}",
            packages=["snowflake-snowpark-python"]
        ),
        warehouse="COMPUTE_WH",
    )

    # タスクの依存関係を定義：dag_task1 が終わった後に dag_task2 を実行
    dag_task1 >> dag_task2

# DAG操作用のオブジェクトを作成（タスクをスキーマにデプロイするためのもの）
dag_op = DAGOperation(schema)

# DAGをSnowflakeにデプロイ（すでに存在する場合は置き換え）
dag_op.deploy(dag, mode=CreateMode.or_replace)




