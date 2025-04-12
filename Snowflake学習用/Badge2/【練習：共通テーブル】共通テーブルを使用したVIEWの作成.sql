// �ǂꂾ���̔z�B���~��̉e���Œx������̂��H  
/*
1����6�C���`�𒴂���~�Ⴊ����ƁA���̉�Ђł͔z�B�ɒx�����������܂��B
�O�N��1����3�T�ɉe�����󂯂��z�B���͂ǂꂭ�炢����܂����H
*/
�@--�N�G�����--
�@/*
�@�@�EDATEADD(year, -1, CURRENT_DATE())�F1�N�O �� 2024-04-12
�@�@�EDATE_TRUNC('year', ...)�F2024-04-12 �� 2024-01-01
�@�@�EWEEKISO(ref_timestamp) != 1�@ISO �T�ԍ��Ō��āA1��1�����u��1�T�v�łȂ��ꍇ�A1�����Z���Ē����@��F2023�N1��1���� ISO��́u�O�N�̍ŏI�T�v�Ȃ̂ŏT�ԍ���1����Ȃ�
  �@�ECAST(WEEKISO(ref_timestamp) != 1 AS INTEGER)
    �EWEEKISO(ref_timestamp) != 1 WEEKISO(...) != 1 ���^���ǂ����� ���l�i0��1�j�Ƃ��Ĉ�����悤�ɂ��Ă���
    �EDATEADD(week, 2 + CAST(WEEKISO(ref_timestamp) != 1 AS INTEGER), ref_timestamp)�@��{�́u2�T�i�߂�v�������Aref_timestamp�i�O�N��1��1���j����1�T�łȂ��ꍇ�́u����1�T�����v���炷
    --
    �ENATURAL INNER JOIN�@�����̃e�[�u���ɓ������O�̃J����������΁A����������L�[�Ƃ��Ďg���i�uON �e�[�u��A.col = �e�[�u��B.col ���ď����Ȃ��Ă������ł���Ă����v�j
    �EROW_NUMBER() OVER (ORDER BY SEQ1())�F���̊֐��́A�������ꂽ�ԍ��iSEQ1()�j�Ɋ�Â��� 1����n�܂�A�� �� day_num ��Ƃ��Đ���
    �ETABLE(GENERATOR(rowcount => 7)) �́A7�s�̉��z�I�ȃf�[�^�Z�b�g �𐶐����܂��B���̃f�[�^�Z�b�g�́A����̑���⏈�������邽�߂̒��Ԍ��ʂƂ��Ďg���܂��B
�@*/
WITH timestamps AS
(   
    SELECT
        DATE_TRUNC(year,DATEADD(year,-1,CURRENT_DATE())) AS ref_timestamp,
        LAST_DAY(DATEADD(week,2 + CAST(WEEKISO(ref_timestamp) != 1 AS INTEGER),ref_timestamp),week) AS end_week,
        DATEADD(day, day_num - 7, end_week) AS date_valid_std
    FROM
    (   
        SELECT
            ROW_NUMBER() OVER (ORDER BY SEQ1()) AS day_num
        FROM
            TABLE(GENERATOR(rowcount => 7))
    ) 
)
SELECT
    country,
    postal_code,
    date_valid_std, --�ϑ����i���Ώۂ̏T�̓��t�j
    tot_snowfall_in --���̓��̑��~��ʁi�C���`�j
FROM 
    standard_tile.history_day
NATURAL INNER JOIN --���ʂ̃J�����i���̏ꍇ date_valid_std�j�Ŏ�������
    timestamps --�O�N��1����3�T��7���Ԃ̃��X�g�𐶐��������ʃe�[�u����
WHERE
    country='US' AND
    tot_snowfall_in > 6.0 --1���̍~��ʂ� 6.0�C���`�� �Ɍ���i�x�����X�N���������j
ORDER BY 
    postal_code,date_valid_std
;