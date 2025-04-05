-- select句をviewに変換する
create or replace view intl_db.public.NATIONS_SAMPLE_PLUS_ISO
(
    iso_country_name, -- ISO国名
    country_name_official, -- 公式国名
    alpha_code_2digit, -- 2桁のアルファベットコード
    region -- 地域名
) AS 
select
    iso_country_name, -- ISO国名
    country_name_official, -- 公式国名
    alpha_code_2digit, -- 2桁のアルファベットコード
    r_name as region -- 地域名（REGIONテーブルから）
from INTL_DB.PUBLIC.INT_STDS_ORG_3166 i
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION n
    on upper(i.iso_country_name) = n.n_name -- ISO国名とNATIONテーブルの国名を一致させる
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION r
    on n.n_regionkey = r.r_regionkey; -- NATIONテーブルの地域キーをREGIONテーブルの地域キーと一致させる


select *
from intl_db.public.NATIONS_SAMPLE_PLUS_ISO;