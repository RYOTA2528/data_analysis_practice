-- テーブル INT_STDS_ORG_3166を作成


create or replace table intl_db.public.INT_STDS_ORG_3166 
(iso_country_name varchar(100), -- 国名のISO表記（最大100文字）
 country_name_official varchar(200), -- 正式な国名（最大200文字）
 sovreignty varchar(40), -- 主権（最大40文字）
 alpha_code_2digit varchar(2), -- 2桁のアルファベットコード（最大2文字）
 alpha_code_3digit varchar(3), -- 3桁のアルファベットコード（最大3文字）
 numeric_country_code integer, -- 数字による国コード（整数型）
 iso_subdivision varchar(15),   -- ISOサブディビジョン（最大15文字）
 internet_domain_code varchar(10) -- インターネットの国別ドメインコード（最大10文字）
);


-- テーブルを読み込むためのファイル形式を作成する
create or replace file format PIPE_DBLQUOTE_HEADER_CR 
  type = 'CSV' ---- 圧縮方式を自動設定
  compression = 'AUTO' 
  field_delimiter = '|' 
  record_delimiter = '\r' -- レコードの区切り文字としてキャリッジリターン（\r）を使用
  skip_header = 1  
  field_optionally_enclosed_by = '\042'  -- フィールドはダブルクオート（"）で囲まれる場合がある
  trim_space = FALSE;　-- フィールドの前後のスペースをトリミング（削除）しない設定です


  // データファイルをS3から取得する //

-- drop stage intl_db.public.aws_s3_bucket;

create stage util_db.public.aws_s3_bucket url = 's3://uni-cmcw';

  -- ステージ確認
  show stages in account;

-- aws_s3_bucketステージの中身を確認
 list @aws_s3_bucket;


 -- INT_STDS_ORG_3166テーブルにデータをロードする
 copy into intl_db.public.INT_STDS_ORG_3166
 from @aws_s3_bucket
 files = ( 'ISO_Countries_UTF8_pipe.csv')
 file_format = (format_name = 'PIPE_DBLQUOTE_HEADER_CR')