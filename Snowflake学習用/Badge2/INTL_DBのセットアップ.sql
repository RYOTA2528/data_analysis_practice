-- INTL_DB��PUBLIC�X�L�[�}�̎g�p

use role SYSADMIN;

create database INTL_DB;

use schema INTL_DB.PUBLIC;


-- INTL_DB �����[�h���邽�߂̃E�F�A�n�E�X���쐬����

create warehouse INTL_WH
with
warehouse_size = 'XSMALL'
warehouse_type = 'STANDARD'
auto_suspend = 600 -- 10���i600�b�j�Ԏg�p����Ȃ������ꍇ�Ɏ����ŃT�X�y���h�i��~�j�����
AUTO_RESUME = TRUE;  -- �E�F�A�n�E�X����~���Ă����ԂŃ��N�G�X�g������ƁA�����I�ɍĊJ�����

use warehouse INTL_WH;