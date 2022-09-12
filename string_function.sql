-- LENGTH, CHAR_LENGTH
SELECT LENGTH("ABC");
SELECT LENGTH("あいう"); -- 9バイト数

SELECT name, LENGTH(name) FROM users;

SELECT CHAR_LENGTH("ABC");
SELECT CHAR_LENGTH("あいう") AS length; -- 3文字数

SELECT name, CHAR_LENGTH(name) FROM users;

-- TRIM, LTRIM, RTRIM 空白削除
SELECT LTRIM(" ABC ");
SELECT RTRIM(" ABC ");
SELECT TRIM(" ABC ");

-- 一つはnameの文字数を取得し、もう一つはnameの空白を取り除いた文字数を取得し、それらを比較して違ったものを取得する
SELECT * FROM employees WHERE CHAR_LENGTH(name) <> CHAR_LENGTH(TRIM(name));

-- 上記をわかりやすく表示
SELECT name, CHAR_LENGTH(name) AS name_length FROM employees WHERE CHAR_LENGTH(name) <> CHAR_LENGTH(TRIM(name));

-- UPDATEして空白を削除したものにする
UPDATE employees SET name = TRIM(name) <> CHAR_LENGTH(TRIM(name));


-- REPLACE: 置換
SELECT REPLACE("I like an apple", "apple", "lemon");  -- 引数２つ目は置き換えたい値、3つ目は置き換える値

SELECT REPLACE(name, "Mrs", "Ms") FROM users WHERE name LIKE 'Mrs%';

-- REPLACEで変換した結果をupdateする
UPDATE users SET name = REPLACE(name, "Mrs", "Ms") WHERE name LIKE 'Mrs%';

SELECT * FROM users;


-- UPPER LOWER(大文字、小文字)

SELECT UPPER("apple");
SELECT LOWER("APPLE");

-- 全て大文字、全て小文字
SELECT name, UPPER(name), LOWER(name) FROM users;


-- SUBSTRING 一部取り出し
SELECT SUBSTRING(name, 2,3), name FROM employees;

-- nameカラム二文字目が「田」のあるデータを取り出す
SELECT * FROM employees WHERE SUBSTRING(name, 2, 1) = "田";


-- REVERSE: 逆順
SELECT REVERSE(name), name FROM employees;



