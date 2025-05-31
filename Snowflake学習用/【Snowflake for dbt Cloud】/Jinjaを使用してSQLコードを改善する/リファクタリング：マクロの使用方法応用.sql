// マクロに複数の処理を追加設定する
{% macro get_payment_methods() %}

{{% set payment_methods_query %}}
select distinct
payment_mehod
from {{ ref('raw_payments') }
order by 1
{% endset %}

{% set results = run_query(payment_methods_query) %}

{{ log(results, info=True) }}

{{ return([]) }} --{{ return([]) }} は、開発中・デバッグ中に「仮置き」


{% endmacro %}

-- 結果は以下
| column         | data_type |
| -------------- | --------- |
| payment_method | Text      |


-- さらに上記コードを改修する(returnの結果を格納)
{% macro get_payment_methods() %}

{% set payment_methods_query %}
select distinct
payment_method
from {{ ref('raw_payments') }}
from order by 1
{% endset %}


{% set results = run_query(payment_methods_query) %}

{% if execute %}

{% set results_list = results.columns[0].values() %} --results.columns[0] は列のオブジェクトなので、.values() を呼ぶことで、その列の 全ての値をPythonのリストとして取得
{% else %}
{% set results_list = [] %}
{% endif %}

{{ return(results_list) }}

{% endmacro %}




