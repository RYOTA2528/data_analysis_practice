// ネストされた JSON データ用のテーブルとファイル形式を作成する
create or replace table TWEET_INGEST 
(
  RAW_STATUS VARIANT
);


// JSONデータを読み込むためのファイル形式を作成する
create or replace file format json_file_format
type = 'JSON' 
compression = 'AUTO' 
enable_octal = false
allow_duplicate = false
strip_outer_array = true --trueにすることで角括弧を無視して各著者を別々の行に読み込むことができる
strip_null_values = false 
ignore_utf8_errors = false; 


// 手動で作成したステージ(@JSON_INPUT)から実際にTWEET_INGESTテーブルへ読み込む
COPY INTO TWEET_INGEST
from @JSON_INPUT
FILE_FORMAT = (FORMAT_NAME = json_file_format);


// 単純な選択ステートメント -- 9 行が表示されていますか? 
select raw_status 
from tweet_ingest;

select raw_status:entities
from tweet_ingest;

select raw_status:entities:hashtags
from tweet_ingest;

// このクエリは、各ツイートの最初のハッシュタグのみを返します
select raw_status:entities:hashtags[0].text
from tweet_ingest;


 // このバージョンでは、ハッシュタグを含まないツイートを除去するために WHERE 句を追加します(欠損除外)
select raw_status:entities:hashtags[0].text
from tweet_ingest
where raw_status:entities:hashtags[0].text is not null;

////created_at キーに対して単純な CAST を実行します。ツイートの作成日で並べ替えるために ORDER BY 句を追加します
select raw_status :created_at::date 
from tweet_ingest 
order by raw_status:created_at::date;


//flatten ステートメントはネストされたエンティティのみを返すことができます (上位レベルのオブジェクトは無視されます)
select value
from tweet_ingest
,lateral flatten
(input => raw_status:entities:urls);

//上記と同様の結果となります
select value
from tweet_ingest
,table(flatten(raw_status:entities:urls));


//ハッシュタグ テキストのみをフラット化して返します。テキストを VARCHAR としてキャストします。 
select value:text::varchar as hashtag_used 
from tweet_ingest 
,lateral flatten 
(input => raw_status:entities:hashtags);


//返されたテーブルにツイート ID とユーザー ID を追加して、ハッシュタグを元のツイートに結合できるようにします。
create or replace view urls_normalized as
(select raw_status:user:name::text as user_name
,raw_status:id as tweet_id
,value:display_url::text as url_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:urls)
);


select
*
from urls_normalized;