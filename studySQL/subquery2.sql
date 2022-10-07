-- FROMで用いる副問合せ4
SELECT department_id, AVG(age) AS avg_age FROM employees GROUP BY department_id;

SELECT
  MAX(avg_age) AS "部署ごとの平均年齢の最大",
  MIN(avg_age) AS "平均年齢の最小値"
FROM
  (SELECT department_id, AVG(age) AS avg_age FROM employees GROUP BY department_id) AS tmp_emp

-- 年代の集計
SELECT
  MAX(age_count), MIN(age_count)
FROM
  (SELECT FLOOR(age/10)*10, COUNT(*) AS age_count FROM employees
  GROUP BY FLOOR(age/10)) AS age_summary;

-- 副問合せ5:SELECTの中に書く
SELECT * FROM customers;

SELECT * FROM orders;

SELECT
    cs.id,
    cs.first_name,
    cs.last_name,
    (
        SELECT
            MAX(order_date)
        FROM
            orders AS order_max
        WHERE
            cs.id = order_max.customer_id
    ) AS "最近の注文日",
    (
        SELECT
            MIN(order_date)
        FROM
            orders AS order_max
        WHERE
            cs.id = order_max.customer_id
    ) AS "古い注文日",
    (
        SELECT
            SUM(order_amount * order_price)
        FROM
            orders AS tmp_order
        WHERE
            cs.id = tmp_order.customer_id
    ) AS "全支払い金額"
FROM
    customers AS cs
WHERE
    cs.id < 10;
