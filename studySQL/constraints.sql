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



/* ALTER TABLEで制約を後から追加する */
/*---------------------------------------------------------------------
■UNIQUE制約を追加する
・書式
```
ALTER TABLE table_name
ADD [CONSTRAINT constraint_name] UNIQUE (column1, columun2, .....);
```

■制約を削除する
・書式
```
ALTER TABLE table_name DROP CONSTRAINT constraint_name;
```

■特定のテーブルの制約一覧を表示する
・書式
```
SELECT column_name, constraint_name, referenced_column_name,
referenced_table_name
FROM information_schrma.key_column_usage
WHERE table_name = 'TableName';
```
-----------------------------------------------------------------------*/

SELECT * FROM employees;

UPDATE employees SET name = "Jiro" WHERE employee_code ="00000002";

DESCRIBE employees;

-- uniqueの追加
ALTER TABLE employees ADD CONSTRAINT uniq_employees_name UNIQUE(name); -- 後から一意制約つける

-- 制約一覧を確認
SELECT
*
FROM information_schema.key_column_usage
WHERE
  table_name = "employees";

-- 制約の削除
ALTER TABLE employees DROP CONSTRAINT uniq_employees_name;

-- uniqueの追加
ALTER TABLE employees ADD CONSTRAINT uniq_employees_name UNIQUE(name, age);

SELECT * FROM employees;
-- nameとage同じ値が登録されているためINSERT失敗
INSERT INTO employees VALUES(2, "00000003", "Taro", 19);

-- このテーブルのCREATE分を確認することができる
SHOW CREATE TABLE employees;


/* 制約の追加(DEFAULT, CHECK, NOT NULL, 主キー, 外部キー) */
/*---------------------------------------------------------------------
■DEFAULTを追加する
ALTER TABLEとSET DEFAULTでデフォルト値を設定する
・書式
```
ALTER TABLE table_name
ALTER column_name SET DEFAULT default_value;
```

■NOTNULLを追加する
・書式
```
ALTER TABLEとMODIFYでNOT NULLを設定する
ALTER TABLE products MODIFY stocks INT NOT NULL
```

■CHECK制約を追加する
・書式
```
ALTER TABLE users ADD CONSTRAINT check_age CHECK (age >= 0);
```
-----------------------------------------------------------------------*/

-- DEFAULT追加
SELECT * FROM customers;

SHOW CREATE TABLE custmoers;

ALTER TABLE customers DROP CONSTRAINT custmers_chk_1;

DESCRIBE customers;

ALTER TABLE custmoers
ALTER age SET DEFAULT 20;

INSERT INTO customers(id, name) VALUES(2, "Jiro");

SELECT * FROM customers;

-- NOT NULLの追加
ALTER TABLE customers MODIFY name VARCHAR(255) NOT NULL;

INSERT INTO customers(id, name) VALUES(3, NULL);

-- CHECK 制約の追加
ALTER TABLE customers ADD CONSTRAINT check_age CHECK(age >= 20);

/*---------------------------------------------------------------------

■主キーを追加する
・書式
```
ALTER TABLE persons
ADD CONSTRAINT pk_person PRIMARY KEY(id, last_name);
```

■外部キーを追加する
・書式
```
ALTER TABLE users
ADD CONSTRAINT fk_grade_id
FOREIGN KEY (grade_id) REFERENCES grades(id);
```

-----------------------------------------------------------------------*/

DESCRIBE customers;

ALTER TABLE customers DROP PRIMARY KEY;

-- 主キーを追加
ALTER TABLE customers
ADD CONSTRAINT pk_customers PRIMARY KEY(id);

-- 外部キー
DESCRIBE students;

SHOW CREATE TABLE students;

ALTER TABLE students DROP CONSTRAINT students_ibfk_1;

ALTER TABLE students
ADD CONSTRAINT fk_schools_students
FOREIGN KEY(school_id) REFERENCES schools(id);


/* その他のオプション(AUTO_INCREMENT, コメント) */

-- AUTO_INCREMENT
CREATE TABLE animals(
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主キーのID(INT型)です',
  name VARCHAR(50) NOT NULL COMMENT '動物の名前です'
);

-- COMMENTの確認
SHOW FULL COLUMNS FROM animals;

INSERT INTO animals VALUES(NULL, "Dog");

SELECT * FROM animals;

INSERt INTO animals(name) VALUES("Cat");

-- 自動の値
SELECT AUTO_INCREMENT FROM information_schema.tables WHERE TABLE_NAME = "animals";

INSERT INTO animals VALUES(4, "Panda");

INSERT INTO animals VALUES(NULL, "Fish");

ALTER TABLE animals AUTO_INCREMENT = 100;

INSERT INTO animals VALUES(NULL, "Bird");

SELECT * FROM animals;

INSERT INTO animals(name)
SELECT "Snake"
UNION ALL
SELECT "Dino"
UNION ALL
SELECT "Gibra";

INSERT INTO animals(name)
SELECT name FROM animals;
