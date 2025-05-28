-- �����̃J���}������邽�߂� loop.last ���g�p
/*
���[�v�̍Ō�̔������Ō�̗�ł���ꍇ�́A�����ɃJ���}���Ȃ����Ƃ��m�F����K�v������܂��B
�uloop.last�v�́A�]���ȃR���}��ǉ����Ȃ��悤�ɂ��邽�߂ɁAifJinja �ϐ��ƈꏏ�ɃX�e�[�g�����g���悭�g�p���܂�
*/

{% set payment_methods = ["bank_transfer", "credit_card", "gift_card"] %}

select
order_id,
{% for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' the amount end) as {{payment_method}}_amount
{% if not loop.last %},{% endif %}   -- {{ "," if not loop.last }}�Ɠ��`
{% endfor %}
from {{ref('raw_payments')}}
group by 1
