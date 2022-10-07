-- IN 合致したもの取り出す
SELECT * FROM users WHERE age IN(12,24,36);


-- NOT IN 指定したもの以外あｗｐ取り出す
SELECT * FROM users WHERE birth_place NOT IN("France", "Germany", "Italy");

-- SELECT + IN
SELECT * FROM customers WHERE id IN (SELECT customer_id FROM receipts);

SELECT * FROM customers WHERE id NOT IN (SELECT customer_id FROM receipts WHERE id < 10);

-- ALL(丸括弧の中のSQL実行結果の取得した値が一番大きい)
SELECT * FROM users WHERE age > ALL(SELECT age FROM employees WHERE salary > 500000);

-- ANY(丸括弧の中のSQL実行結果の取得した値いずれかよりも大きい)
SELECT * FROM users WHERE age = ANY(SELECT age FROM employees WHERE salary > 500000);


-- 複数の条件を組み合わせる
-- AND(&&), OR(||)

SELECT * FROM employees;

-- 営業部かつ名前に「田」が含まれる
SELECT * FROM employees WHERE department = " 営業部 " AND name LIKE "%田%";

-- 営業部かつ名前に「田」が含まれかつ年齢が35未満
SELECT * FROM employees WHERE department = " 営業部 " AND name LIKE "%田%" AND age < 35;

-- 営業部かつ名前に「田」もしくは「西」が含まれかつ年齢が35未満
SELECT * FROM employees WHERE department = " 営業部 " AND (name LIKE "%田%" OR name LIKE "%西%") AND age < 35;


SELECT * FROM employees WHERE department = " 営業部 " OR department = " 開発部 ";

-- WHERE department = " 営業部 " OR department = " 開発部 "と同じ挙動
SELECT * FROM employees WHERE department IN (" 営業部 "," 開発部 ");

-- NOT(直後の否定)
SELECT * FROM employees WHERE NOT department = " 営業部 "
