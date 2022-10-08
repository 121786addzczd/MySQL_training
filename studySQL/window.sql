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


-- salesテーブルのorder_price * order_amountの合計の７日間の平均を求める
-- まずは、日付毎の合計値を求める
-- 7日平均を求める
SELECT *,
SUM(order_price * order_amount) OVER(ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
FROM orders;

WITH daily_summary AS (
SELECT
  order_date, SUM(order_price * order_amount) AS sale
FROM
  orders
GROUP BY order_date
)
SELECT
  *,
  AVG(sale) OVER(ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) -- 6行前から現在の行まで
FROM
  daily_summary;


SELECT
*,
SUM(summary_salary.payment)
OVER(ORDER BY age RANGE BETWEEN 3 PRECEDING AND CURRENT ROW) AS p_summary
FROM employees AS emp
INNER JOIN
(SELECT
  employee_id,
  SUM(payment) AS payment
FROM salaries
  GROUP BY employee_id) AS summary_salary
ON emp.id = summary_salary.employee_id;
