-- �ʉݏ����i�[����e�[�u���̍쐬
create table intl_db.public.CURRENCIES 
(
  currency_ID integer, 
  currency_char_code varchar(3), 
  currency_symbol varchar(4), 
  currency_digital_code varchar(3), 
  currency_digital_name varchar(30)
)
  comment = 'Information about currencies including character codes, symbols, digital codes, etc.';

-- ���ƒʉ݂̃}�b�s���O�e�[�u���̍쐬
  create table intl_db.public.COUNTRY_CODE_TO_CURRENCY_CODE 
  (
    country_char_code varchar(3), 
    country_numeric_code integer, 
    country_name varchar(100), 
    currency_name varchar(100), 
    currency_char_code varchar(3), 
    currency_numeric_code integer
  ) 
  comment = 'Mapping table currencies to countries';


   create file format util_db.public.CSV_COMMA_LF_HEADER
  type = 'CSV' 
  field_delimiter = ',' 
  record_delimiter = '\n' -- the n represents a Line Feed character
  skip_header = 1 
;


-- aws_s3_bucket�X�e�[�W�̒��g���m�F
 list @aws_s3_bucket;


 -- ICURRENCIES�e�[�u���Ƀf�[�^�����[�h����
 copy into intl_db.public.CURRENCIES
 from @aws_s3_bucket
 files = ( 'currencies.csv')
 file_format = (format_name = 'CSV_COMMA_LF_HEADER');

  -- COUNTRY_CODE_TO_CURRENCY_CODE�Ƀf�[�^�����[�h����
 copy into intl_db.public.COUNTRY_CODE_TO_CURRENCY_CODE
 from @aws_s3_bucket
 files = ( 'country_code_to_currency_code.csv')
 file_format = (format_name = 'CSV_COMMA_LF_HEADER');

 
select
*
from intl_db.public.CURRENCIES;

desc table intl_db.public.CURRENCIES;

select
*
from intl_db.public.COUNTRY_CODE_TO_CURRENCY_CODE;

desc table intl_db.public.COUNTRY_CODE_TO_CURRENCY_CODE;




-- ���ۂ�2�̃e�[�u����LEFT JOIN�����r���[���쐬���Ă݂�
create or replace view intl_db.public.simple_currency(
 CTY_CODE,
 CUR_CODE
) AS
select
t1.COUNTRY_CHAR_CODE,
t1.CURRENCY_CHAR_CODE
from intl_db.public.COUNTRY_CODE_TO_CURRENCY_CODE as t1
left join intl_db.public.CURRENCIES as t2
on t1.CURRENCY_CHAR_CODE = t2.CURRENCY_CHAR_CODE;


select * from intl_db.public.simple_currency;