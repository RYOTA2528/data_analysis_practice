// FLATTEN �́A�l�X�g���ꂽJSON�f�[�^�����X�g�Ƃ��ēW�J���A�e�v�f��Ɨ������s�Ƃ��ďo�͂��邽�߂Ɏg�p���܂�
select value: 
first_name 
from 
nested_ingest_json 
,lateral flatten(input => raw_nested_book:authors) ;

// TABLE �֐��́AFLATTEN �̌��ʂ��e�[�u���Ƃ��Ĉ������߂Ɏg�p���܂��B����ɂ��A�e���҂��ʂ̍s�Ƃ��Ď�舵���A�N�G���ŗ��p�\�ɂȂ�܂��B
select value:first_name
from nested_ingest_json
,table(flatten(raw_nested_book:authors));

// �Ԃ��ꂽ�t�B�[���h�� CAST �R�}���h��ǉ����܂�
SELECT value:first_name::varchar, value:last_name::varchar
FROM nested_ingest_json,
LATERAL FLATTEN(input => raw_nested_book:authors);

//�uAS�v���g�p���āA��ɐV�����񖼂����蓖�Ă܂��B 
select value:first_name::varchar as first_nm
, value:last_name::varchar as last_nm
from nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);


//authors���X�g�́u0�v�Ԗڂ�first_name���擾����
select raw_nested_book:authors[0].first_name as "0�Ԗڂ�擪��" from nested_ingest_json,
LATERAL FLATTEN(input => raw_nested_book:authors);