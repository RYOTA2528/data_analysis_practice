①セッションに関連するウェアハウスのコレクションを取得する
warehouses = root.warehouses

-------------------------------------------------------

②　新しいウェアハウスを定義して作成するには、次のセルで次のコードを実行
python_api_wh = Warehouse(
    name="PYTHON_API_WH",
    warehouse_size="SMALL",
    auto_suspend=500,
)

warehouse = warehouses.create(python_api_wh,mode=CreateMode.or_replace)


-------------------------------------------------------
③　ウェアハウスに関する情報を取得するには、次のセルで次のコードを実行
warehouse_details = warehouse.fetch()
warehouse_details.to_dict()


# 以下メタデータが出力される
{
  'name': 'PYTHON_API_WH',
  'auto_suspend': 500,
  'auto_resume': 'true',
  'resource_monitor': 'null',
  'comment': '',
  'max_concurrency_level': 8,
  'statement_queued_timeout_in_seconds': 0,
  'statement_timeout_in_seconds': 172800,
  'tags': {},
  'warehouse_type': 'STANDARD',
  'warehouse_size': 'Small'
}
-------------------------------------------------------
④　オプション: セッションに複数のウェアハウスがある場合、 API を使用して、それらのウェアハウスを繰り返し検索したり、特定のウェアハウスを検索することができます。

warehouse_list = warehouses.iter(like="PYTHON_API_WH")
result = next(warehouse_list)
result.to_dict()

-------------------------------------------------------
⑤　以下のように出力される
{
  'name': 'PYTHON_API_WH',
  'auto_suspend': 500,
  'auto_resume': 'true',
  'resource_monitor': 'null',
  'comment': '',
  'max_concurrency_level': 8,
  'statement_queued_timeout_in_seconds': 0,
  'statement_timeout_in_seconds': 172800,
  'tags': {},
  'warehouse_type': 'STANDARD',
  'warehouse_size': 'Small'
}

-------------------------------------------------------
⑥　ウェアハウスのサイズを LARGE に変更
warehouse = root.warehouses.create(Warehouse(
    name="PYTHON_API_WH",
    warehouse_size="LARGE",
    auto_suspend=500,
), mode=CreateMode.or_replace)

-------------------------------------------------------
⑦LARGE に更新されたことを確認するかつ削除も
warehouse.fetch().size
warehouse.drop()


