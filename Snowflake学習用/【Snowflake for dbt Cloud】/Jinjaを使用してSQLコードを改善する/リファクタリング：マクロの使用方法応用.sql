// �}�N���ɕ����̏�����ǉ��ݒ肷��
{% macro get_payment_methods() %}

{{% set payment_methods_query %}}
select distinct
payment_mehod
from {{ ref('raw_payments') }
order by 1
{% endset %}

{% set results = run_query(payment_methods_query) %}

{{ log(results, info=True) }}

{{ return([]) }} --{{ return([]) }} �́A�J�����E�f�o�b�O���Ɂu���u���v


{% endmacro %}

-- ���ʂ͈ȉ�
| column         | data_type |
| -------------- | --------- |
| payment_method | Text      |






