/*
select
	order_id,
	{% for payment_method in ["bank_transfer", "credit_card", "gift_card"] %}
	sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount,
	{% endfor%}
	sum(amount) as total_amount
from {{ ref(raw_payments') }}
group by 1

�ȉ��ɕύX
*/

-- ���t�@�N�^�����O�F�ϐ��̔z�u���㕔�ɐݒ肷��

{% set payment_methods = ["bank_transfer", "credit_card", "gift_card"]%}

select
order_id,
{% for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount,
{% endfor %}
sum(amount) as total_amount
from {{ ref('raw_payments') }}
group by 1

