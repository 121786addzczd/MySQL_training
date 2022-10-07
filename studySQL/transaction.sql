DROP DATABASE `day_4_9_db`;

CREATE DATABASE `day_4_9_db`;

USE `day_4_9_db`;

SHOW TABLES;

SELECT * FROM users;


-- TRANSACTIONの開始
START TRANSACTION;

-- UPDATEの処理
UPDATE users SET name = "奥山 成美" WHERE id = 1;

SELECT * FROM users;

-- ROLLBACK(トランザクション開始前に戻す)
ROLLBACK;

-- COMMIT(トランザクションをDBに反映)
COMMIT;


-- ROLLBACK
ROLLBACK;

SELECT * FROM students;

-- id300を削除
DELETE FROM students WHERE id = 300;

-- AUTOCOMMIT確認
SHOW VARIABLES WHERE variable_name = "autocommit";

-- 自動でコミットしないようにする
SET AUTOCOMMIT = 0;

DELETE FROM students WHERE id = 299;

-- SQLの反映
COMMIT;

SELECT * FROM students ORDER BY id DESC LIMIT 10;

-- AUTOCOMMITを元に戻す
SET AUTOCOMMIT = 1;


START TRANSACTION;

SHOW TABLES;

SELECT * FROM customers;

-- 主キーでUPDATE(行ロック)
UPDATE customers SET age = 43 WHERE id = 1;

ROLLBACK;

START TRANSACTION;

-- テーブル全体のロックがかかる
UPDATE customers SET age = 42 WHERE name = "河野 文典";

ROLLBACK;

-- DELETE
START TRANSACTION;

-- 行ロック
DELETE FROM customers WHERE id = 1;
COMMIT;


--  INSERT
START TRANSACTION;

INSERT INTO customers VALUES(1, "田中一郎", 21, "1999-01-01");
SELECT * FROM customers;

COMMIT;


-- SELECTのロック
-- FOR SHARE(共有ロック)
-- FOR UPDATE(排他ロック)

START TRANSACTION;
SELECT * FROM customers WHERE id = 1 FOR SHARE;

ROLLBACK;

START TRANSACTION;
SELECT * FROM customers WHERE id = 1 FOR UPDATE;
ROLLBACK;

-- LOCK TABLE READ
LOOK TABLE customers READ;
SELECT * FROM customers;
UPDATE customers SET age = 42 WHERE id = 1;

UNLOCK TABLES;

-- LOOK TABLE WRITE
LOOK TABLE customers WRITE;
SELECT * FROM customers;
UPDATE customers SET age = 42 WHERE id = 1;

UNLOCK TABLES;


-- DEAD LOOK
START TRANSACTION

-- customers → users
UPDATE customers SET age = 42 WHERE id = 1;

UPDATE isers SET age = 12 WHERE id = 1;
