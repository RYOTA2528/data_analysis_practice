from awsglue.context import GlueContext
from pyspark.context import SparkContext

sc = SparkContext.getOrCreate()
glue_context = GlueContext(sc)

# Glueカタログのsales_dbデータベースのtransactionsテーブルからDynamicFrameを取得
dynamic_frame = glue_context.create_dynamic_frame.from_catalog(
    database="sales_db",
    table_name="transactions"
)

# DynamicFrameをSpark DataFrameに変換
df = dynamic_frame.toDF()

# 先頭5行を表示
df.show(5)


# クエリでフィルターをかけてデータを取得したい場合（例：2024年以降の売上データだけ取得）：

query = "SELECT * FROM transactions WHERE sale_date >= '2024-01-01'"

dynamic_frame = glue_context.create_dynamic_frame.from_catalog(
    database="sales_db",
    table_name="transactions",
    additional_options={"sampleQuery": query}
)

df = dynamic_frame.toDF()
df.show(5)