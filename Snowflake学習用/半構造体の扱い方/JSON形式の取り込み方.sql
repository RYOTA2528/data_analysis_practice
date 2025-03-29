// JSON DDL �X�N���v�g
use database library_card_catalog; 

// JSON �f�[�^�̎�荞�݃e�[�u�����쐬����
create or replace table library_card_catalog.public.author_ingest_json
(
  raw_author variant
);


// JSON�f�[�^��ǂݍ��ނ��߂̃t�@�C���`�����쐬����
create or replace file format library_card_catalog.public.json_file_format
type = 'JSON' 
compression = 'AUTO' 
enable_octal = false
allow_duplicate = false
strip_outer_array = true --true�ɂ��邱�ƂŊp���ʂ𖳎����Ċe���҂�ʁX�̍s�ɓǂݍ��ނ��Ƃ��ł���
strip_null_values = false 
ignore_utf8_errors = false; 

//�蓮�ō쐬�����X�e�[�W(@json_input)������ۂ�author_ingest_json�e�[�u���֓ǂݍ���
COPY INTO author_ingest_json
from @json_input
FILE_FORMAT = (FORMAT_NAME = library_card_catalog.public.json_file_format);

// �擾���ڂ̊m�F
select * from author_ingest_json;


//raw_author�̃f�[�^���m�F
select raw_author from author_ingest_json;


// ���\���̂̑�����񂩂�AUTHOR_UID�l��Ԃ��܂�
select raw_author:AUTHOR_UID
from author_ingest_json;


// ���K�����ꂽ�e�[�u���̂悤�Ȍ`���Ńf�[�^��Ԃ��܂�
select
 raw_author:AUTHOR_UID
,raw_author:FIRST_NAME::STRING as FIRST_NAME
,raw_author:MIDDLE_NAME::STRING as MIDDLE_NAME
,raw_author:LAST_NAME::STRING as LAST_NAME
FROM AUTHOR_INGEST_JSON;
