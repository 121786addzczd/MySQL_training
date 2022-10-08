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


/* パーティションとフレームについて */

-- ORDER BY
SELECT
*,
COUNT(*) OVER(ORDER BY age) AS tmp_count
FROM
employees;

SELECT *, SUM(order_price) OVER(ORDER BY order_date, customer_id) FROM orders;

SELECT
FLOOR(age /10),
COUNT(*) OVER(ORDER BY FLOOR(age / 10))
FROM employees;


/* PARTTION BYとORDER BYを併用する */

-- PARTITION BY + ORDER BY
SELECT *,
MIN(age) OVER(PARTITION BY department_id ORDER BY age) AS count_value
FROM employees;

-- 人毎の、最大収入
SELECT
*,
MAX(payment) OVER(PARTITION BY emp.id)
FROM employees AS emp
INNER JOIN salaries AS sa
ON emp.id = sa.employee_id;

-- 月ごとの、合計のemployeesのIDで昇順に並び替えて出す
SELECT
*,
SUM(sa.payment) OVER(PARTITION BY sa.paid_date ORDER BY emp.id)
FROM employees AS emp
INNER JOIN salaries AS sa
ON emp.id = sa.employee_id;
