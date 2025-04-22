// データを受信するためにSnowflakeを準備する

-- 1分間操作がないと停止する中規模の単一クラスターウェアハウスを作成
create warehouse security_quickstart with 
  WAREHOUSE_SIZE = MEDIUM 
  AUTO_SUSPEND = 60;
  
  
-- 解析されていないログをインポートするためのファイル形式を作成
CREATE FILE FORMAT IF NOT EXISTS TEXT_FORMAT
TYPE = 'CSV'
FIELD_DELIMITER = NONE --区切り文字を使わない（','が多い）
SKIP_BLANK_LINES = TRUE --空行はスキップする
ESCAPE_UNENCLOSED_FIELD = NONE; --囲まれていないフィールド内のエスケープ文字を無効にする