SHOW TABLES;

SELECT * FROM employees;

-- 部署一覧
SELECT * FROM department;

-- INで絞り込みむ
SELECT * FROM employees WHERE department_id IN(1,2);

-- 副問合せを使う
SELECT id FROM departments WHERE name IN("経営企画部", "営業部");

SELECT * FROM employees WHERE department_id NOT IN(SELECT id FROM departments WHERE name IN("経営企画部", "営業部"));

SELECT * FROM students;
SELECT * FROM users;


-- 複数カラムのIN(副問合せ)usersテーブルにあるfirst_name,last_nameをstudentsテーブルから取り出す
SELECT * FROM students
WHERE (first_name,last_name) IN(SELECT first_name, last_name FROM users);

-- 副問合せ3:集計と使う
SELECT MAX(age) FROM employees;

-- 年齢が最大の55より小さい人を取り出す
SELECT * FROM  employees WHERE age < (SELECT MAX(age) FROM employees);
