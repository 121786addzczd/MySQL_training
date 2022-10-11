USE day_10_14_db;

SHOW TABLES;

-- VIEWを作成
CREATE VIEW stores_items_view AS
SELECT st.name AS store_name, it.name AS item_name FROM stores AS st
INNER JOIN items AS it
ON it.store_id = st.id;


SELECT * FROM stores_items_view;

UPDATE items SET name = "new Item 山田1" WHERE name = "Item 山田 1";

-- TABLE Viewの一覧
SHOW TABLES;

SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_SCHEMA = "day_10_14_db";

-- VIEWの詳細
SHOW CREATE VIEW stores_items_view;

/*
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%
` SQL SECURITY DEFINER VIEW `stores_items_view` AS select `st`.`name` AS `store_name`,`it`.`name` AS `item_name`
from (`stores` `st` join `items` `it` on((`it`.`store_id` = `st`.`id`)))
*/

-- 絞り込み
SELECT * FROM stores_items_view WHERE store_name = "山田商店";

SELECT * FROM stores_items_view ORDER BY store_name;

SELECT store_name, COUNT(*) FROM stores_items_view GROUP BY store_name ORDER BY store_name;

-- Viewの削除
DROP VIEW stores_items_view;

-- VIEWの定義変更
ALTER VIEW stores_items_view AS
SELECT st.id AS store_id, it.id AS item_id, st.name AS store_name, it.name AS item_name FROM stores AS st
INNER JOIN items AS it
ON it.store_id = st.id;

SELECT * FROM stores_items_view;

-- VIEWの名前変更
RENAME TABLE stores_items_view TO new_stores_items_view;

SHOW TABLES;
