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

