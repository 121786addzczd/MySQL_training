/* 最近のデータベースは処理時間が改善されているため、
INでもEXISTSでも処理時間は変わらない場合もある */

SELECT COUNT(*) FROM prefectures; -- 48件
SELECT COUNT(*) FROM customers; -- 50万件

CREATE INDEX idx_customers_prefecture_code ON customers(prefecture_code);

-- prefctures < customers
-- EXISTS
EXPLAIN ANALYZE
SELECT * FROM prefectures AS pr
WHERE EXISTS (SELECT 1 FROM customers AS ct WHERE pr.prefecture_code = ct.prefecture_code);
/*
-> Nested loop semijoin  (cost=60811.83 rows=598832) (actual time=0.393..7.288 rows=41 loops=1)
    -> Table scan on pr  (cost=4.95 rows=47) (actual time=0.221..0.947 rows=47 loops=1)
    -> Index lookup on ct using idx_customers_prefecture_code (prefecture_code=pr.prefecture_code)  (cost=595797.91 rows=12741) (actual time=0.079..0.079 rows=1 loops=47)
*/
-- IN
EXPLAIN ANALYZE
SELECT * FROM prefectures AS pr
WHERE prefecture_code IN(SELECT prefecture_code FROM customers);
/*
-> Nested loop semijoin  (cost=60811.83 rows=598832) (actual time=0.474..8.920 rows=41 loops=1)
    -> Table scan on pr  (cost=4.95 rows=47) (actual time=0.228..1.079 rows=47 loops=1)
    -> Index lookup on customers using idx_customers_prefecture_code (prefecture_code=pr.prefecture_code)  (cost=595797.91 rows=12741) (actual time=0.098..0.098 rows=1 loops=47)
*/
