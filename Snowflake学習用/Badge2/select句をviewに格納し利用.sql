-- select���view�ɕϊ�����
create or replace view intl_db.public.NATIONS_SAMPLE_PLUS_ISO
(
    iso_country_name, -- ISO����
    country_name_official, -- ��������
    alpha_code_2digit, -- 2���̃A���t�@�x�b�g�R�[�h
    region -- �n�於
) AS 
select
    iso_country_name, -- ISO����
    country_name_official, -- ��������
    alpha_code_2digit, -- 2���̃A���t�@�x�b�g�R�[�h
    r_name as region -- �n�於�iREGION�e�[�u������j
from INTL_DB.PUBLIC.INT_STDS_ORG_3166 i
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION n
    on upper(i.iso_country_name) = n.n_name -- ISO������NATION�e�[�u���̍�������v������
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION r
    on n.n_regionkey = r.r_regionkey; -- NATION�e�[�u���̒n��L�[��REGION�e�[�u���̒n��L�[�ƈ�v������


select *
from intl_db.public.NATIONS_SAMPLE_PLUS_ISO;