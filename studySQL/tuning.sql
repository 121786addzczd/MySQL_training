SHOW TABLES;

SELECT * FROM customers;

-- バインド変数
SET @customer_id = 5;
SELECT * FROM customers WHERE id = @customer_id;
