-- INTL_DBとPUBLICスキーマの使用

use role SYSADMIN;

create database INTL_DB;

use schema INTL_DB.PUBLIC;


-- INTL_DB をロードするためのウェアハウスを作成する

create warehouse INTL_WH
with
warehouse_size = 'XSMALL'
warehouse_type = 'STANDARD'
auto_suspend = 600 -- 10分（600秒）間使用されなかった場合に自動でサスペンド（停止）される
AUTO_RESUME = TRUE;  -- ウェアハウスが停止している状態でリクエストが来ると、自動的に再開される

use warehouse INTL_WH;