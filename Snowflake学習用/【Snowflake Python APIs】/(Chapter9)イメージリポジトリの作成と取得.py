# （流れ）
/*
まず Snowflake Python APIs を使ってイメージリポジトリを作成します。次に、Docker Hubから NGINX アプリケーションイメージを取得し、Docker CLI 
を使ってイメージをイメージリポジトリにアップロードします。
*/

# 1 リポジトリを作成し、リポジトリに関する情報を取得する
from snowflake.core.image_repository import ImageRepository

my_repo = ImageRepository("MyImageRepository")
schema.image_repositories.create(my_repo)

# で以前に作成したデータベースとスキーマにイメージリポジトリを作成

# 2 リポジトリの詳細を取得し、その名前を表示することで、リポジトリが正常に作成されたことを確認する
my_repo_res = schema.image_repositories["MyImageRepository"]
my_repo = my_repo_res.fetch()
print(my_repo.name)


# 3 イメージをビルドしてアップロードする前に、リポジトリに関する情報（リポジトリ URL とレジストリのホスト名）が必要なため取得
repositories = schema.image_repositories
  for repo_obj in repositories.iter():
    print(repo_obj.repository_url)

# 以下出力結果となる
# <orgname>-<acctname>.registry.snowflakecomputing.com/spcs_python_api_db/public/myimagerepository
# ホスト名は以下の部分
# <orgname>-<acctname>.registry.snowflakecomputing.com