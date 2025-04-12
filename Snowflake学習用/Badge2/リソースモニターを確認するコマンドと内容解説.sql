SHOW RESOURCE MONITORS IN ACCOUNT; 

-- は、現在の Snowflake アカウント内に設定されている リソースモニターの一覧を表示するSQLコマンドです。

/*
? このコマンドで確認できる情報
実行すると、次のようなカラムが含まれた結果が返ってきます：

name	credit_quota	frequency	start_time	end_time	notify_users	triggers	warehouses
DAILY_3_CREDIT_LIMIT	3	DAILY	00:00	23:59	[admin@example.com]	ON 100% DO SUSPEND	COMPUTE_WH
? 用途
モニター名、クレジット制限、適用範囲（デイリー、ウィークリーなど）を確認。

各モニターが紐づいているウェアハウスや、トリガーの内容（例：100%到達時にSUSPEND）もチェック可能。

特定のモニターが原因でウェアハウスが停止しているかを把握するのに役立ちます。
*/

--【リソースモニターを作成】--
CREATE RESOURCE MONITOR daily_monitor
  WITH CREDIT_QUOTA = 5
  FREQUENCY = DAILY
  TRIGGERS ON 100 PERCENT DO SUSPEND; -- クレジットの使用量が 100%（=5クレジット）に達した時点で、紐づいているウェアハウスを停止（SUSPEND） する

--【リソースモニターの条件を変更する】--
ALTER RESOURCE MONITOR daily_monitor SET CREDIT_QUOTA = 10;

--【リソースモニターを削除する】--
DROP RESOURCE MONITOR daily_monitor;



