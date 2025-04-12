// どれだけの配達が降雪の影響で遅延するのか？  
/*
1日に6インチを超える降雪があると、私の会社では配達に遅延が発生します。
前年の1月第3週に影響を受けた配達数はどれくらいありますか？
*/
　--クエリ解説--
　/*
　　・DATEADD(year, -1, CURRENT_DATE())：1年前 → 2024-04-12
　　・DATE_TRUNC('year', ...)：2024-04-12 → 2024-01-01
　　・WEEKISO(ref_timestamp) != 1　ISO 週番号で見て、1月1日が「第1週」でない場合、1を加算して調整　例：2023年1月1日は ISO上は「前年の最終週」なので週番号が1じゃない
  　・CAST(WEEKISO(ref_timestamp) != 1 AS INTEGER)
    ・WEEKISO(ref_timestamp) != 1 WEEKISO(...) != 1 が真かどうかを 数値（0か1）として扱えるようにしている
    ・DATEADD(week, 2 + CAST(WEEKISO(ref_timestamp) != 1 AS INTEGER), ref_timestamp)　基本は「2週進める」ただし、ref_timestamp（前年の1月1日）が第1週でない場合は「もう1週多く」ずらす
    --
    ・NATURAL INNER JOIN　両方のテーブルに同じ名前のカラムがあれば、それを結合キーとして使う（「ON テーブルA.col = テーブルB.col って書かなくても自動でやってくれる」）
    ・ROW_NUMBER() OVER (ORDER BY SEQ1())：この関数は、生成された番号（SEQ1()）に基づいて 1から始まる連番 を day_num 列として生成
    ・TABLE(GENERATOR(rowcount => 7)) は、7行の仮想的なデータセット を生成します。このデータセットは、特定の操作や処理をするための中間結果として使われます。
　*/
WITH timestamps AS
(   
    SELECT
        DATE_TRUNC(year,DATEADD(year,-1,CURRENT_DATE())) AS ref_timestamp,
        LAST_DAY(DATEADD(week,2 + CAST(WEEKISO(ref_timestamp) != 1 AS INTEGER),ref_timestamp),week) AS end_week,
        DATEADD(day, day_num - 7, end_week) AS date_valid_std
    FROM
    (   
        SELECT
            ROW_NUMBER() OVER (ORDER BY SEQ1()) AS day_num
        FROM
            TABLE(GENERATOR(rowcount => 7))
    ) 
)
SELECT
    country,
    postal_code,
    date_valid_std, --観測日（＝対象の週の日付）
    tot_snowfall_in --その日の総降雪量（インチ）
FROM 
    standard_tile.history_day
NATURAL INNER JOIN --共通のカラム（この場合 date_valid_std）で自動結合
    timestamps --前年の1月第3週の7日間のリストを生成した共通テーブル式
WHERE
    country='US' AND
    tot_snowfall_in > 6.0 --1日の降雪量が 6.0インチ超 に限定（遅延リスクが高い日）
ORDER BY 
    postal_code,date_valid_std
;