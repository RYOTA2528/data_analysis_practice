// dbtプロジェクトの他の部分でも同様のパターンを使用したい場合
-- macro/get_payment_methods.sql

{% macro get_column_values(column_name, relation) %}

{% set relation_query %}
select distinct
{{ column_name }}
from {{ relation }}
order by 1
{% endset %}

{% set results = run_query(relation_query) %}

{% if execute %}

{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}

{% endmacro %}


-- 上記を呼び出す用のマクロを生成
{% macro get_payment_methods() %}
{{ return(get_column_values('payment_method', ref('raw_payments'))) }}
{% endmacro %}