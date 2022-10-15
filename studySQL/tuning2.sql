-- 無駄な処理を一つに
SELECT
  *
FROM customers
WHERE
prefecture_code IN (SELECT prefecture_code FROM prefectures WHERE name = "東京都")
OR
prefecture_code IN (SELECT prefecture_code FROM prefectures WHERE name = "大阪府")
;

-- 上記の処理を一つに。SELECT2回実行されるところが一回になるので処理速度が速くなる
SELECT
  *
FROM customers
WHERE
prefecture_code IN (SELECT prefecture_code FROM prefectures WHERE name IN ("東京都", "大阪府"))
;


-- SELECTない副問合せをやめる
EXPLAIN ANALYZE
SELECT
*, (SELECT name FROM prefectures AS pr WHERE pr.prefecture_code = ct.prefecture_code)
FROM customers AS ct;
/*
-> Table scan on ct  (cost=50435.30 rows=496903) (actual time=0.112..9461.778 rows=500000 loops=1)
-> Select #2 (subquery in projection; dependent)
    -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.35 rows=1) (actual time=0.044..0.060 rows=1 loops=500000)
*/
-- LEFT JOINを使えばまったく同じ結果が得られる。多少速くなる
EXPLAIN ANALYZE
SELECT
*, pr.name
FROM customers AS ct
LEFT JOIN
prefectures AS pr
ON pr.prefecture_code = ct.prefecture_code;
/*
-> Nested loop left join  (cost=224351.35 rows=496903) (actual time=0.403..66816.724 rows=500000 loops=1)
    -> Table scan on ct  (cost=50435.30 rows=496903) (actual time=0.251..7890.408 rows=500000 loops=1)
    -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1) (actual time=0.036..0.049 rows=1 loops=500000)
*/

SHOW TABLES;
-- 2016年度、2016年度の月毎の集計カラムを追加
EXPLAIN ANALYZE
SELECT
 sales_history.*, sales_summary.sales_daily_amount
FROM
 sales_history
LEFT JOIN
(SELECT sales_day, SUM(sales_amount) AS sales_daily_amount
FROM sales_history WHERE sales_day BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY sales_day) AS sales_summary
ON sales_history.sales_day = sales_summary.sales_day
WHERE sales_history.sales_day BETWEEN '2016-01-01' AND '2016-12-31';
/*
-> Nested loop left join  (actual time=122543.308..239172.119 rows=312844 loops=1)
    -> Filter: (sales_history.sales_day between '2016-01-01' and '2016-12-31')  (cost=230278.95 rows=252975) (actual time=0.230..66305.646 rows=312844 loops=1)
        -> Table scan on sales_history  (cost=230278.95 rows=2277000) (actual time=0.175..30894.773 rows=2500000 loops=1)
    -> Index lookup on sales_summary using <auto_key0> (sales_day=sales_history.sales_day)  (actual time=0.026..0.038 rows=1 loops=312844)
        -> Materialize  (actual time=0.462..0.496 rows=1 loops=312844)
            -> Table scan on <temporary>  (actual time=0.020..3.471 rows=336 loops=1)
                -> Aggregate using temporary table  (actual time=122527.552..122538.335 rows=336 loops=1)
                    -> Filter: (sales_history.sales_day between '2016-01-01' and '2016-12-31')  (cost=230278.95 rows=252975) (actual time=0.235..113216.488 rows=312844 loops=1)
                        -> Table scan on sales_history  (cost=230278.95 rows=2277000) (actual time=0.068..51954.633 rows=2500000 loops=1)
*/


EXPLAIN ANALYZE
SELECT
 sh.*, SUM(SH.sales_amount) OVER(PARTITION BY sh.sales_day)
FROM
 sales_history AS sh
WHERE sh.sales_day BETWEEN '2016-01-01' AND '2016-12-31';
/*
-> Window aggregate with buffering: sum(sh.sales_amount) OVER (PARTITION BY sh.sales_day )   (actual time=93656.198..106622.795 rows=312844 loops=1)
    -> Sort: sh.sales_day  (cost=230278.95 rows=2277000) (actual time=93626.751..97511.296 rows=312844 loops=1)
        -> Filter: (sh.sales_day between '2016-01-01' and '2016-12-31')  (cost=230278.95 rows=2277000) (actual time=0.461..88304.729 rows=312844 loops=1)
            -> Table scan on sh  (cost=230278.95 rows=2277000) (actual time=0.335..40833.923 rows=2500000 loops=1)
*/
