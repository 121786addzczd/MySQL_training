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
