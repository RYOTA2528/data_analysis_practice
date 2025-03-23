/*先ほどのテーブルへデータの挿入*/
INSERT INTO ROOT_DEPTH(ROOT_DEPTH_ID, ROOT_DEPTH_CODE, ROOT_DEPTH_NAME, UNIT_OF_MEASURE, RANGE_MIN, RANGE_MAX)
VALUES (1, 'S', '浅い', 'cm', 30, 45);

SELECT
*
FROM "ROOT_DEPTH";


/*複数行の挿入*/
insert into root_depth (root_depth_id, root_depth_code
                        , root_depth_name, unit_of_measure
                        , range_min, range_max)  
values
                        (5,'X','short','in',66,77)
                       ,(8,'Y','tall','cm',98,99);

/*（仮：ファイルはステージにアップロード済みと仮定）とした場合のCOPY INTO を使用してファイルからデータをロード*/
-- COPY INTO ROOT_DEPTH
-- FROM @your_stage/data.csv
-- FILE_FORMAT = (
-- TYPE = 'CSV' 
-- FIELD_OPTIONALLY_ENCLOSED_BY = '"' --""で過去こまれていた場合はそのまま取り込むため
-- )
-- ;



/*テーブル内の不要な行を削除するには*/
delete from ROOT_DEPTH
WHERE ROOT_DEPTH_ID = 8;


/*データの更新*/
update ROOT_DEPTH set ROOT_DEPTH_ID = 9
where ROOT_DEPTH_ID = 5;
