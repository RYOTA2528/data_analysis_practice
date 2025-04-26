-- �ǂ̃��[�U�[���ǂ̃I�u�W�F�N�g���폜�������𒲍�����  
SELECT RequestDateTime, RemoteIP, Requester, Key 
FROM s3_access_logs_db.mybucket_logs 
WHERE key = 'path/to/object' AND operation like '%DELETE%';


-- �v�������������� IP �A�h���X���W�v����  
select count(*),REMOTEIP 
from s3_access_logs group by remoteip order by count(*) desc;


-- IP���Ƃ̒ʐM�ʁi�A�b�v���[�h�E�_�E�����[�h�j���W�v����  
SELECT 
    remoteip,
    SUM(bytessent) AS uploadTotal,          -- �A�b�v���[�h���ꂽ�o�C�g���̍��v
    SUM(objectsize) AS downloadTotal,       -- �_�E�����[�h���ꂽ�I�u�W�F�N�g�T�C�Y�̍��v
    SUM(ZEROIFNULL(bytessent) + ZEROIFNULL(objectsize)) AS Total -- ���v�ʐM��
FROM s3_access_logs
group by REMOTEIP
order by total desc;


-- �A�N�Z�X���ہi403 �G���[�j�������������N�G�X�g��\������  
SELECT * FROM s3_access_logs WHERE httpstatus = '403';


-- ����̃��[�U�[�ɂ�邷�ׂĂ̑����\������  
SELECT * 
FROM s3_access_logs_db.mybucket_logs 
WHERE requester='arn:aws:iam::123456789123:user/user_name';


-- �������[�U�[�i���F�؁j�ɂ�郊�N�G�X�g��\������  
SELECT *
FROM s3_access_logs
WHERE Requester IS NULL;