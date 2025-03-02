/*
BigQuery�� �u2018 �N�̃^�N�V�[�����f�[�^�̃T�u�Z�b�g�v���i�[
[�i�[�f�[�^��]
nyc_tlc_yellow_trips_2018_subset_1.csv
*/

/*�N�Ԃŗ����̍���������� 5 ���̒��������X�g����N�G�������s*/

SELECT
  *
FROM
  nyctaxi.2018trips
ORDER BY
  fare_amount DESC
LIMIT  5

/*Cloud Storage ���� 2018 �N�̓��������f�[�^�̕ʂ̃T�u�Z�b�g��ǂݍ���*/

/*
Cloud Shell �ŁA���̃R�}���h�����s���܂��B
-----------
bq load \
--source_format=CSV \
--autodetect \
--noreplace  \
nyctaxi.2018trips \
gs://cloud-training/OCBL013/nyc_tlc_yellow_trips_2018_subset_2.csv
----------
*/



/*DDL ���g�p���đ��̃e�[�u������e�[�u�����쐬����*/

/*
2018trips �e�[�u���ɂ͔N�Ԃ��ׂĂ̒����f�[�^���܂܂��悤�ɂȂ��Ă��邽�߁A
�u1 ���̒����f�[�^�������K�v�ȏꍇ�v�Ɍ����ăe�[�u�����쐬

*/


CREATE TABLE
  nyctaxi.january_trips AS
SELECT
  *
FROM
  nyctaxi.2018trips
WHERE
  EXTRACT(Month
  FROM
    pickup_datetime)=1;


/*1 ���̍Œ��������������*/
SELECT
  *
FROM
  nyctaxi.january_trips
ORDER BY
  trip_distance DESC
LIMIT
  1


