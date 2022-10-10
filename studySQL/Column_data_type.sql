CREATE TABLE messages (
  name_code CHAR(8),
  name VARCHAR(25),
  message TEXT -- 65535
);

INSERT INTO messages VALUES("00000001", "Yoshida Taiki", "元気が取り柄");
INSERT INTO messages VALUES("00000002", "Yasuda Yui", "ポジティブ");

SELECT * FROM messages;


-- INT系
CREATE TABLE patients(
  id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT, -- 0〜655335
  name VARCHAR(50),
  age TINYINT UNSIGNED DEFAULT 0 -- 0 ~ 255
);

INSERT INTO patients(name, age) VALUES("Sachiko", 34);

SELECT * FROM patients;
INSERT INTO patients(name, age) VALUES("Sachiko", 255);

INSERT INTO patients(id, name) VALUES(65536, "Yoshio");

ALTER TABLE patients MODIFY id MEDIUMINT UNSIGNED AUTO_INCREMENT; -- 0 ~ 16777215

SHOW FULL COLUMNS FROM patients;

-- heightカラム、 weightカラムの追加
ALTER TABLE patients ADD COLUMN(height FLOAT);

ALTER TABLE patients ADD COLUMN(weight FLOAT);

SELECT * FROM patients;

INSERT INTO patients(name, age, height, weight) VALUES("Taro", 44, 175.6789, 67.8934);


CREATE TABLE tmp_float(
  num FLOAT
);

INSERT INTO tmp_float VALUES(12345678);
SELECT * FROM tmp_float; -- 丸められる

CREATE TABLE tmp_double(
  num DOUBLE
);

INSERT INTO tmp_double VALUES(123456789.12345689);

SELECT * FROM tmp_double;
SELECT num+2, num FROM tmp_double;

-- DECIMAL(正確な値を使いたい時)
ALTER TABLE patients ADD COLUMN score DECIMAL(7, 3); -- 整数部:4, 少数部:3

SELECT * FROM patients;

INSERT INTO patients(name, age, score) VALUES("Jiro", 54, 32.456);

CREATE TABLE tmp_decimal(
  num_float FLOAT,
  num_double DOUBLE,
    num_decimal DECIMAL(20,10)
);

INSERT INTO tmp_decimal VALUES(1111111111.1111111111, 1111111111.1111111111, 1111111111.1111111111);

SELECT * FROM tmp_decimal;

SELECT num_decimal, (num_decimal * 2 + 2) FROM tmp_decimal;

-- 論理型
CREATE TABLE managers(
  id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
  is_superuser BOOLEAN
);

INSERT INTO managers (name, is_superuser) VALUES("Taro", true);

INSERT INTO managers (name, is_superuser) VALUES("Jiro", false);

SELECT * FROM managers WHERE is_superuser = false;


/* 日付型(DATE, TIME, DATETIME, TIMESTAMP) その１ */
-- DATE TIME

CREATE TABLE messages (
  name_code CHAR(8),
  name VARCHAR(25),
  message TEXT -- 65535
);

INSERT INTO messages VALUES("00000001", "Yoshida Taiki", "元気が取り柄");
INSERT INTO messages VALUES("00000002", "Yasuda Yui", "ポジティブ");

SELECT * FROM messages;



-- INT系
CREATE TABLE patients(
  id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT, -- 0〜655335
  name VARCHAR(50),
  age TINYINT UNSIGNED DEFAULT 0 -- 0 ~ 255
);

INSERT INTO patients(name, age) VALUES("Sachiko", 34);

SELECT * FROM patients;
INSERT INTO patients(name, age) VALUES("Sachiko", 255);

INSERT INTO patients(id, name) VALUES(65536, "Yoshio");

ALTER TABLE patients MODIFY id MEDIUMINT UNSIGNED AUTO_INCREMENT; -- 0 ~ 16777215

SHOW FULL COLUMNS FROM patients;

-- heightカラム、 weightカラムの追加
ALTER TABLE patients ADD COLUMN(height FLOAT);

ALTER TABLE patients ADD COLUMN(weight FLOAT);

SELECT * FROM patients;

INSERT INTO patients(name, age, height, weight) VALUES("Taro", 44, 175.6789, 67.8934);


CREATE TABLE tmp_float(
  num FLOAT
);

INSERT INTO tmp_float VALUES(12345678);
SELECT * FROM tmp_float; -- 丸められる

CREATE TABLE tmp_double(
  num DOUBLE
);

INSERT INTO tmp_double VALUES(123456789.12345689);

SELECT * FROM tmp_double;
SELECT num+2, num FROM tmp_double;

-- DECIMAL(正確な値を使いたい時)
ALTER TABLE patients ADD COLUMN score DECIMAL(7, 3); -- 整数部:4, 少数部:3

SELECT * FROM patients;

INSERT INTO patients(name, age, score) VALUES("Jiro", 54, 32.456);

CREATE TABLE tmp_decimal(
  num_float FLOAT,
  num_double DOUBLE,
    num_decimal DECIMAL(20,10)
);

INSERT INTO tmp_decimal VALUES(1111111111.1111111111, 1111111111.1111111111, 1111111111.1111111111);

SELECT * FROM tmp_decimal;

SELECT num_decimal, (num_decimal * 2 + 2) FROM tmp_decimal;

-- 論理型
CREATE TABLE managers(
  id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
  is_superuser BOOLEAN
);

INSERT INTO managers (name, is_superuser) VALUES("Taro", true);

INSERT INTO managers (name, is_superuser) VALUES("Jiro", false);

SELECT * FROM managers WHERE is_superuser = false;


/* 日付型(DATE, TIME, DATETIME, TIMESTAMP) その１ */
-- DATE TIME
CREATE TABLE alerms(
  id INT PRIMARY KEY AUTO_INCREMENT,
  alerm_day DATE,
  alerm_time TIME,
  create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT CURRENT_TIMESTAMP, NOW(), CURRENT_DATE, CURRENT_TIME;

INSERT INTO alerms(alerm_day, alerm_time) VALUES("2019-01-01", "19:50:21");
INSERT INTO alerms(alerm_day, alerm_time) VALUES("2021/01/15", "195031");

SELECT * FROM alerms;
UPDATE alerms SET alerm_time = CURRENT_TIMESTAMP WHERE id = 1;

SELECT HOUR(alerm_time), alerm_time FROM alerms;   -- 時間だけ取得
SELECT MINUTE(alerm_time), alerm_time FROM alerms; -- 分だけ取得
SELECT SECOND(alerm_time), alerm_time FROM alerms; -- 秒だけ取得
SELECT MONTH(alerm_day), alerm_time FROM alerms;   -- 月だけ取得
SELECT DAY(alerm_day), alerm_time FROM alerms;     -- 日付だけ取得
SELECT DATE_FORMAT(alerm_day, '%Y'), alerm_time FROM alerms; -- DATE_FORMATで基本代替えできる

CREATE TABLE tmp_time (
  num TIME(5)
);

INSERT INTO tmp_time VALUES("21:05.54321");

SELECT * FROM tmp_time;


/* 日付型(DATE, TIME, DATETIME, TIMESTAMP) その2 */
-- DATETIME, TIMESTAMP
-- DATETIME, TIMESTAMP
CREATE TABLE tmp_datetime_timestamp (
  val_datetime DATETIME,
  val_timestamp TIMESTAMP,
  val_datetime_3 DATETIME(3),
  val_timestamp_3 TIMESTAMP(3)
);

INSERT INTO tmp_datetime_timestamp
VALUES(CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO tmp_datetime_timestamp
VALUES("2019/01/01 09:08:07.5432", "2019/01/01 09:08:07.5432", "2019/01/01 09:08:07.6578", "2019/01/01 09:08:07.6578");

SELECT * FROM tmp_datetime_timestamp ;

-- 1969/01/01 00:00:01 古い日付はtimestampに入れられない
INSERT INTO tmp_datetime_timestamp
VALUES("1969/01/01 00:00:01", "1969/01/01 00:00:01", "1969/01/01 00:00:01", "1969/01/01 00:00:01");

-- 2039/01/01 00:00:01 新しい日付はtimestampに入れられない
INSERT INTO tmp_datetime_timestamp
VALUES("2039/01/01 00:00:01", "2039/01/01 00:00:01", "2039/01/01 00:00:01", "2039/01/01 00:00:01");

-- DATETIME型は9999年まで入れられる
INSERT INTO tmp_datetime_timestamp
VALUES("9999/01/01 00:00:01", "2029/01/01 00:00:01", "2039/01/01 00:00:01", "2029/01/01 00:00:01");

/* インデックス */
/*
■インデックスとは
テーブルの特定のカラムに対する索引。インデックスを用いることで、特定のレコードへのアクセスを高速で行うことができるようになる。
・使用例
```
CREATE INDEX index_name ON table_name(column1, column2, .....) #インデックス作成
DROP INDEX index_name #インデックス削除
SHOW INDEX FROM table_name #テーブルにあるインデックス一覧
*/

SHOW TABLES;

SELECT * FROM students;

SHOW INDEX FROM students;

EXPLAIN SELECT * FROM students WHERE name = "Taro"; -- typeがALLであればフルスキャンであり、インデックスはられていない

CREATE INDEX idx_students_name ON students(name);
EXPLAIN SELECT * FROM students WHERE name = "Taro"; -- typeがrefになっていればインデックス使われている

-- 関数インデックス
CREATE INDEX idx_students_lower_name ON students((LOWER(name)));

EXPLAIN SELECT * FROM students WHERE LOWER(name) = "taro"

SHOW TABLES;

SELECT * FROM users;

-- ユニーク +  インデックス
CREATE UNIQUE INDEX idx_users_uniq_first_name ON users(first_name);

INSERT INTO users (id, first_name) VALUES(2, "ABC");
INSERT INTO users (id, first_name) VALUES(3, "ABC"); -- ユニークインデックスはっているので同じ値入れることできず、INSERTできない

