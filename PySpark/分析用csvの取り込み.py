import pandas as pd
# !pip insatll openpyxl
# CustomerIDが小数点入ってしまってるためobject型で取り込み
df = pd.read_excel('../data/Onleine Retail.xlsx', dtype={'CustomerID':object})
df.dtypes
# csvにする
df.to_csv('../data/Onleine Retail.csv')
# csvを読み込み
test = pd.read_csv('../data/Onleine Retail.csv', index=False)
test


