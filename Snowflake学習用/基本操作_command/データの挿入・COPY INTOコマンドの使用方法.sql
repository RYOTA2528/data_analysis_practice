/*��قǂ̃e�[�u���փf�[�^�̑}��*/
INSERT INTO ROOT_DEPTH(ROOT_DEPTH_ID, ROOT_DEPTH_CODE, ROOT_DEPTH_NAME, UNIT_OF_MEASURE, RANGE_MIN, RANGE_MAX)
VALUES (1, 'S', '��', 'cm', 30, 45);

SELECT
*
FROM "ROOT_DEPTH";


/*�i���F�t�@�C���̓X�e�[�W�ɃA�b�v���[�h�ς݂Ɖ���j�Ƃ����ꍇ��COPY INTO ���g�p���ăt�@�C������f�[�^�����[�h*/
COPY INTO ROOT_DEPTH
FROM @your_stage/data.csv
FILE_FORMAT = (
TYPE = 'CSV' 
FIELD_OPTIONALLY_ENCLOSED_BY = '"' --""�ŉߋ����܂�Ă����ꍇ�͂��̂܂܎�荞�ނ���
)
;