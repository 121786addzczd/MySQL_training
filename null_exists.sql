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
