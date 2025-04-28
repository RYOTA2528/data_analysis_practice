
//�ySnowflake�A�J�E���g�ݒ�z//
--�i���[���̐ݒ�j
USE ROLE SECURITYADMIN;

CREATE OR REPLACE ROLE HOL_ICE_RL COMMENT='Iceberg Role';
GRANT ROLE HOL_ICE_RL TO ROLE SYSADMIN;

USE ROLE ACCOUNTADMIN;

GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE HOL_ICE_RL;
GRANT CREATE EXTERNAL VOLUME ON ACCOUNT TO ROLE HOL_ICE_RL;


CREATE OR REPLACE WAREHOUSE HOL_ICE_WH
 WITH WAREHOUSE_SIZE = 'XSMALL'
 INTIALLY_SUSPENDED = TRUE;
 
 
/*------------------------------------------------------------
���ɁA�p�u���b�N�� S3 �o�P�b�g���� Snowflake �Ƀf�[�^�����[�h���܂��B
�ڋq�f�[�^�ƃ|���V�[�f�[�^�� Snowflake �Ƀ��[�h���A
�Г��f�[�^�Z�b�g���V�~�����[�g���܂��B
----------------------------------------------------------------*/

USE HOL_ICE_DB.PUBLIC;

USE WAREHOUSE HOL_ICE_WH;
