USE day_10_14_db;

SHOW TABLES;

SELECT * FROM employees;

/* ウィンドウ関数 PARTITION BYの利用 */

-- WINDOWS関数
SELECT *, AVG(age) OVER()
FROM employees;

-- PARTITION BY: 分割してその中で集計する
SELECT *, AVG(age) OVER(PARTITION BY department_id) AS avg_age,
COUNT(*) OVER(PARTITION BY department_id) AS count_department
FROM employees;

-- 年齢層毎に表示
SELECT DISTINCT CONCAT(COUNT(*) OVER(PARTITION BY FLOOR(age/10)),"人") AS age_count, FLOOR(age/10) * 10
FROM employees;

-- 年月ごとに集計
SELECT *, DATE_FORMAT(order_date, '%Y/%m'),
SUM(order_amount * order_price) OVER(PARTITION BY DATE_FORMAT(order_date, '%Y/%m'))
FROM orders;
