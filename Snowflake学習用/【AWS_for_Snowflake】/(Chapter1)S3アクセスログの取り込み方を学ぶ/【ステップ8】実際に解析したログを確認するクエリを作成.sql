-- どのユーザーがどのオブジェクトを削除したかを調査する  
SELECT RequestDateTime, RemoteIP, Requester, Key 
FROM s3_access_logs_db.mybucket_logs 
WHERE key = 'path/to/object' AND operation like '%DELETE%';


-- 要求数が多い順に IP アドレスを集計する  
select count(*),REMOTEIP 
from s3_access_logs group by remoteip order by count(*) desc;


-- IPごとの通信量（アップロード・ダウンロード）を集計する  
SELECT 
    remoteip,
    SUM(bytessent) AS uploadTotal,          -- アップロードされたバイト数の合計
    SUM(objectsize) AS downloadTotal,       -- ダウンロードされたオブジェクトサイズの合計
    SUM(ZEROIFNULL(bytessent) + ZEROIFNULL(objectsize)) AS Total -- 合計通信量
FROM s3_access_logs
group by REMOTEIP
order by total desc;


-- アクセス拒否（403 エラー）が発生したリクエストを表示する  
SELECT * FROM s3_access_logs WHERE httpstatus = '403';


-- 特定のユーザーによるすべての操作を表示する  
SELECT * 
FROM s3_access_logs_db.mybucket_logs 
WHERE requester='arn:aws:iam::123456789123:user/user_name';


-- 匿名ユーザー（未認証）によるリクエストを表示する  
SELECT *
FROM s3_access_logs
WHERE Requester IS NULL;