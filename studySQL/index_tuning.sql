USE day_19_21_db;

SELECT * FROM customers;

/* 複合INDEX */


EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name = "Olivia";
/*
-> Filter: (customers.first_name = 'Olivia')  (cost=50479.50 rows=49735) (actual time=0.147..11404.568 rows=503 loops=1)
    -> Table scan on customers  (cost=50479.50 rows=497345) (actual time=0.060..5881.325 rows=500000 loops=1)
*/

-- first_nameにINDEX追加
CREATE INDEX idx_customers_first_name ON customers(first_name);

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name = "Olivia";
/*
-> Index lookup on customers using idx_customers_first_name (first_name='Olivia')  (cost=176.05 rows=503) (actual time=12.820..50.644 rows=503 loops=1)
*/

CREATE INDEX idx_customers_age ON customers(age);
EXPLAIN ANALYZE SELECT * FROM customers WHERE age = 41;
/*
-> Index lookup on customers using idx_customers_age (age=41)  (cost=3245.00 rows=10100) (actual time=3.271..278.364 rows=10100 loops=1)
*/


EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name = "Olivia" AND age = 42;
/*
-> Filter: ((customers.age = 42) and (customers.first_name = 'Olivia'))  (cost=35.56 rows=10) (actual time=0.699..23.968 rows=10 loops=1)↵    -> Index range scan on customers using intersect(idx_customers_first_name,idx_customers_age)  (cost=35.56 rows=10) (actual time=0.633..23.490 rows=10 loops=1)↵
*/

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name = "Olivia" OR age = 42;
/*
-> Filter: ((customers.first_name = 'Olivia') or (customers.age = 42))  (cost=4433.59 rows=10589) (actual time=0.313..461.003 rows=10579 loops=1)
    -> Index range scan on customers using union(idx_customers_first_name,idx_customers_age)  (cost=4433.59 rows=10589) (actual time=0.254..221.433 rows=10579 loops=1)
*/

-- 複合インデックス
DROP INDEX idx_customers_first_name ON customers;
DROP INDEX idx_customers_age ON customers;

CREATE INDEX idx_customers_first_name_age ON customers(first_name, age);


EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name = "Olivia" AND age = 42;
/*
-> Index lookup on customers using idx_customers_first_name_age (first_name='Olivia', age=42)  (cost=3.50 rows=10) (actual time=0.367..0.679 rows=10 loops=1)↵
*/

-- ageのみの場合はフルスキャンになる
EXPLAIN ANALYZE SELECT * FROM customers WHERE age = 42;
/*
-> Filter: (customers.age = 42)  (cost=50479.50 rows=49735) (actual time=8.063..9944.050 rows=10086 loops=1)
    -> Table scan on customers  (cost=50479.50 rows=497345) (actual time=0.110..5102.755 rows=500000 loops=1)
*/

-- フルスキャンになる
EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name = "Olivia" OR age = 42;
/*
-> Filter: ((customers.first_name = 'Olivia') or (customers.age = 42))  (cost=50479.50 rows=50345) (actual time=0.150..9967.202 rows=10579 loops=1)
    -> Table scan on customers  (cost=50479.50 rows=497345) (actual time=0.087..4958.550 rows=500000 loops=1)
*/


/* INDEXを使ったORDER BY GRUOP BY */

-- ORDER BY, GROUP BY　時間かかる。実行前にWHEREで絞り込む
DROP INDEX idx_customers_first_name_age ON customers;

EXPLAIN ANALYZE SELECT * FROM customers ORDER BY first_name;
/*
-> Sort: customers.first_name  (cost=50479.50 rows=497345) (actual time=12160.109..16840.792 rows=500000 loops=1)
    -> Table scan on customers  (cost=50479.50 rows=497345) (actual time=0.091..4937.755 rows=500000 loops=1)
*/

CREATE INDEX idx_customers_first_namee ON customers(first_name);

-- INDEXあり
EXPLAIN ANALYZE SELECT * FROM customers ORDER BY first_name;
/*
-> Sort: customers.first_name  (cost=50479.50 rows=497345) (actual time=12138.105..17437.105 rows=500000 loops=1)↵    -> Table scan on customers  (cost=50479.50 rows=497345) (actual time=0.348..5848.076 rows=500000 loops=1)↵
*/

-- 一意のカラムに対しては速度早い
EXPLAIN ANALYZE SELECT * FROM customers ORDER BY id;

-- GROUP BY
EXPLAIN ANALYZE SELECT first_name, COUNT(*) FROM customers GROUP BY first_name;
/*
-> Group aggregate: count(0)  (actual time=73.678..11123.337 rows=690 loops=1)
    -> Index scan on customers using idx_customers_first_namee  (cost=50479.50 rows=497345) (actual time=10.313..5634.825 rows=500000 loops=1)
*/

CREATE INDEX idx_customers_age ON customers(age);

EXPLAIN ANALYZE SELECT age, COUNT(*) FROM customers GROUP BY age;
/*
-> Group aggregate: count(0)  (actual time=258.007..10787.539 rows=49 loops=1)
    -> Index scan on customers using idx_customers_age  (cost=50479.50 rows=497345) (actual time=0.097..5609.024 rows=500000 loops=1)
*/

DROP INDEX idx_customers_first_name ON customers;

DROP INDEX idx_customers_age ON customers;

-- 複数のGROUP BY
-- INDEXなしの場合
EXPLAIN ANALYZE SELECT first_name, age, COUNT(*) FROM customers GROUP By first_name, age;
/*
-> Table scan on <temporary>  (actual time=0.023..408.164 rows=32369 loops=1)
    -> Aggregate using temporary table  (actual time=16278.759..17445.585 rows=32369 loops=1)
        -> Table scan on customers  (cost=50479.50 rows=497345) (actual time=0.089..6781.808 rows=500000 loops=1)

*/

CREATE INDEX idx_customers_first_name_age ON customers(first_name, age);
-- INDEX貼った場合
EXPLAIN ANALYZE SELECT first_name, age, COUNT(*) FROM customers GROUP By first_name, age;
/*
-> Group aggregate: count(0)  (actual time=1.087..14674.021 rows=32369 loops=1)
    -> Index scan on customers using idx_customers_first_name_age  (cost=50479.50 rows=497345) (actual time=0.069..7193.942 rows=500000 loops=1)
*/

DROP INDEX idx_customers_first_name_age ON customers;

-- 外部キーにインデックスを貼る
-- インデックスを貼っていない場合の
EXPLAIN ANALYZE SELECT * FROM prefectures AS pr
INNER JOIN customers AS ct
ON pr.prefecture_code = ct.prefecture_code AND pr.name = "北海道";

/* フルスキャン
-> Nested loop inner join  (cost=224550.25 rows=49735) (actual time=3.958..113780.275 rows=12321 loops=1)
    -> Filter: (ct.prefecture_code is not null)  (cost=50479.50 rows=497345) (actual time=0.535..23375.172 rows=500000 loops=1)
        -> Table scan on ct  (cost=50479.50 rows=497345) (actual time=0.414..8555.998 rows=500000 loops=1)
    -> Filter: (pr.`name` = '北海道')  (cost=0.25 rows=0) (actual time=0.135..0.136 rows=0 loops=500000)
        -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1) (actual time=0.045..0.060 rows=1 loops=500000)
*/

CREATE INDEX idx_customers_orefecture_code ON customers(prefecture_code);

-- インデックスを貼った後
EXPLAIN ANALYZE SELECT * FROM prefectures AS pr
INNER JOIN customers AS ct
ON pr.prefecture_code = ct.prefecture_code AND pr.name = "北海道";
/* 外部キーにindexを貼ると速くなる
-> Nested loop inner join  (cost=16503.09 rows=59936) (actual time=7.241..556.836 rows=12321 loops=1)
    -> Filter: (pr.`name` = '北海道')  (cost=4.95 rows=5) (actual time=3.056..4.089 rows=1 loops=1)
        -> Table scan on pr  (cost=4.95 rows=47) (actual time=2.980..3.553 rows=47 loops=1)
    -> Index lookup on ct using idx_customers_orefecture_code (prefecture_code=pr.prefecture_code)  (cost=2506.33 rows=12752) (actual time=4.092..292.653 rows=12321 loops=1)
*/

DROP INDEX idx_customers_orefecture_code ON customers;




/* SQLチューニング インデックスが利用されないパターン */
-- INDEXなし
SELECT * FROM customers WHERE UPPER(first_name) = "JOSEPH";

-- INDEX追加
CREATE INDEX idx_customers_first_name ON customers(first_name);

-- インデックス追加してもテーブルスキャンで速くならない
EXPLAIN ANALYZE SELECT * FROM customers WHERE UPPER(first_name) = "JOSEPH";
/*
-> Filter: (upper(customers.first_name) = 'JOSEPH')  (cost=50479.50 rows=497345) (actual time=0.362..12999.586 rows=4712 loops=1)
    -> Table scan on customers  (cost=50479.50 rows=497345) (actual time=0.120..6523.982 rows=500000 loops=1)

*/

-- 関数を実行して結果に対してINDEXつける
CREATE INDEX idex_customers_lower_first_name ON customers((UPPER(first_name)));
EXPLAIN ANALYZE SELECT * FROM customers WHERE UPPER(first_name) = "JOSEPH"; -- 関数INDEXは最終手段と考える
/*
-> Index lookup on customers using idex_customers_lower_first_name (upper(first_name)='JOSEPH')  (cost=1649.20 rows=4712) (actual time=2.153..101.477 rows=4712 loops=1)
*/

-- UPPER関数使わない検索パターン
EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name  IN("joseph", "joseph", "JOSEPH");

DROP INDEX idx_customers_first_name ON customers;
DROP INDEX idex_customers_lower_first_name ON customers;


CREATE INDEX idx_customers_age ON customers(age);
EXPLAIN ANALYZE SELECT * FROM customers WHERE age = 25;
/*
-> Index lookup on customers using idx_customers_age (age=25)  (cost=3263.60 rows=10286) (actual time=4.085..281.542 rows=10286 loops=1)
*/

-- フルスキャンにななる
EXPLAIN ANALYZE SELECT * FROM customers WHERE age +2 = 27;
/*
-> Filter: ((customers.age + 2) = 27)  (cost=50435.30 rows=496903) (actual time=6.111..14881.254 rows=10286 loops=1)
    -> Table scan on customers  (cost=50435.30 rows=496903) (actual time=0.096..7815.364 rows=500000 loops=1)

*/
