-- ACCOUNTADMIN ロールを使用
USE ROLE accountadmin;


-- API 統合の作成
CREATE OR REPLACE API INTEGRATION dora_api_integration
  API_PROVIDER = 'aws_api_gateway'
  API_AWS_ROLE_ARN = 'arn:aws:iam::321463406630:role/snowflakeLearnerAssumedRole'
  ENABLED = TRUE
  API_ALLOWED_PREFIXES = ('https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/grader');


-- GRADER 関数の作成
create or replace external function util_db.public.grader(
      step varchar
    , passed boolean
    , actual integer
    , expected integer
    , description varchar)
returns variant
api_integration = dora_api_integration 
context_headers = (current_timestamp, current_account, current_statement, current_account_name) 
as 'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/grader'
;

-- 作成した関数の確認
show user functions in account;

-- 関数の検索をする
select * 
from util_db.information_schema.functions 
where function_name = 'GRADER' 
and function_catalog = 'UTIL_DB' 
and function_owner = 'ACCOUNTADMIN';


-- SYSADMINにもGRANDER関数の権限を付与
grant usage 
on function UTIL_DB.PUBLIC.GRADER(VARCHAR, BOOLEAN, NUMBER, NUMBER, VARCHAR) 
to SYSADMIN;

-- GRADERチェック1
select GRADER(step,(actual = expected), actual, expected, description) as graded_results from (
SELECT 'DORA_IS_WORKING' as step
 ,(select 223 ) as actual
 ,223 as expected
 ,'Dora is working!' as description
); 


