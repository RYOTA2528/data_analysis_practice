
//【Snowflakeアカウント設定】//
--（ロールの設定）
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
次に、パブリックな S3 バケットから Snowflake にデータをロードします。
顧客データとポリシーデータを Snowflake にロードし、
社内データセットをシミュレートします。
----------------------------------------------------------------*/

USE HOL_ICE_DB.PUBLIC;

USE WAREHOUSE HOL_ICE_WH;
