/*��قǂ̃e�[�u���փf�[�^�̑}��*/
INSERT INTO ROOT_DEPTH(ROOT_DEPTH_ID, ROOT_DEPTH_CODE, ROOT_DEPTH_NAME, UNIT_OF_MEASURE, RANGE_MIN, RANGE_MAX)
VALUES (1, 'S', '��', 'cm', 30, 45);

SELECT
*
FROM "ROOT_DEPTH";


/*�����s�̑}��*/
insert into root_depth (root_depth_id, root_depth_code
                        , root_depth_name, unit_of_measure
                        , range_min, range_max)  
values
                        (5,'X','short','in',66,77)
                       ,(8,'Y','tall','cm',98,99);

/*�i���F�t�@�C���̓X�e�[�W�ɃA�b�v���[�h�ς݂Ɖ���j�Ƃ����ꍇ��COPY INTO ���g�p���ăt�@�C������f�[�^�����[�h*/
-- COPY INTO ROOT_DEPTH
-- FROM @your_stage/data.csv
-- FILE_FORMAT = (
-- TYPE = 'CSV' 
-- FIELD_OPTIONALLY_ENCLOSED_BY = '"' --""�ŉߋ����܂�Ă����ꍇ�͂��̂܂܎�荞�ނ���
-- )
-- ;



/*�e�[�u�����̕s�v�ȍs���폜����ɂ�*/
delete from ROOT_DEPTH
WHERE ROOT_DEPTH_ID = 8;


/*�f�[�^�̍X�V*/
update ROOT_DEPTH set ROOT_DEPTH_ID = 9
where ROOT_DEPTH_ID = 5;
