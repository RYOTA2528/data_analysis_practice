// �l�X�g���ꂽ JSON �f�[�^�p�̃e�[�u���ƃt�@�C���`�����쐬����
create or replace table TWEET_INGEST 
(
  RAW_STATUS VARIANT
);


// JSON�f�[�^��ǂݍ��ނ��߂̃t�@�C���`�����쐬����
create or replace file format json_file_format
type = 'JSON' 
compression = 'AUTO' 
enable_octal = false
allow_duplicate = false
strip_outer_array = true --true�ɂ��邱�ƂŊp���ʂ𖳎����Ċe���҂�ʁX�̍s�ɓǂݍ��ނ��Ƃ��ł���
strip_null_values = false 
ignore_utf8_errors = false; 


// �蓮�ō쐬�����X�e�[�W(@JSON_INPUT)������ۂ�TWEET_INGEST�e�[�u���֓ǂݍ���
COPY INTO TWEET_INGEST
from @JSON_INPUT
FILE_FORMAT = (FORMAT_NAME = json_file_format);


// �P���ȑI���X�e�[�g�����g -- 9 �s���\������Ă��܂���? 
select raw_status 
from tweet_ingest;

select raw_status:entities
from tweet_ingest;

select raw_status:entities:hashtags
from tweet_ingest;

// ���̃N�G���́A�e�c�C�[�g�̍ŏ��̃n�b�V���^�O�݂̂�Ԃ��܂�
select raw_status:entities:hashtags[0].text
from tweet_ingest;


 // ���̃o�[�W�����ł́A�n�b�V���^�O���܂܂Ȃ��c�C�[�g���������邽�߂� WHERE ���ǉ����܂�(�������O)
select raw_status:entities:hashtags[0].text
from tweet_ingest
where raw_status:entities:hashtags[0].text is not null;

////created_at �L�[�ɑ΂��ĒP���� CAST �����s���܂��B�c�C�[�g�̍쐬���ŕ��בւ��邽�߂� ORDER BY ���ǉ����܂�
select raw_status :created_at::date 
from tweet_ingest 
order by raw_status:created_at::date;


//flatten �X�e�[�g�����g�̓l�X�g���ꂽ�G���e�B�e�B�݂̂�Ԃ����Ƃ��ł��܂� (��ʃ��x���̃I�u�W�F�N�g�͖�������܂�)
select value
from tweet_ingest
,lateral flatten
(input => raw_status:entities:urls);

//��L�Ɠ��l�̌��ʂƂȂ�܂�
select value
from tweet_ingest
,table(flatten(raw_status:entities:urls));


//�n�b�V���^�O �e�L�X�g�݂̂��t���b�g�����ĕԂ��܂��B�e�L�X�g�� VARCHAR �Ƃ��ăL���X�g���܂��B 
select value:text::varchar as hashtag_used 
from tweet_ingest 
,lateral flatten 
(input => raw_status:entities:hashtags);


//�Ԃ��ꂽ�e�[�u���Ƀc�C�[�g ID �ƃ��[�U�[ ID ��ǉ����āA�n�b�V���^�O�����̃c�C�[�g�Ɍ����ł���悤�ɂ��܂��B
create or replace view urls_normalized as
(select raw_status:user:name::text as user_name
,raw_status:id as tweet_id
,value:display_url::text as url_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:urls)
);


select
*
from urls_normalized;