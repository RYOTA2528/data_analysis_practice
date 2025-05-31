// ����܂łɍ�����}�N���̑���Ɂudbt-utils �p�b�P�[�W�v�̎g�p
{%- set payment_methods = dbt_utils.get_column_values(
	table = ref('raw_payments'),
	column='payment_method'
) -%} --��ӂȒl�iDISTINCT�Ȓl�j��Python���X�g�Ƃ��Ď擾


select
order_id,
{%- for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount
{%- if not loop.last %},{% endif -%}
{% endfor %}
from {{ ref('raw_payments') }}
group by 1

