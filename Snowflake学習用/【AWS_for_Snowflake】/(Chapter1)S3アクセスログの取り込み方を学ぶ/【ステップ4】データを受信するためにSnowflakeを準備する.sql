// �f�[�^����M���邽�߂�Snowflake����������

-- 1���ԑ��삪�Ȃ��ƒ�~���钆�K�͂̒P��N���X�^�[�E�F�A�n�E�X���쐬
create warehouse security_quickstart with 
  WAREHOUSE_SIZE = MEDIUM 
  AUTO_SUSPEND = 60;
  
  
-- ��͂���Ă��Ȃ����O���C���|�[�g���邽�߂̃t�@�C���`�����쐬
CREATE FILE FORMAT IF NOT EXISTS TEXT_FORMAT
TYPE = 'CSV'
FIELD_DELIMITER = NONE --��؂蕶�����g��Ȃ��i','�������j
SKIP_BLANK_LINES = TRUE --��s�̓X�L�b�v����
ESCAPE_UNENCLOSED_FIELD = NONE; --�͂܂�Ă��Ȃ��t�B�[���h���̃G�X�P�[�v�����𖳌��ɂ���


-- �X�g���[�W�������g�p���O���X�e�[�W���쐬
create stage s3_access_logs
  url = 's3://<BUCKET_NAME>/<PREFIX>/' --STORAGE INTEGRATION �ŋ����� STORAGE_ALLOWED_LOCATIONS �ƈ�v���Ă���K�v������܂��B�Y���Ă�ƃG���[�ɂȂ�܂�
  storage_integration = s3_int_s3_access_logs --�ȑO CREATE STORAGE INTEGRATION �ō쐬�������������w��B����� IAM ���[���Ƃ̐ڑ����g�p
;

-- �O���X�e�[�W�̒��g���m�F
LIST @s3_access_logs;


-- (���܂�)�f�[�^�������o���iSnowflake �� S3�j���@
COPY INTO @s3_access_logs/my_output.csv
FROM my_table
FILE_FORMAT = (TYPE = CSV);


-- ���̃��O��ۑ�����e�[�u�����쐬
create or replace table s3_access_logs_staging(
  raw TEXT,
  timestamp DATETIME
);

