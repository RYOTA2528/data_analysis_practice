use role accountadmin;

create warehouse pc_dbt_wh_large with warehouse_size = large;
 
grant all on warehouse pc_dbt_wh_large to role pc_dbt_role;