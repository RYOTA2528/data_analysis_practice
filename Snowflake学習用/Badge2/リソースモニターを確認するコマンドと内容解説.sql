SHOW RESOURCE MONITORS IN ACCOUNT; 

-- �́A���݂� Snowflake �A�J�E���g���ɐݒ肳��Ă��� ���\�[�X���j�^�[�̈ꗗ��\������SQL�R�}���h�ł��B

/*
? ���̃R�}���h�Ŋm�F�ł�����
���s����ƁA���̂悤�ȃJ�������܂܂ꂽ���ʂ��Ԃ��Ă��܂��F

name	credit_quota	frequency	start_time	end_time	notify_users	triggers	warehouses
DAILY_3_CREDIT_LIMIT	3	DAILY	00:00	23:59	[admin@example.com]	ON 100% DO SUSPEND	COMPUTE_WH
? �p�r
���j�^�[���A�N���W�b�g�����A�K�p�͈́i�f�C���[�A�E�B�[�N���[�Ȃǁj���m�F�B

�e���j�^�[���R�Â��Ă���E�F�A�n�E�X��A�g���K�[�̓��e�i��F100%���B����SUSPEND�j���`�F�b�N�\�B

����̃��j�^�[�������ŃE�F�A�n�E�X����~���Ă��邩��c������̂ɖ𗧂��܂��B
*/

--�y���\�[�X���j�^�[���쐬�z--
CREATE RESOURCE MONITOR daily_monitor
  WITH CREDIT_QUOTA = 5
  FREQUENCY = DAILY
  TRIGGERS ON 100 PERCENT DO SUSPEND; -- �N���W�b�g�̎g�p�ʂ� 100%�i=5�N���W�b�g�j�ɒB�������_�ŁA�R�Â��Ă���E�F�A�n�E�X���~�iSUSPEND�j ����

--�y���\�[�X���j�^�[�̏�����ύX����z--
ALTER RESOURCE MONITOR daily_monitor SET CREDIT_QUOTA = 10;

--�y���\�[�X���j�^�[���폜����z--
DROP RESOURCE MONITOR daily_monitor;



