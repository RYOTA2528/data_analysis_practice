// �f�[�^����M���邽�߂�Snowflake����������

-- 1���ԑ��삪�Ȃ��ƒ�~���钆�K�͂̒P��N���X�^�[�E�F�A�n�E�X���쐬
create warehouse security_quickstart with 
  WAREHOUSE_SIZE = MEDIUM 
  AUTO_SUSPEND = 60;
  
  
-- ��͂���Ă��Ȃ����O���C���|�[�g���邽�߂̃t�@�C���`�����쐬
CREATE FILE FORMAT IF NOT EXISTS TEXT_FORMAT
TYPE = 'CSV'
FIELD_DELIMITER = NONE --��؂蕶�����g��Ȃ��i','�������j
SKIP_BLANK_LINES = TRUE --��s�̓X�L�b�v����
ESCAPE_UNENCLOSED_FIELD = NONE; --�͂܂�Ă��Ȃ��t�B�[���h���̃G�X�P�[�v�����𖳌��ɂ���