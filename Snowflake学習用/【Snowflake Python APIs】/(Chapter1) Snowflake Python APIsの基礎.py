# (概要)
# Snowflake Python APIsの基礎を学びます。
# 事前に以下セットアップの実施を行います。

/*
- 開発環境を設定します。
- Snowflake Python APIs パッケージをインストールします。
- Snowflake接続を設定します。
- Python API チュートリアルに必要なすべてのモジュールをインポートします。
- API Root オブジェクトを作成します。
*/

# 以下Snowflake Python APIs パッケージをインストールします
# モジュール名	説明
# snowflake.core	Snowflakeの各種リソースインスタンス（データベース・スキーマなど）用のイテレーターを定義します。
# snowflake.core.database	Snowflakeのデータベースを作成・取得・削除などの管理操作を提供します。
# snowflake.core.schema	データベース内のスキーマを管理します。
# snowflake.core.table	テーブルの作成、取得、削除、一覧など、テーブル操作に関する機能を提供します。
# snowflake.core.task	タスク（定期実行ジョブ）の作成、管理を行います。
# snowflake.core.task.dagv1	タスクをDAG（有向非巡回グラフ）形式で構成・管理するための高レベルAPIセット。
# snowflake.core.compute_pool	Snowpark Container Services のためのコンピューティングプールを作成・管理します。
# snowflake.core.image_repository	Snowpark Container Services 用の Docker イメージリポジトリを管理します。
# snowflake.core.service	Snowpark Container Services 上で稼働するサービスのデプロイ・管理を行います。


# snowflake.core の役割
# snowflake.core モジュールは、各リソースに対する操作を統一的なインターフェースで扱えるようにすることを目的としています。
# ここで言う「イテレーター」は、例えばデータベース一覧やスキーマ一覧などをforループで繰り返し処理できるようなオブジェクトを指します。

# 主な特徴
# 機能	内容
# リソース操作の共通化	データベース・スキーマ・タスクなど、Snowflakeのオブジェクトに共通のAPIインターフェースを提供。
# オブジェクト一覧取得	.list_*() のような関数で、該当リソースのリストを取得（例：list_databases()）。
# オブジェクトの作成・削除等	.create_*() や .delete_*() を使ってリソースのライフサイクルを管理。
# イテレーター形式での取得	Pythonの for ループなどで簡単にリソースを繰り返し処理できる。

#例：データベース一覧を取得（擬似コード）
from snowflake.core import Root
root = Root(connection)  # Snowflakeへの接続
for db in root.databases:
     print(db.name)

# このように、.databases はイテレーターとして機能し、データベース名などにアクセスできます。

