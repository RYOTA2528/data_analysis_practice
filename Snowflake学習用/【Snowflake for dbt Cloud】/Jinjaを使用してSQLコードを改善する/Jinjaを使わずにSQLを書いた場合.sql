-- 「DRY」（「Don't Repeat Yourself」）にしたりするために、Jinja を使用します


select
  order_id,
  sum(case when payment_method = 'bank_transfer' then amount end) as bank_transfer_amount,
  sum(case when payment_method = 'credit_card' then amount end) as credit_card_amount,
  sum(case when payment_method = 'gift_card' then amount end) as gift_card_amount,
  sum(amount) as total_amount
from {{ ref('raw_payments')}}
group by 1

-- 各支払い方法の金額の SQL は反復的であり、いくつかの理由から維持が困難になる場合があります。
/*
①ロジックまたはフィールド名が変更された場合は、コードを 3 か所更新する必要
②このコードはコピーと貼り付けによって作成されるため、間違いが発生する可能性
③コードをレビューする他のアナリストは、繰り返されるコードのみをスキャンするのが一般的であるため、エラーに気付く可能性が低くなります。
*/