-- �󔒃X�y�[�X������g�p���ăR���p�C�����ꂽ�R�[�h�𐮗�����

/*
�t�H���_�[���̃R�[�h���`�F�b�N���Ă����ꍇtarget/compiled�A���̃R�[�h�ł͑����̋󔒂���������邱�Ƃɂ��C�Â���������܂���B

�^�[�Q�b�g/�R���p�C���ς�/jaffle_shop/order_payment_method_amounts.sql


select
order_id,

sum(case when payment_method = 'bank_transfer' then amount end) as bank_transfer_amount
,

sum(case when payment_method = 'credit_card' then amount end) as credit_card_amount
,

sum(case when payment_method = 'gift_card' then amount end) as gift_card_amount


from raw_jaffle_shop.payments
group by 1

�󔒃X�y�[�X�̐�����g�p���ăR�[�h�𐮗����邱�Ƃ��ł��܂��B
*/

/*�󔒃X�y�[�X�̐���*/
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

