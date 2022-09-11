-- 算術演算子

-- + - * / %

SELECT 1 + 1;

SELECT name, age, age+3 AS age_3 FROM users LIMIT 10;


SELECT 10 - 5;

SELECT age-1 AS age_1 FROM users;

SELECT birth_day, birth_day+3 FROM users;

SELECT 3*5;

SELECT * FROM employees;

SELECT department, name, salary, salary*1.1 AS salay_next_ear FROM employees;

SELECT department, name, salary, salary*0.9 AS salay_next_year FROM employees;

SELECT 10 / 3;

SELECT salary / 10 FROM employees;

SELECT 10 % 3; -- 1

SELECT age % 12 FROM users;

-- CONCAT(文字の連結) ||
SELECT CONCAT(department, ":",name) AS "部署：名前" FROM employees;
SELECT CONCAT(name, "(",age,")") AS "名前(年齢)" FROM users;

-- NOW, CURDATE, DATE_FORMAT
SELECT NOW() AS "現在時刻";  -- 現在時刻
SELECT NOW() AS "現在時刻", name, age FROM users;

SELECT CURDATE(); -- 日付

SELECT DATE_FORMAT(NOW(), "%Y/%m/%d %H:%i:%s"); -- %Y 年, %m 月, %d 日
