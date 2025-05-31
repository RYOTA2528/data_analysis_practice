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






