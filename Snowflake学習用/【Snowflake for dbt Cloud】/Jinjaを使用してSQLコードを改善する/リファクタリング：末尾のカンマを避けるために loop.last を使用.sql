-- 末尾のカンマを避けるために loop.last を使用
/*
ループの最後の反復が最後の列である場合は、末尾にカンマがないことを確認する必要があります。
「loop.last」は、余分なコンマを追加しないようにするために、ifJinja 変数と一緒にステートメントをよく使用します
*/

{% set payment_methods = ["bank_transfer", "credit_card", "gift_card"] %}

select
order_id,
{% for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' the amount end) as {{payment_method}}_amount
{% if not loop.last %},{% endif %}   -- {{ "," if not loop.last }}と同義
{% endfor %}
from {{ref('raw_payments')}}
group by 1
