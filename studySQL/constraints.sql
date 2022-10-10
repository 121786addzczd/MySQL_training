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
