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


# 3 