// 先ほど作成したストリームを処理するスケジュールタスクを作成

create or replace task s3_access_logs_transformation
warehouse = security_quickstart
schedule = '10 minute'  -- 10分ごとに自動実行（cron形式や1時間ごともOK）
when
system$stream_has_data('s3_access_logs_stream')
as
insert into s3_acess_logs(
 select parsed_logs.*
 from s3_access_logs_stream
 join table(parse_s3_access_logs(s3_access_logs_stream.raw)) parsed_logs --parse_s3_access_logs() 関数で構造化
 where s3_access_logs_stream.metadata$action = 'INSERT' --新しく挿入されたデータだけを対象にする
);
