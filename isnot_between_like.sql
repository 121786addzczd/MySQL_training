SELECT DATABASE();

DESCRIBE customers;

-- nameカラムに値が入っていないデータだけ取り出す(IS NULLでないと取り出せない)
SELECT * FROM customers WHERE name IS NULL;

SELECT NULL = NULL;
SELECT NULL IS NULL;

-- nameカラムに値が入ってる(NULLではない)データだけ取り出す
SELECT * FROM customers WHERE name IS NOT NULL;

SELECT * FROM prefectures;

SELECT * FROM prefectures WHERE name is NULL;

SELECT * FROM prefectures WHERE name = '';


-- BETWEEN, NOT BETWEEN
SELECT * FROM users WHERE age NOT BETWEEN 5 AND 10 ORDER BY age;


-- LIKE, NOT LIKE
SELECT * FROM users WHERE name LIKE "村%"; -- 前方一致

SELECT * FROM users WHERE name LIKE "%三郎"; -- 後方一致

SELECT * FROM users WHERE name LIKE "%ab%"; -- 中間一致

SELECT * FROM prefectures WHERE name LIKE "福_%" ORDER BY name; -- _は任意の一文字
