// これまでに作ったマクロの代わりに「dbt-utils パッケージ」の使用
{%- set payment_methods = dbt_utils.get_column_values(
	table = ref('raw_payments'),
	column='payment_method'
) -%} --一意な値（DISTINCTな値）をPythonリストとして取得


select
order_id,
{%- for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount
{%- if not loop.last %},{% endif -%}
{% endfor %}
from {{ ref('raw_payments') }}
group by 1

