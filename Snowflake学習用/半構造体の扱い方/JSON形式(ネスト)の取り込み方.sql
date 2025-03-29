// FLATTEN は、ネストされたJSONデータをリストとして展開し、各要素を独立した行として出力するために使用します
select value: 
first_name 
from 
nested_ingest_json 
,lateral flatten(input => raw_nested_book:authors) ;

// TABLE 関数は、FLATTEN の結果をテーブルとして扱うために使用します。これにより、各著者が個別の行として取り扱われ、クエリで利用可能になります。
select value:first_name
from nested_ingest_json
,table(flatten(raw_nested_book:authors));

// 返されたフィールドに CAST コマンドを追加します
SELECT value:first_name::varchar, value:last_name::varchar
FROM nested_ingest_json,
LATERAL FLATTEN(input => raw_nested_book:authors);

//「AS」を使用して、列に新しい列名を割り当てます。 
select value:first_name::varchar as first_nm
, value:last_name::varchar as last_nm
from nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);


//authorsリストの「0」番目のfirst_nameを取得する
select raw_nested_book:authors[0].first_name as "0番目を先頭に" from nested_ingest_json,
LATERAL FLATTEN(input => raw_nested_book:authors);