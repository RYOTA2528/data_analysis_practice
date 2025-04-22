// Snowflake Snowpipeを構成する
create pipe public.s3_access_logs_pipe auto_ingest=true as
  copy into s3_access_logs_staging from (
    SELECT
      STG.$1,
      current_timestamp() as timestamp
    FROM @s3_access_logs (FILE_FORMAT => TEXT_FORMAT) STG
  );
  
  
// 自動データ取り込み（Snowpipe）に関連するパイプの一覧が表示されます。
-- この中には、SQS連携などで必要になる SQSキュー ARN も含まれています。
-- notification_channel SQSキューの ARN（連携用）
-- この ARN を使って、S3 → SQS → Snowpipe の連携設定を AWS 側に組み込みます（イベント通知の送信先として）
  SHOW PIPES;
  
  
  
// Amazon S3 コンソールを使用してイベント通知を有効にして設定する
/*
ターゲットバケット -> プロパティを開く -> 「イベント通知の作成」を選択
以下の項目にご記入ください

名前: イベント通知の名前 (例: Auto-ingest Snowflake)。
プレフィックス (オプション): 特定のフォルダー (例: logs/) にファイルが追加された場合にのみ通知を受信する場合。
イベント: ObjectCreate (すべて) オプションを選択します。
送信先: ドロップダウンリストから「SQS キュー」を選択します。
SQS: ドロップダウンリストから「SQS キュー ARN の追加」を選択します。
SQS キュー ARN: SHOW PIPES 出力から SQS キュー名を貼り付けます。
↓
イベント通知が作成されました
*/

