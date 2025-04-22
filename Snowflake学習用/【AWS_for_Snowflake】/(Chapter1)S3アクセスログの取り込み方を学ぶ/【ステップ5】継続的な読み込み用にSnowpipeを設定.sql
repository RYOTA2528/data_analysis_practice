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
  
  
  
// Amazon S3 �R���\�[�����g�p���ăC�x���g�ʒm��L���ɂ��Đݒ肷��
/*
�^�[�Q�b�g�o�P�b�g -> �v���p�e�B���J�� -> �u�C�x���g�ʒm�̍쐬�v��I��
�ȉ��̍��ڂɂ��L����������

���O: �C�x���g�ʒm�̖��O (��: Auto-ingest Snowflake)�B
�v���t�B�b�N�X (�I�v�V����): ����̃t�H���_�[ (��: logs/) �Ƀt�@�C�����ǉ����ꂽ�ꍇ�ɂ̂ݒʒm����M����ꍇ�B
�C�x���g: ObjectCreate (���ׂ�) �I�v�V������I�����܂��B
���M��: �h���b�v�_�E�����X�g����uSQS �L���[�v��I�����܂��B
SQS: �h���b�v�_�E�����X�g����uSQS �L���[ ARN �̒ǉ��v��I�����܂��B
SQS �L���[ ARN: SHOW PIPES �o�͂��� SQS �L���[����\��t���܂��B
��
�C�x���g�ʒm���쐬����܂���
*/

