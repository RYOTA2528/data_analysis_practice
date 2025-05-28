-- Jinja �̃}�N���́A������Ăяo�����Ƃ��ł���R�[�h
{% macro get_payment_methods() %}
{{return(["bank_transfer", "credit_card", "gift_card"])}}
{% endmacro %}

-- ��L���g�p���Ĉȉ��̂悤�ɕύX�\
{%- set payment_methods = get_payment_methods() -%}

select
order_id,
{%- for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount
{%- if not loop.last %},{% endif -%}
{% endfor %}
from {{ ref('raw_payments') }}
group by 1