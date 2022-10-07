-- EXPECTをEXISTSで書く
SELECT * FROM customers
UNION
SELECT * FROM customers_2;

-- c1に存在してc2に存在しないレコードを取り出す
SELECT * FROM customers AS c1
WHERE NOT EXISTS(
  SELECT * FROM customers_2 AS c2
  WHERE
    c1.id = c2.id AND
    c1.first_name = c2.first_name AND
    c1.last_name = c2.last_name AND
    (c1.phone_number = c2.phone_number OR c1.phone_number IS NULL AND c2.phone_number IS NULL) AND
    c1.age = c2.age
);

-- INTERSECTをEXISTSで実装
-- 両方に存在するレコードを取り出す
SELECT * FROM customers AS c1
WHERE EXISTS(
  SELECT * FROM customers_2 AS c2
  WHERE
    c1.id = c2.id AND
    c1.first_name = c2.first_name AND
    c1.last_name = c2.last_name AND
    (c1.phone_number = c2.phone_number OR c1.phone_number IS NULL AND c2.phone_number IS NULL) AND
    c1.age = c2.age
);
