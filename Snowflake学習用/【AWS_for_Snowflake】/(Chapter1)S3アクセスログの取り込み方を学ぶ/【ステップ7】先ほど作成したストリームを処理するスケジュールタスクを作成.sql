// ��قǍ쐬�����X�g���[������������X�P�W���[���^�X�N���쐬

create or replace task s3_access_logs_transformation
warehouse = security_quickstart
schedule = '10 minute'  -- 10�����ƂɎ������s�icron�`����1���Ԃ��Ƃ�OK�j
when
system$stream_has_data('s3_access_logs_stream')
as
insert into s3_acess_logs(
 select parsed_logs.*
 from s3_access_logs_stream
 join table(parse_s3_access_logs(s3_access_logs_stream.raw)) parsed_logs --parse_s3_access_logs() �֐��ō\����
 where s3_access_logs_stream.metadata$action = 'INSERT' --�V�����}�����ꂽ�f�[�^������Ώۂɂ���
);
