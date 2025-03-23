/*先ほどのテーブルへデータの挿入*/
INSERT INTO ROOT_DEPTH(ROOT_DEPTH_ID, ROOT_DEPTH_CODE, ROOT_DEPTH_NAME, UNIT_OF_MEASURE, RANGE_MIN, RANGE_MAX)
VALUES (1, 'S', '浅い', 'cm', 30, 45);

SELECT
*
FROM "ROOT_DEPTH";


/*（仮：ファイルはステージにアップロード済みと仮定）とした場合のCOPY INTO を使用してファイルからデータをロード*/
COPY INTO ROOT_DEPTH
FROM @your_stage/data.csv
FILE_FORMAT = (
TYPE = 'CSV' 
FIELD_OPTIONALLY_ENCLOSED_BY = '"' --""で過去こまれていた場合はそのまま取り込むため
)
;