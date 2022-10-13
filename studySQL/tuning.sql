SHOW TABLES;

SELECT * FROM customers;

-- バインド変数
SET @customer_id = 5;
SELECT * FROM customers WHERE id = @customer_id;

USE day_19_21_db;

SHOW TABLES;

-- 統計情報の確認
SELECT * FROM mysql.innodb_table_stats WHERE database_name = "day_19_21_db";

SELECT * FROM prefectures;

INSERT INTO prefectures VALUES("48", "不明");

DELETE FROM prefectures WHERE prefecture_code = "48" AND name = "不明";

-- 統計情報の手動更新
ANALYZE TABLE prefectures;

-- SQLを実行せずに実行計画だけ表示
EXPLAIN SELECT * FROM customers;

-- SQLを実行して実行計画を表示
EXPLAIN ANALYZE SELECT * FROM customers;

/*
-> Table scan on customers  (cost=50598.77 rows=497345) (actual time=0.096..5160.271 rows=500000 loops=1)
*/



/* フルスキャン・インデックススキャン */
EXPLAIN ANALYZE SELECT * FROM customers;

/* 結果 900ミリ秒ほど
-> Table scan on customers  (cost=50479.50 rows=497345) (actual time=0.317..9800.605 rows=500000 loops=1)
*/

EXPLAIN ANALYZE SELECT * FROM customers WHERE id = 1;

/*
-> Rows fetched before execution  (cost=0.00 rows=1) (actual time=0.028..0.043 rows=1 loops=1)
*/

EXPLAIN SELECT * FROM customers WHERE id = 1;
/* typeの値がconstになり、ユニークスキャン */


EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name = "Olivia";
/*
-> Filter: (customers.first_name = 'Olivia')  (cost=50479.50 rows=49735) (actual time=0.152..16823.274 rows=503 loops=1)
    -> Table scan on customers  (cost=50479.50 rows=497345) (actual time=0.091..8338.527 rows=500000 loops=1)
*/

CREATE INDEX idx_customer_first_name ON customers(first_name);

-- インデックス作成後
EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name = "Olivia";
/*
-> Index lookup on customers using idx_customer_first_name (first_name='Olivia')  (cost=176.05 rows=503) (actual time=3.797..41.634 rows=503 loops=1)
*/

EXPLAIN ANALYZE SELECT * FROM customers WHERE gender = "F";

/*
-> Filter: (customers.gender = 'F')  (cost=50479.50 rows=49735) (actual time=0.146..17171.929 rows=250065 loops=1)
    -> Table scan on customers  (cost=50479.50 rows=497345) (actual time=0.087..7148.928 rows=500000 loops=1)
*/

CREATE INDEX idx_customers_gender ON customers(gender);
-- 遅くなる(インデックスつけると)
EXPLAIN ANALYZE SELECT * FROM customers WHERE gender = "F";

/*
-> Index lookup on customers using idx_customers_gender (gender='F'), with index condition: (customers.gender = 'F')  (cost=27102.20 rows=248672) (actual time=3.428..8650.310 rows=250065 loops=1)

*/

-- ヒント句(あまり使わない)
EXPLAIN ANALYZE SELECT /*+ NO_INDEX(ct) */ * FROM customers AS ct WHERE gender = "F";
/*
-> Filter: (ct.gender = 'F')  (cost=50479.50 rows=497345) (actual time=0.282..15430.383 rows=250065 loops=1)
    -> Table scan on ct  (cost=50479.50 rows=497345) (actual time=0.164..6286.939 rows=500000 loops=1)
*/

DROP INDEX idx_customers_gender ON customers;
DROP INDEX idx_customer_first_name ON customers;


/* ネステッドループ、ハッシュ、ソートマージ */
EXPLAIN ANALYZE SELECT
*
FROM customers AS ct
INNER JOIN prefectures AS pr
ON  ct.prefecture_code = pr.prefecture_code;

/*
-> Nested loop inner join  (cost=224550.25 rows=497345) (actual time=0.613..116948.550 rows=500000 loops=1)
    -> Filter: (ct.prefecture_code is not null)  (cost=50479.50 rows=497345) (actual time=0.450..30421.934 rows=500000 loops=1)
        -> Table scan on ct  (cost=50479.50 rows=497345) (actual time=0.152..11257.081 rows=500000 loops=1)
    -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1) (actual time=0.058..0.077 rows=1 loops=500000)
*/

EXPLAIN ANALYZE SELECT /*+ NO_INDEX(pr) */
*
FROM customers AS ct
INNER JOIN prefectures AS pr
ON  ct.prefecture_code = pr.prefecture_code;
/*
-> Inner hash join (ct.prefecture_code = pr.prefecture_code)  (cost=2338278.13 rows=2337522) (actual time=4.337..35698.549 rows=500000 loops=1)
    -> Table scan on ct  (cost=121.81 rows=497345) (actual time=0.189..12917.888 rows=500000 loops=1)
    -> Hash
        -> Table scan on pr  (cost=4.95 rows=47) (actual time=0.127..1.040 rows=47 loops=1)
*/

