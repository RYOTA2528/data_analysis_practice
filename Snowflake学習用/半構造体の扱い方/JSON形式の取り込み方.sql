// JSON DDL スクリプト
use database library_card_catalog; 

// JSON データの取り込みテーブルを作成する
create or replace table library_card_catalog.public.author_ingest_json
(
  raw_author variant
);


// JSONデータを読み込むためのファイル形式を作成する
create or replace file format library_card_catalog.public.json_file_format
type = 'JSON' 
compression = 'AUTO' 
enable_octal = false
allow_duplicate = false
strip_outer_array = true --trueにすることで角括弧を無視して各著者を別々の行に読み込むことができる
strip_null_values = false 
ignore_utf8_errors = false; 

//手動で作成したステージ(@json_input)から実際にauthor_ingest_jsonテーブルへ読み込む
COPY INTO author_ingest_json
from @json_input
FILE_FORMAT = (FORMAT_NAME = library_card_catalog.public.json_file_format);

// 取得項目の確認
select * from author_ingest_json;


//raw_authorのデータを確認
select raw_author from author_ingest_json;


// 半構造体の属性情報からAUTHOR_UID値を返します
select raw_author:AUTHOR_UID
from author_ingest_json;


// 正規化されたテーブルのような形式でデータを返します
select
 raw_author:AUTHOR_UID
,raw_author:FIRST_NAME::STRING as FIRST_NAME
,raw_author:MIDDLE_NAME::STRING as MIDDLE_NAME
,raw_author:LAST_NAME::STRING as LAST_NAME
FROM AUTHOR_INGEST_JSON;
