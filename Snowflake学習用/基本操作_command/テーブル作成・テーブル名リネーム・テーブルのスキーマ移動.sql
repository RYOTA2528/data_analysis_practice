/*シンプルにテーブルを作成*/
create or replace table  ROOT_DEPTH(
    ROOT_DEPTH_ID number(1),
    ROOT_DEPTH_CODE text(1),
    ROOT_DEPTH_NAME text(7),
    UNIT_OF_MEASURE text(2),
    RANGE_MIN number(2),
    RANGE_MAX number(2)

);

/*アカウントが作成した全テーブルを表示*/
show tables in account;


/*テーブルのリネーム*/
-- alter table garden_plants.veggies ROOT_DEPTH rename to garden_plants.veggies.rootdepth;


/*作成したスキーマとは別スキーマへ移動*/
-- alter table garden_plants.veggies.root_depth rename to garden_plants.flowers.root_depth