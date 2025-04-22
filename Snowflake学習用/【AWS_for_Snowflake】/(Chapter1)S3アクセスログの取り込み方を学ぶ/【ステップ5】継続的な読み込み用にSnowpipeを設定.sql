// Snowflake Snowpipe���\������
create pipe public.s3_access_logs_pipe auto_ingest=true as
  copy into s3_access_logs_staging from (
    SELECT
      STG.$1,
      current_timestamp() as timestamp
    FROM @s3_access_logs (FILE_FORMAT => TEXT_FORMAT) STG
  );
  
  
// �����f�[�^��荞�݁iSnowpipe�j�Ɋ֘A����p�C�v�̈ꗗ���\������܂��B
-- ���̒��ɂ́ASQS�A�g�ȂǂŕK�v�ɂȂ� SQS�L���[ ARN ���܂܂�Ă��܂��B
-- notification_channel SQS�L���[�� ARN�i�A�g�p�j
-- ���� ARN ���g���āAS3 �� SQS �� Snowpipe �̘A�g�ݒ�� AWS ���ɑg�ݍ��݂܂��i�C�x���g�ʒm�̑��M��Ƃ��āj
  SHOW PIPES;
  