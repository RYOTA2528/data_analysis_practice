
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

CREATE OR REPLACE STAGE HOL_DATA
  url = 's3://snowflake-corp-se-workshop/VHOL_Iceberg_SNOW_AWS/data/';
  
CREATE OR REPLACE TABLE CUSTOMER(
	FULLNAME VARCHAR(250),
	POSTCODE VARCHAR(250),
	CUSTID VARCHAR(32),
	IPID NUMBER(18,0),
	PRODUCTNAME VARCHAR(100),
	DOB VARCHAR(50),
	AGE_BUCKET VARCHAR(16777216),
	ADDRESS VARCHAR(250),
	FIRSTNAME VARCHAR(250),
	LASTNAME VARCHAR(250),
	EMAIL VARCHAR(511),
	PHONENUMBER VARCHAR(250),
	SEX VARCHAR(1),
	QUOTECOUNT NUMBER(18,0)
);


COPY INTO CUSTOMER FROM @HOL_SATA/customer FILE_FORMAT = (TYPE = PARQUET)
 MATCH_BY_COLUMN_NAME=CASE_INSENSITIVE; --ファイルの列名とテーブル列名のマッチにおいて、大文字小文字を区別しないようにする


CREATE OR REPLACE TABLE POLICIES (
	POLICY_ID NUMBER(38,0),
	CUSTID VARCHAR(32),
	POLICY_BATCHID VARCHAR(32),
	POLICYNUMBER VARCHAR(150),
	UUID VARCHAR(250),
	CREATEDDATE DATE,
	BRAND VARCHAR(50),
	PREVIOUSPOLICYNUMBER VARCHAR(150),
	BRANCHCODE VARCHAR(20),
	POLICY_STATUS_DESC VARCHAR(20),
	TYPEOFCOVER_DESC VARCHAR(50),
	INSURER_CODE VARCHAR(20),
	INSURER_NAME VARCHAR(20),
	SCHEME_CODE VARCHAR(20),
	SCHEME_NAME VARCHAR(50),
	INCEPTIONDATE DATE,
	RENEWALDATE DATE,
	CANCELLATIONDATE DATE,
	EXPIRYDATE DATE,
	ENDDATE DATE,
	VOLUNTARY_EXCESS NUMBER(38,4),
	PREMIUM NUMBER(38,4),
	POLICYTYPE_DESC VARCHAR(50),
	FREQUENCY_DESC VARCHAR(50),
	PAYMETHOD_DESC VARCHAR(30),
	SOURCECM_DESC VARCHAR(50),
	COMMISSIONRATE VARCHAR(20),
	CURRENTRESULT_ID NUMBER(38,0),
	CURRENTRISK_ID NUMBER(38,0),
	SOURCE VARCHAR(50)
);

 COPY INTO POLICIES FROM @HOL_DATA/policies/ FILE_FORMAT = (TYPE = PARQUET)
 MATCH_BY_COLUMN_NAME=CASE_INSENSITIVE;
