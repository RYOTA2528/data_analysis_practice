-- 空白スペース制御を使用してコンパイルされたコードを整理する

/*
フォルダー内のコードをチェックしていた場合target/compiled、このコードでは多くの空白が生成されることにお気づきかもしれません。

ターゲット/コンパイル済み/jaffle_shop/order_payment_method_amounts.sql


select
order_id,

sum(case when payment_method = 'bank_transfer' then amount end) as bank_transfer_amount
,

sum(case when payment_method = 'credit_card' then amount end) as credit_card_amount
,

sum(case when payment_method = 'gift_card' then amount end) as gift_card_amount


from raw_jaffle_shop.payments
group by 1

空白スペースの制御を使用してコードを整理することができます。
*/

/*空白スペースの制御*/
-- {%--%},{%- for %} {% endfor %}, {%- if %} {% -%}
{%- set payment_methods = ["bank_transfer", "credit_card", "gift_card"] -%}

select
order_id,
{%- for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount
{%- if not loop.last %},{% endif -%}
{% endfor %}
from {{ ref('raw_payments') }}
group by 1

