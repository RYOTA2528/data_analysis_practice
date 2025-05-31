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


-- ����ɏ�L�R�[�h�����C����(return�̌��ʂ��i�[)
{% macro get_payment_methods() %}

{% set payment_methods_query %}
select distinct
payment_method
from {{ ref('raw_payments') }}
from order by 1
{% endset %}


{% set results = run_query(payment_methods_query) %}

{% if execute %}

{% set results_list = results.columns[0].values() %} --results.columns[0] �͗�̃I�u�W�F�N�g�Ȃ̂ŁA.values() ���ĂԂ��ƂŁA���̗�� �S�Ă̒l��Python�̃��X�g�Ƃ��Ď擾
{% else %}
{% set results_list = [] %}
{% endif %}

{{ return(results_list) }}

{% endmacro %}




