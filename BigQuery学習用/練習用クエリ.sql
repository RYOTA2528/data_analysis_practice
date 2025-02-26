/*
BigQueryへ 「2018 年のタクシー賃走データのサブセット」を格納
[格納データ名]
nyc_tlc_yellow_trips_2018_subset_1.csv
*/

/*年間で料金の高かった上位 5 件の賃走をリストするクエリを実行*/

SELECT
  *
FROM
  nyctaxi.2018trips
ORDER BY
  fare_amount DESC
LIMIT  5

/*Cloud Storage から 2018 年の同じ賃走データの別のサブセットを読み込み*/

/*
Cloud Shell で、次のコマンドを実行します。
-----------
bq load \
--source_format=CSV \
--autodetect \
--noreplace  \
nyctaxi.2018trips \
gs://cloud-training/OCBL013/nyc_tlc_yellow_trips_2018_subset_2.csv
----------
*/



/*DDL を使用して他のテーブルからテーブルを作成する*/

/*
2018trips テーブルには年間すべての賃走データが含まれるようになっているため、
「1 月の賃走データだけが必要な場合」に向けてテーブルを作成

*/


CREATE TABLE
  nyctaxi.january_trips AS
SELECT
  *
FROM
  nyctaxi.2018trips
WHERE
  EXTRACT(Month
  FROM
    pickup_datetime)=1;


/*1 月の最長賃走距離を特定*/
SELECT
  *
FROM
  nyctaxi.january_trips
ORDER BY
  trip_distance DESC
LIMIT
  1


