/*
�ySnowflake��API������GRADER�֐����쐬���āA�����̓_�V�X�e����ݒ肷��菇�z
*/


/*
1. API�������쐬����
�ŏ��ɍs���̂́AAPI�����̍쐬�ł��B
����SQL���́AAWS API Gateway�����Snowflake�ƊO��API�iedu_dora�j
�Ƃ̐ڑ���ݒ肷�邽�߂̂��̂ł��B�ݒ肳�ꂽAPI������L���ɂ��A
�w�肳�ꂽIAM���[�����g�p���āA
�w�肳�ꂽAPI�G���h�|�C���g�ɃA�N�Z�X���邱�Ƃ��ł���悤�ɂȂ�܂��B
����ɂ��ASnowflake����O��API�ɑ΂��ă��N�G�X�g�𑗐M������A
�O��API����̃��X�|���X��Snowflake�ŏ��������肷�邱�Ƃ��\�ɂȂ�܂��B

(�ȉ�command���)
API INTEGRATION: Snowflake��API�������쐬���邽�߂�SQL�X�e�[�g�����g�ł��B
����ɂ��ASnowflake���O��API�ƒʐM���邽�߂̐ݒ���s���܂��B

api_provider: AWS API Gateway ���w��B

api_aws_role_arn: Snowflake��API�ƒʐM���邽�߂�AWS IAM���[��ARN�B

enabled: ���̓������L�����ǂ����iTRUE�ɐݒ�j�B

api_allowed_prefixes: Snowflake����A�N�Z�X�\��API��URL�v���t�B�b�N�X�B
*/

-- ACCOUNTADMIN ���[�����g�p
USE ROLE accountadmin;

-- API �����̍쐬
CREATE OR REPLACE API INTEGRATION dora_api_integration
  API_PROVIDER = 'aws_api_gateway'
  API_AWS_ROLE_ARN = 'arn:aws:iam::321463406630:role/snowflakeLearnerAssumedRole'
  ENABLED = TRUE
  API_ALLOWED_PREFIXES = ('https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora');




/*
2. GRADER�֐����쐬����
����SQL�R�[�h�́AGRADER�֐����쐬���邽�߂̂��̂ł��BGRADER�֐��́A
Snowflake���Ŏ����̓_���s�����߂ɊO��API�Ƀ��N�G�X�g�𑗐M�������

(�ȉ�command���)
CREATE OR REPLACE EXTERNAL FUNCTION:
EXTERNAL FUNCTION: Snowflake�ł́A
�O��API�ƘA�g���邽�߂̊֐����쐬���邱�Ƃ��ł��܂��B
����EXTERNAL FUNCTION���g�����ƂŁASnowflake������O���̃T�[�r�X
�i���̏ꍇ�AAWS API Gateway��ʂ��Ē񋟂����API�j�ɃA�N�Z�X���邱�Ƃ��ł��܂��B

�֐��̈���:
step VARCHAR: �����̃X�e�b�v������������^�̈����B

actual BOOLEAN: ���ۂ̌��ʁi�^�U�l�j�����������B

actual_int INT: ���ۂ̐��l�i�����^�j�����������B

expected_int INT: ���҂���錋�ʂ̐��l�i�����^�j�����������B

description VARCHAR: ����������������^�̈����B

RETURNS VARIANT:
���̊֐���VARIANT�^�̃f�[�^��Ԃ��܂��B
VARIANT��Snowflake�Ŏg����_��ȃf�[�^�^�ŁAJSON�₻�̑��̃f�[�^�`�����i�[�ł��܂��B
�O��API����Ԃ���郌�X�|���X�͗l�X�Ȍ`�������\�������邽�߁A
VARIANT�^�Ŏ󂯎��܂�

API_INTEGRATION = dora_api_integration:
API_INTEGRATION�ŁA��قǍ쐬����API�����idora_api_integration�j���w�肵�Ă��܂��B
����ɂ��ASnowflake���O��API�ɃA�N�Z�X����ۂ̐ݒ���w�����܂��B

CONTEXT_HEADERS = (CURRENT_TIMESTAMP, CURRENT_ACCOUNT, CURRENT_STATEMENT, CURRENT_ACCOUNT_NAME):
CONTEXT_HEADERS�ł́A���N�G�X�g�Ɋ֘A��������w�b�_�[�Ƃ��đ��M���܂��B
�����ł́A����4�̃R���e�L�X�g�����܂߂Ă��܂��F
CURRENT_TIMESTAMP: ���݂̃^�C���X�^���v�i���N�G�X�g�𑗐M���������j
CURRENT_ACCOUNT: ���݂̃A�J�E���gID
CURRENT_STATEMENT: ���ݎ��s����SQL�X�e�[�g�����g
CURRENT_ACCOUNT_NAME: ���݂̃A�J�E���g��

URL = 'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/grader':
���̕����ł́A���N�G�X�g�𑗐M����API�G���h�|�C���g��URL���w�肵�Ă��܂��B
����URL�́AAWS API Gateway����Ē񋟂����API�̃G���h�|�C���g�ŁA
/dev/edu_dora/grader�Ƃ����p�X���܂܂�Ă��܂��B
����ɂ��Agrader�֐��͂���URL�ɑ΂���HTTP���N�G�X�g�𑗐M���A
�O��API�̌��ʂ��󂯎��܂��B
*/

-- ACCOUNTADMIN ���[�����g�p
USE ROLE accountadmin;

-- GRADER �֐��̍쐬
CREATE OR REPLACE EXTERNAL FUNCTION util_db.public.grader(
      step VARCHAR
    , passed boolean
    , actual integer
    , expected integer
    , description varchar)
  RETURNS VARIANT
  API_INTEGRATION = dora_api_integration
  CONTEXT_HEADERS = (CURRENT_TIMESTAMP, CURRENT_ACCOUNT, CURRENT_STATEMENT, CURRENT_ACCOUNT_NAME)
  URL = 'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/grader';


-- GRADER�֐����g�p���āA����m�F���s��
SELECT 
    grader(step, 
           (actual = expected), 
           actual, 
           expected, 
           description) AS graded_results 
FROM
(
  -- �e�X�g�f�[�^��I�����AGRADER�֐��ɓn��
  SELECT 
    'DORA_IS_WORKING' AS step,       -- �X�e�b�v���i�e�X�g�p�̖��O�j
    (SELECT 123) AS actual,          -- ���ۂ̌��ʁi�����ł͒P�ɐ���123��Ԃ��j
    123 AS expected,                 -- ���҂���錋�ʁi������123�j
    'Dora is working!' AS description -- �����i����m�F�̃��b�Z�[�W�j
);



-- ���̃X�L�[�}�ō�Ƃ��Ă����ꍇ�͈ȉ��Ń��l�[�����邱��
ALTER FUNCTION GARDEN_PLANTS.VEGGIE.GRADER RENAME TO UTIL_DB.PUBLIC.GRADER 