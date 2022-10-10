/*=======================================================
外部キー制約


=======================================================*/

/* 基本的な書き方 */
USE day_15_18_db;

SHOW TABLES;

DROP TABLE students;

CREATE TABLE schools(
  id INT PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE students(
  id INT PRIMARY KEY,
  name VARCHAR(255),
  age INT,
  school_id INT,
  FOREIGN KEY(school_id) REFERENCES schools(id)
);

INSERT INTO students VALUES(1, "Taro", 18, 1);
-- school_idに指し示す先がないと参照整合性エラー
INSERT INTO students VALUES(1, "Taro", 18, 1);
-- 参照整合性エラー
UPDATE schools SET id = 2;
-- 参照整合性エラー
DELETE FROM schools;
-- 参照整合性エラー
UPDATE students SET school_id = 3;

-- 複数のカラムに外部キーを設定
CREATE TABLE salaries(
  id INT PRIMARY KEY,
  company_id INT,
  employee_code CHAR(8),
  payment INT,
  paid_date DATE,
  FOREIGN KEY(company_id, employee_code) REFERENCES employees(company_id, employee_code)
);

SELECT * FROM employees;

-- 参照整合性エラー
INSERT INTO salaries VALUES(1, 1, "00000003", 1000, "2020-01-01");
-- employeesテーブルに参照する値があるのでデータ登録される
INSERT INTO salaries VALUES(1, 1, "00000001", 1000, "2020-01-01");
SELECT * FROM salaries;

/* 外部キー制約のオプション  ON UPDATE, ON DELETE */

/* -------------------------------------------------------------------
■ON DELETEのオプション一覧
  ON DELETEオプションを追加すると、参照先が削除された際の挙動を設定できる

FOREIGIN KEY(country_id)
REFERENCES countries(id)
ON DELETE CASCADE

オプション名  : 説明
----------------------------------------------------------------------
CASCADE     : 参照先が削除されると、外部キーに設定している行は同時に削除される
SET NULL    : 参照先が削除されると、外部キーに設定している行にはNULLが設定される
RESTRICT    : 参照先が削除されそうになると、エラーが発生する
SET DEFAULT : 参照先が削除されると、デフォルトの値が設定される
---------------------------------------------------------------------*/



/* --------------------------------------------------------------------------
■ON DELETEのオプション一覧
  外部キー作成時に、ON UPDATEオプションを追記すると、参照先が更新された際の挙動を設定できる

FOREIGIN KEY(country_id)
REFERENCES countries(id)
ON UPDATE CASCADE

オプション名  : 説明
------------------------------------------------------------------------------
CASCADE     : 参照先が更新されると、外部キーに設定している行は同時に更新される
SET NULL    : 参照先が更新されると、外部キーに設定している行にはNULLが設定される
RESTRICT    : 参照先が更新されそうになると、エラーが発生する
SET DEFAULT : 参照先が更新されると、デフォルトの値が設定される
-----------------------------------------------------------------------------*/

DESCRIBE students;

DROP TABLE students;

-- ONDELETE ON UPDATE追加
CREATE TABLE students(
  id INT PRIMARY KEY,
  name VARCHAR(255),
  age INT,
  school_id INT,
  FOREIGN KEY(school_id) REFERENCES schools(id)
  ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO students VALUES(1, "Taro", 18 ,1);
SELECT * FROM students;

SELECT * FROM schools;
UPDATE schools SET id = 3 WHERE id = 1;

DELETE FROM schools;

DROP TABLE students;
-- ONDELETE ON UPDATE追加(SET NULL)
CREATE TABLE students(
  id INT PRIMARY KEY,
  name VARCHAR(255),
  age INT,
  school_id INT,
  FOREIGN KEY(school_id) REFERENCES schools(id)
  ON DELETE SET NULL ON UPDATE SET NULL
);

INSERT INTO schools VALUES(2, "北高校");
INSERT INTO students VALUES (2, "Taro", 16, 2);

SELECT * FROM students;

UPDATE schools SET id =3 WHERE id = 1;

UPDATE students SET school_id = 3 WHERE school_id IS NULL;

SELECT * FROM schools;

DELETE FROM schools WHERE id = 3;

DROP TABLE students;
-- ONDELETE ON UPDATE追加(SET DEFALUT)
CREATE TABLE students(
  id INT PRIMARY KEY,
  name VARCHAR(255),
  age INT,
  school_id INT DEFAULT -1,
  FOREIGN KEY(school_id) REFERENCES schools(id)
  ON DELETE SET DEFAULT ON UPDATE SET DEFAULT
);


SELECT * FROM schools;

INSERT INTO schools VALUES(1, "北高校");

INSERT INTO students VALUES(1, "Taro", 17, 1);

SELECT * FROM students;
-- SET DEFAULTの場合UPDATEできない
UPDATE schools SET id = 3 WHERE id = 1;
