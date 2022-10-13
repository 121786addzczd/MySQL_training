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



