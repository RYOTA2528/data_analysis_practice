-- �e�[�u�� INT_STDS_ORG_3166���쐬


create or replace table intl_db.public.INT_STDS_ORG_3166 
(iso_country_name varchar(100), -- ������ISO�\�L�i�ő�100�����j
 country_name_official varchar(200), -- �����ȍ����i�ő�200�����j
 sovreignty varchar(40), -- �匠�i�ő�40�����j
 alpha_code_2digit varchar(2), -- 2���̃A���t�@�x�b�g�R�[�h�i�ő�2�����j
 alpha_code_3digit varchar(3), -- 3���̃A���t�@�x�b�g�R�[�h�i�ő�3�����j
 numeric_country_code integer, -- �����ɂ�鍑�R�[�h�i�����^�j
 iso_subdivision varchar(15),   -- ISO�T�u�f�B�r�W�����i�ő�15�����j
 internet_domain_code varchar(10) -- �C���^�[�l�b�g�̍��ʃh���C���R�[�h�i�ő�10�����j
);


-- �e�[�u����ǂݍ��ނ��߂̃t�@�C���`�����쐬����
create or replace file format PIPE_DBLQUOTE_HEADER_CR 
  type = 'CSV' ---- ���k�����������ݒ�
  compression = 'AUTO' 
  field_delimiter = '|' 
  record_delimiter = '\r' -- ���R�[�h�̋�؂蕶���Ƃ��ăL�����b�W���^�[���i\r�j���g�p
  skip_header = 1  
  field_optionally_enclosed_by = '\042'  -- �t�B�[���h�̓_�u���N�I�[�g�i"�j�ň͂܂��ꍇ������
  trim_space = FALSE;�@-- �t�B�[���h�̑O��̃X�y�[�X���g���~���O�i�폜�j���Ȃ��ݒ�ł�


  // �f�[�^�t�@�C����S3����擾���� //

-- drop stage intl_db.public.aws_s3_bucket;

create stage util_db.public.aws_s3_bucket url = 's3://uni-cmcw';

  -- �X�e�[�W�m�F
  show stages in account;

-- aws_s3_bucket�X�e�[�W�̒��g���m�F
 list @aws_s3_bucket;


 -- INT_STDS_ORG_3166�e�[�u���Ƀf�[�^�����[�h����
 copy into intl_db.public.INT_STDS_ORG_3166
 from @aws_s3_bucket
 files = ( 'ISO_Countries_UTF8_pipe.csv')
 file_format = (format_name = 'PIPE_DBLQUOTE_HEADER_CR')