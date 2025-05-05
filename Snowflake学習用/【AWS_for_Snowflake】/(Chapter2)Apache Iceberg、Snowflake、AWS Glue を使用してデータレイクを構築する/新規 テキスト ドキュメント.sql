/* ---------------------------------------------------------------------------
�܂��ASQL �����s���邽�߂̃R���e�L�X�g�i���[���A�f�[�^�x�[�X�A�E�F�A�n�E�X�j��ݒ肵�܂��B
----------------------------------------------------------------------------*/

USE ROLE HOL_ICE_RL;

USE HOL_ICE_DB.PUBLIC;

USE WAREHOUSE HOL_ICE_WH;


/* ---------------------------------------------------------------------------
�O���{�����[���� Glue �J�^���O�����̐ݒ�  
----------------------------------------------------------------------------*/

CREATE OR REPLACE EXTERNAL VOLUME HOL_ICE_EXT_VOL
   STORAGE_LOCATIONS =
      (
         (
            NAME = 'my-s3-ice-ext-vol',
            STORAGE_PROVIDER = 'S3',
            STORAGE_BASE_URL = 's3://<���Ȃ��� S3 �o�P�b�g��>/iceberg/',
            STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<���Ȃ��� AWS �A�J�E���g ID>:role/<�쐬�������[����>'
         )
      );

// AWS�A�J�E���g���[���Ƃ̐M���֌W��ݒ�
-- �O���{�����[���̒�`���m�F
DESC EXTERNAL VOLUME HOL_ICE_EXT_VOL;


STORAGE_LOCATIONS�o�͍s�ɂ́A ���̂悤��JSON�`���̃v���p�e�B�l������܂��B

{"NAME":"my-s3-ice-ext-vol",
"STORAGE_PROVIDER":"S3",
"STORAGE_BASE_URL":"s3://glue-snowflake-devday-lab-6546xxxxxxxx/iceberg/",
"STORAGE_ALLOWED_LOCATIONS":["s3://glue-snowflake-lab-6546xxxxxxxx/iceberg/*"],
"STORAGE_AWS_ROLE_ARN":"arn:aws:iam::65465xxxxxxx:role/glue-snowflake-GluesnowflakedevdayLabRole-crOqCT36mDB4",
"STORAGE_AWS_IAM_USER_ARN":"arn:aws:iam::90541xxxxxxxxxx:user/vvyk0000-s",
"STORAGE_AWS_EXTERNAL_ID":"YJB50193_SFCRole=2_f1IsD5b8/DAFxxxxxxxxxxxx",
"ENCRYPTION_TYPE":"NONE",
"ENCRYPTION_KMS_KEY_ID":""}

/*
  - �쐬�ς݂� S3 �o�P�b�g���� STORAGE_BASE_URL �ɓ���
  - AWS �A�J�E���g ID �� STORAGE_AWS_ROLE_ARN �ɓ���
  - �쐬���� IAM ���[���� ARN �� STORAGE_AWS_ROLE_ARN �ɓ���
-------------------------------------------------------------------------*/

-- �� Snowflake �� IAM ���[�U�[ ARN �� External ID ���g���āAAWS IAM ���[���̐M���|���V�[���X�V���Ă�������
/*�y�ȉ��菇�Ŏ��{�z*/
�u�M���֌W�v�^�u���N���b�N��
AWS IAM�ɂāu�M���|���V�[�̕ҏW�v���N���b�N���܂��B��ق�Snowflake��Ŋm�F�����l���ȉ���<>�ɓK�X����Ȃ���ҏW
��
�����̎��_�ł͇@�A�܂ł̓��́�
/*
{
  "Version": "2012-10-17",
  "Statement": [

    // �@ Glue �T�[�r�X�iAWS Glue�j�����̃��[���������󂯉\�ɂ���ݒ�
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },

    // �A Snowflake �̃X�g���[�W�����p IAM ���[�U�[�� AssumeRole �\�ɂ���ݒ�
    // Snowflake ���� EXTERNAL VOLUME ���쐬���邽�߂Ɏg�p�����
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "<snowflake storage arn>"  // Snowflake ���񋟂��� IAM ���[�U�[ ARN�i�X�g���[�W�����p�j
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<snowflake external id ext volume>"  // Snowflake �����w�肷�� External ID�i�Z�L�����e�B�΍�j
        }
      }
    },

    // �B Snowflake �� Glue �J�^���O�����p IAM ���[�U�[�� AssumeRole �\�ɂ���ݒ�
    // Snowflake ���� AWS Glue �ɂ��� Iceberg �e�[�u�����փA�N�Z�X���邽�߂Ɏg�p�����
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "<snowflake glue arn>"  // Snowflake ���񋟂��� IAM ���[�U�[ ARN�iGlue �J�^���O�����p�j
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<snowflake external id glue catalog>"  // Snowflake �����w�肷�� External ID�iGlue �����p�j
        }
      }
    }

  ]
}
*/


-- Glue �J�^���O�ݒ�
-- AWS ���� Glue �J�^���O�p�̃|���V�[�� IAM ���[�����쐬���Ă�������

/* �� ���̃Z�N�V�����ɂ͂����g�̏�����͂��Ă��������F
   - AWS �A�J�E���g ID �� GLUE_AWS_ROLE_ARN �ɓ���
   - �쐬���� IAM ���[���� ARN �� STORAGE_AWS_ROLE_ARN �ɓ���
   - AWS Glue �J�^���O ID �� GLUE_CATALOG_ID �ɓ���
-------------------------------------------------------------------------*/

CREATE or REPLACE CATALOG INTEGRATION HOL_ICE_GLUE_CAT_INT
  CATALOG_SOURCE = GLUE,
  CATALOG_NAMESPACE = 'iceberg', -- Glue�̒���Snowflake���Q�Ƃ���**�f�[�^�x�[�X���iNamespace�j**�ł�
  TABLE_FORMAT = ICEBERG, -- �e�[�u���`���� Apache Iceberg �ł��邱�Ƃ������܂��BSnowflake��Iceberg�`���̃e�[�u�����l�C�e�B�u�ɃT�|�[�g���Ă���A���̎w��Ő��������߂ł��܂��B
  GLUE_AWS_ROLE_ARN = 'arn:aws:iam::<���Ȃ��� AWS �A�J�E���g ID>:role/<�쐬�������[����>',
  GLUE_CATALOG_ID = '<���Ȃ��� AWS �A�J�E���g ID>',
  ENABLED = TRUE;
  
-- �������Snowflake�����炱�̃J�^���O�C���e�O���[�V�����𗘗p���āA
--   Glue���Iceberg�e�[�u���ɑ΂��ăN�G�������s������A���z�f�[�^�x�[�X�Ƃ��ĎQ�Ƃł���悤�ɂȂ�܂��B

-- Glue �J�^���O�����̊m�F
DESC CATALOG INTEGRATION HOL_ICE_GLUE_CAT_INT;

-- �� Snowflake IAM ���[�U�[ ARN �� External ID ���g���āAIAM ���[���̐M���|���V�[���X�V����K�v������܂�

���M���|���V�[�̇B�C�̒��g�̏C��


/* ---------------------------------------------------------------------------
Glue �J�^���O�������g���āA�Ǘ�����Ă��Ȃ� Iceberg �e�[�u�����쐬���܂��B
----------------------------------------------------------------------------*/

CREATE OR REPLACE ICEBERG TABLE QUOTES_ICE
  EXTERNAL_VOLUME = 'HOL_ICE_EXT_VOL',
  CATALOG = 'HOL_ICE_GLUE_CAT_INT',
  CATALOG_TABLE_NAME = 'QUOTES';

-- Iceberg �e�[�u������10���f�[�^���m�F
SELECT * FROM QUOTES_ICE LIMIT 10;


/*---------------------------------------------------------------------------
������ Snowflake �e�[�u���iCUSTOMER, POLICIES�j�� Iceberg �e�[�u���iQUOTES_ICE�j��
�������ĕ��͂ł���悤�ɂȂ�܂��B
-----------------------------------------------------------------------------*/

-- ���ς��肪5���𒴂���ڋq�����ς�����ƌ�������

SELECT C.FULLNAME, C.POSTCODE, C.CUSTID, C.IPID, C.PRODUCTNAME, C.QUOTECOUNT,
       Q.POLICYNO, Q.QUOTEDATE, Q.QUOTE_PRODUCT, Q.ORIGINALPREMIUM, Q.TOTALPREMIUMPAYABLE 
FROM CUSTOMER C, QUOTES_ICE Q
WHERE C.FULLNAME = Q.FULLNAME
  AND C.POSTCODE = Q.POSTCODE
  AND C.QUOTECOUNT > 5
ORDER BY C.QUOTECOUNT DESC;


-- ���ς���ƌڋq���ɉ����āA�|���V�[�f�[�^���������邱�ƂŁA
-- �ڋq���ǂ�ȃ|���V�[���ǂ�Ȍ��ς���Ŏ擾���Ă���̂������ڍׂɕ��͂ł��܂��B

WITH CUSTQUOTE AS (
  SELECT C.FULLNAME, C.POSTCODE, C.CUSTID, C.IPID, C.PRODUCTNAME, C.QUOTECOUNT,
         Q.POLICYNO, Q.QUOTEDATE, Q.QUOTE_PRODUCT, Q.ORIGINALPREMIUM, Q.TOTALPREMIUMPAYABLE 
  FROM CUSTOMER C, QUOTES_ICE Q
  WHERE C.FULLNAME = Q.FULLNAME
    AND C.POSTCODE = Q.POSTCODE
    AND C.QUOTECOUNT > 5
)
SELECT CQ.FULLNAME, CQ.POSTCODE, CQ.CUSTID, CQ.IPID, CQ.PRODUCTNAME,
       CQ.QUOTECOUNT, CQ.POLICYNO, CQ.QUOTEDATE, CQ.QUOTE_PRODUCT,
       CQ.ORIGINALPREMIUM, CQ.TOTALPREMIUMPAYABLE, 
       P.CREATEDDATE, P.BRAND, P.BRANCHCODE, P.POLICY_STATUS_DESC,
       P.TYPEOFCOVER_DESC, P.INSURER_NAME, P.INCEPTIONDATE, P.RENEWALDATE
FROM CUSTQUOTE CQ, POLICIES P
WHERE CQ.CUSTID = P.CUSTID;


/*
Snowflake, Glue�A�܂��� Iceberg ���T�|�[�g���鑼�̃G���W��������g�p�\�ȁA
�Ǘ����ꂽ Iceberg �e�[�u�����쐬���܂��iS3�ɕۑ������j�B
*/

CREATE OR REPLACE ICEBERG TABLE QUOTE_ANALYSIS_ICE  
  CATALOG = 'SNOWFLAKE',
  EXTERNAL_VOLUME = 'HOL_ICE_EXT_VOL',
  BASE_LOCATION = 'quoteanalysisiceberg'
AS 
WITH CUSTQUOTE AS (
  SELECT C.FULLNAME, C.POSTCODE, C.CUSTID, C.IPID, C.PRODUCTNAME, C.QUOTECOUNT,
         Q.POLICYNO, Q.QUOTEDATE, Q.QUOTE_PRODUCT, Q.ORIGINALPREMIUM, Q.TOTALPREMIUMPAYABLE 
  FROM CUSTOMER C, QUOTES_ICE Q
  WHERE C.FULLNAME = Q.FULLNAME
    AND C.POSTCODE = Q.POSTCODE
    AND C.QUOTECOUNT > 5
)
SELECT CQ.FULLNAME, CQ.POSTCODE, CQ.CUSTID, CQ.IPID, CQ.PRODUCTNAME,
       CQ.QUOTECOUNT, CQ.POLICYNO, CQ.QUOTEDATE, CQ.QUOTE_PRODUCT,
       CQ.ORIGINALPREMIUM, CQ.TOTALPREMIUMPAYABLE, 
       P.CREATEDDATE, P.BRAND, P.BRANCHCODE, P.POLICY_STATUS_DESC,
       P.TYPEOFCOVER_DESC, P.INSURER_NAME, P.INCEPTIONDATE, P.RENEWALDATE
FROM CUSTQUOTE CQ, POLICIES P
WHERE CQ.CUSTID = P.CUSTID;


-- Snowflake ��� Iceberg �e�[�u�����g���ĕ���
SELECT DISTINCT CUSTID, FULLNAME, POSTCODE, IPID, PRODUCTNAME, QUOTECOUNT,
       POLICYNO, QUOTEDATE, QUOTE_PRODUCT, ORIGINALPREMIUM, TOTALPREMIUMPAYABLE,
       CREATEDDATE, BRAND, BRANCHCODE, POLICY_STATUS_DESC, TYPEOFCOVER_DESC,
       INSURER_NAME, INCEPTIONDATE, RENEWALDATE
FROM QUOTE_ANALYSIS_ICE
WHERE TOTALPREMIUMPAYABLE > 100
  AND POLICY_STATUS_DESC = 'Renewed'
ORDER BY CREATEDDATE DESC;