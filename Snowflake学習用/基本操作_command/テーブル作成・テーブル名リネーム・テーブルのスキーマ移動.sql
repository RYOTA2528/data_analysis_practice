/*�V���v���Ƀe�[�u�����쐬*/
create or replace table  ROOT_DEPTH(
    ROOT_DEPTH_ID number(1),
    ROOT_DEPTH_CODE text(1),
    ROOT_DEPTH_NAME text(7),
    UNIT_OF_MEASURE text(2),
    RANGE_MIN number(2),
    RANGE_MAX number(2)

);

/*�A�J�E���g���쐬�����S�e�[�u����\��*/
show tables in account;


/*�e�[�u���̃��l�[��*/
-- alter table garden_plants.veggies ROOT_DEPTH rename to garden_plants.veggies.rootdepth;


/*�쐬�����X�L�[�}�Ƃ͕ʃX�L�[�}�ֈړ�*/
-- alter table garden_plants.veggies.root_depth rename to garden_plants.flowers.root_depth