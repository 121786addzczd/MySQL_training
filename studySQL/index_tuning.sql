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




/* SQLチューニング インデックスが利用されないパターン1 */
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



/* SQLチューニング インデックスが利用されないパターン2 */
-- 文字列と数値の比較
CREATE INDEX idx_customers_prefecture_code ON customers(prefecture_code);
EXPLAIN ANALYZE SELECT * FROM customers WHERE prefecture_code = 21;
/* INDEX貼ってもフルスキャン prefecture_codeは文字列型
-> Filter: (customers.prefecture_code = 21)  (cost=50435.30 rows=49690) (actual time=0.343..13384.904 rows=12192 loops=1)
    -> Table scan on customers  (cost=50435.30 rows=496903) (actual time=0.074..6921.408 rows=500000 loops=1)
*/
DESCRIBE customers;
-- シングルクォートで囲む
EXPLAIN ANALYZE SELECT * FROM customers WHERE prefecture_code = '21';
/*
-> Index lookup on customers using idx_customers_prefecture_code (prefecture_code='21'), with index condition: (customers.prefecture_code = '21')  (cost=4429.20 rows=21942) (actual time=3.433..860.693 rows=12192 loops=1)
*/

-- 前方一致、中間一致、後方一致
CREATE INDEX idx_customers_first_name ON customers(first_name);
EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name LIKE 'Jo%'
/*
-> Index range scan on customers using idx_customers_first_namee, with index condition: (customers.first_name like 'Jo%')  (cost=23498.36 rows=52218) (actual time=4.596..653.827 rows=24521 loops=1)
*/

-- 後方一致はフルスキャン
EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name LIKE '%A'
/*
-> Filter: (customers.first_name like '%A')  (cost=50435.30 rows=55206) (actual time=0.638..15061.219 rows=92504 loops=1)
    -> Table scan on customers  (cost=50435.30 rows=496903) (actual time=0.144..7029.806 rows=500000 loops=1)
*/

-- 中間一致はフルスキャン

-- first_nameにJoを含む人の最初の50000件
EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name LIKE '%Jo%' LIMIT 50000; -- 6567ms

-- customersから5000件取ってきたうちfirst_nameにJoを含む人
EXPLAIN ANALYZE SELECT * FROM (SELECT * FROM customers LIMIT 50000) AS tmp WHERE first_name LIKE '%Jo%'; -- 3847ms

SHOW INDEX FROM customers;

DROP INDEX idx_customers_age ON customers;

DROP INDEX idx_customers_prefecture_code ON customers;

DROP INDEX idx_customers_first_name ON customers;


-- 無駄なグループBY
EXPLAIN ANALYZE
SELECT
age, COUNT(*)
FROM customers
GROUP BY age
HAVING age < 30;
/*
-> Filter: (customers.age < 30)  (actual time=14747.299..14749.407 rows=8 loops=1)
    -> Table scan on <temporary>  (actual time=0.021..0.747 rows=49 loops=1)
        -> Aggregate using temporary table  (actual time=14746.982..14748.787 rows=49 loops=1)
            -> Table scan on customers  (cost=50435.30 rows=496903) (actual time=0.075..6994.830 rows=500000 loops=1)
*/

CREATE INDEX idx_customers_age ON customers(age);
EXPLAIN ANALYZE
SELECT
age, COUNT(*)
FROM customers
WHERE age < 30
GROUP BY age;  -- GROUP BY はHAVINGで絞り込むのではなくWHEREで絞り込んでからGROUP BY
/*
-> Group aggregate: count(0)  (actual time=413.431..3431.150 rows=8 loops=1)
    -> Filter: (customers.age < 30)  (cost=32491.42 rows=161958) (actual time=0.132..2598.526 rows=82096 loops=1)
        -> Index range scan on customers using idx_customers_age  (cost=32491.42 rows=161958) (actual time=0.078..949.537 rows=82096 loops=1)
*/

-- MAX, MINはインデックスを利用することができる。AVG,SUMはフルスキャン
EXPLAIN ANALYZE SELECT MAX(age), MIN(age), AVG(age), SUM(age) FROM customers;
/*
-> Aggregate: avg(customers.age), sum(customers.age)  (actual time=11988.243..11988.262 rows=1 loops=1)
    -> Index scan on customers using idx_customers_age  (cost=50435.30 rows=496903) (actual time=0.052..5997.371 rows=500000 loops=1)
*/

-- DISTINCTの代わりにEXISTS

-- DISTINCTの場合
EXPLAIN ANALYZE SELECT DISTINCT pr.name FROM prefectures AS pr
INNER JOIN customers AS ct
ON pr.prefecture_code = ct.prefecture_code;
/*
-> Table scan on <temporary>  (actual time=0.021..0.434 rows=41 loops=1)
    -> Temporary table with deduplication  (cost=224351.35 rows=496903) (actual time=85763.006..85764.227 rows=41 loops=1)
        -> Nested loop inner join  (cost=224351.35 rows=496903) (actual time=0.193..77109.164 rows=500000 loops=1)
            -> Filter: (ct.prefecture_code is not null)  (cost=50435.30 rows=496903) (actual time=0.102..20494.424 rows=500000 loops=1)
                -> Table scan on ct  (cost=50435.30 rows=496903) (actual time=0.060..7219.070 rows=500000 loops=1)
            -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1) (actual time=0.034..0.047 rows=1 loops=500000)
*/

-- EXISTS
EXPLAIN ANALYZE
SELECT name FROM prefectures AS pr
WHERE EXISTS(
  SELECT 1 FROM customers AS ct WHERE ct.prefecture_code = pr.prefecture_code
);
/* 多少速くなる
-> Nested loop inner join  (cost=2335453.75 rows=23354441) (actual time=34833.717..34845.984 rows=41 loops=1)
    -> Table scan on pr  (cost=4.95 rows=47) (actual time=0.102..0.915 rows=47 loops=1)
    -> Single-row index lookup on <subquery2> using <auto_distinct_key> (prefecture_code=pr.prefecture_code)  (actual time=0.037..0.049 rows=1 loops=47)
        -> Materialize with deduplication  (cost=50435.30 rows=496903) (actual time=741.248..741.286 rows=1 loops=47)
            -> Filter: (ct.prefecture_code is not null)  (cost=50435.30 rows=496903) (actual time=0.139..25109.378 rows=500000 loops=1)
                -> Table scan on ct  (cost=50435.30 rows=496903) (actual time=0.076..8775.839 rows=500000 loops=1)
*/

-- UNION → UNION ALL
EXPLAIN ANALYZE
SELECT * FROM customers WHERE age < 30
UNION
SELECT * FROM customers WHERE age > 50;
/*
-> Table scan on <union temporary>  (cost=2.50 rows=0) (actual time=0.040..4438.193 rows=286055 loops=1)
    -> Union materialize with deduplication  (actual time=61101.642..73939.163 rows=286055 loops=1)
        -> Filter: (customers.age < 30)  (cost=50435.30 rows=161958) (actual time=0.337..26669.255 rows=82096 loops=1)
            -> Table scan on customers  (cost=50435.30 rows=496903) (actual time=0.105..12850.228 rows=500000 loops=1)
        -> Filter: (customers.age > 50)  (cost=50435.30 rows=248451) (actual time=0.528..24641.854 rows=203959 loops=1)
            -> Table scan on customers  (cost=50435.30 rows=496903) (actual time=0.387..10779.922 rows=500000 loops=1)
*/

EXPLAIN ANALYZE
SELECT * FROM customers WHERE age < 30
UNION ALL
SELECT * FROM customers WHERE age > 50;
/*
-> Append  (actual time=0.662..78914.717 rows=286055 loops=1)
    -> Stream results  (cost=50435.30 rows=161958) (actual time=0.380..26936.018 rows=82096 loops=1)
        -> Filter: (customers.age < 30)  (cost=50435.30 rows=161958) (actual time=0.305..23311.384 rows=82096 loops=1)
            -> Table scan on customers  (cost=50435.30 rows=496903) (actual time=0.112..11318.479 rows=500000 loops=1)
    -> Stream results  (cost=50435.30 rows=248451) (actual time=0.213..39722.740 rows=203959 loops=1)
        -> Filter: (customers.age > 50)  (cost=50435.30 rows=248451) (actual time=0.161..29304.303 rows=203959 loops=1)
            -> Table scan on customers  (cost=50435.30 rows=496903) (actual time=0.083..12817.229 rows=500000 loops=1)
*/
