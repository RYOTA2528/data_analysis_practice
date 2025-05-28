-- �uDRY�v�i�uDon't Repeat Yourself�v�j�ɂ����肷�邽�߂ɁAJinja ���g�p���܂�


select
  order_id,
  sum(case when payment_method = 'bank_transfer' then amount end) as bank_transfer_amount,
  sum(case when payment_method = 'credit_card' then amount end) as credit_card_amount,
  sum(case when payment_method = 'gift_card' then amount end) as gift_card_amount,
  sum(amount) as total_amount
from {{ ref('raw_payments')}}
group by 1

-- �e�x�������@�̋��z�� SQL �͔����I�ł���A�������̗��R����ێ�������ɂȂ�ꍇ������܂��B
/*
�@���W�b�N�܂��̓t�B�[���h�����ύX���ꂽ�ꍇ�́A�R�[�h�� 3 �����X�V����K�v
�A���̃R�[�h�̓R�s�[�Ɠ\��t���ɂ���č쐬����邽�߁A�ԈႢ����������\��
�B�R�[�h�����r���[���鑼�̃A�i���X�g�́A�J��Ԃ����R�[�h�݂̂��X�L��������̂���ʓI�ł��邽�߁A�G���[�ɋC�t���\�����Ⴍ�Ȃ�܂��B
*/