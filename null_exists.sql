-- EXITS(NULLの存在する場合)
SELECT * FROM customers AS c1
WHERE EXISTS
(
  SELECT * FROM customers_2 AS c2
    WHERE c1.first_name = c2.first_name
      AND c1.last_name = c2.last_name
      AND (c1.phone_number = c2.phone_number
      OR (c1.phone_number IS NULL AND c2.phone_number IS NULL))
)

-- NOT EXISTS
-- EXISTSで紐づかなかったレコードを取り出す
SELECT
    *
FROM
    customers AS c1
WHERE
    NOT EXISTS(
        SELECT
            *
        FROM
            customers_2 AS c2
        WHERE
            c1.first_name = c2.first_name
        AND c1.last_name = c2.last_name
        AND c1.phone_number = c2.phone_number
    );



-- NOT INの場合
-- first_name != customers_2.first_name OR last_name != customers_2.lastname OR phone_nuber != customers_2.phone_number
SELECT
    *
FROM
    customers AS c1
WHERE
    (first_name, last_name, phone_number) NOT IN(
        SELECT
            first_name,
            last_name,
            phone_number
        FROM
            customers_2
    )

-- EXISTSをINで書く
SELECT
    *
FROM
    customers AS c1
WHERE
    (first_name, last_name, phone_number) IN(
        SELECT
            first_name,
            last_name,
            phone_number
        FROM
            customers_2
    )

/* 複雑な結合 */
-- customers, orders, items, storesを紐づける
-- customers.idで並び替える(ORDER BY)

SELECT
  ct.id, ct.last_name, od.item_id, od.order_amount, od.order_price, od.order_date, it.name, st.name
FROM
 customers AS ct
INNER JOIN orders AS od
ON ct.id = od.customer_id
INNER JOIN items AS it
ON od.item_id = it.id
INNER JOIN stores AS st
ON it.store_id = st.id
ORDER BY ct.id;


-- customers, orders, items, storesを紐づける
-- customers.idで並び替える(ORDER BY)
-- customers.idが10で、orders.order_dateが2020-08-01よりあとに絞り込む(WHERE)
SELECT
  ct.id, ct.last_name, od.item_id, od.order_amount, od.order_price, od.order_date, it.name, st.name
FROM
 customers AS ct
INNER JOIN orders AS od
ON ct.id = od.customer_id
INNER JOIN items AS it
ON od.item_id = it.id
INNER JOIN stores AS st
ON it.store_id = st.id
WHERE ct.id = 10 AND od.order_date > "2020-08-01"
ORDER BY ct.id;


-- サブクエリ
SELECT
  ct.id, ct.last_name, od.item_id, od.order_amount, od.order_price, od.order_date, it.name, st.name
FROM
 (SELECT * FROM customers WHERE id = 10) AS ct
INNER JOIN (SELECT * FROM orders WHERE order_date > "2020-08-01") AS od
ON ct.id = od.customer_id
INNER JOIN items AS it
ON od.item_id = it.id
INNER JOIN stores AS st
ON it.store_id = st.id
ORDER BY ct.id;

-- GRUOP BYの紐付け
SELECT * FROM customers AS ct
INNER JOIN
  (SELECT customer_id, SUM(order_amount * order_price) AS summary_price
   FROM orders
GROUP BY customer_id) AS order_summary
ON ct.id = order_summary.customer_id
ORDER BY ct.age
LIMIT 5;

-- SELEF JOIN(自己結合)

SELECT
  CONCAT(emp1.last_name, emp1.first_name) AS "部下の名前",
  emp1.age AS "部下の年齢",
  COALESCE(CONCAT(emp2.last_name, emp2.first_name), "該当なし") AS "上司の名前",
  emp2.age as "上司の年齢"
FROM employees AS emp1
LEFT JOIN employees AS emp2
ON emp1.manager_id = emp2.id;

-- CROS JOIN
SELECT * FROM employees AS emp1
CROSS JOIN employees AS emp2
ON emp1.id < emp2.id;


-- 計算結果と　CASEで紐づけ
SELECT
*,
CASE
  WHEN cs.age > summary_customers.avg_age THEN "○"
  ELSE "×"
END AS "平均年齢よりも年齢が高いか"
FROM customers AS cs
CROSS JOIN(
SELECT AVG(age) AS avg_age FROM customers
) AS summary_customers


SELECT
emp.id,
AVG(payment),
summary.avg_payment,
CASE
  WHEN AVG(payment) >= summary.avg_payment THEN "○"
  ELSE "×"
END AS "平均月収以上か"
FROM employees AS emp
INNER JOIN salaries AS sa
ON emp.id = sa.employee_id
CROSS JOIN
(SELECT AVG(payment) AS avg_payment FROM salaries) AS summary
GROUP BY emp.id;
