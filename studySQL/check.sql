-- CHECK制約
CREATE TABLE customers (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  age INT CHECK(age >= 20)
);

INSERT INTO customers VALUES(1, "Taro", 21);
INSERT INTO customers VALUES(2, "Jiro", 19); -- 挿入できない
SELECT * FROM customers;


-- 複数のカラムに対するCHECK制約
CREATE TABLE students (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  age INT,
  gender CHAR(1),
  CONSTRAINT chk_students CHECK ((age >= 15 AND age <= 20) AND (gender = "F" OR gender = "M"))
);

INSERT INTO students VALUES(1, "Taro", 18, "M");

INSERT INTO students VALUES(3, "Sachiko", 14, "F");

CREATE TABLE employees (
  company_id INT,
  employee_code CHAR(255),
  name VARCHAR(255),
  age INT,
  PRIMARY KEY (company_id, employee_code)
);

INSERT INTO employees VALUE(1, "0000001", "Taro", 19);

INSERT INTO employees VALUE(NULL, "0000001", "Taro", 19);

INSERT INTO employees VALUE(1, "0000002", "Taro", 19);  -- 主キーの組み合わせが違えば登録できる

SELECT * FROM employees;

CREATE TABLE tmp_employees (
  company_id INT,
  employee_code CHAR(8),
  name VARCHAR(255),
  UNIQUE(company_id, employee_code)
);


