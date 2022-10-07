SELECT DATABASE();

use my_db;

-- テーブル作成
CREATE TABLE people(
  id INT PRIMARY KEY,
  name VARCHAR(50),
  brith_day DATE DEFAULT "1990-01-01"
);

-- INSERT1
INSERT INTO people VALUES(1, "Taro", "2001-01-01");

-- SELECT
SELECT * FROM people;

# INSERTカラム指定
INSERT INTO people(id, name) VALUES(2, "Jiro");

-- シングルクォート
INSERT INTO people(id, name) VALUES(3, 'Saburo');

INSERT INTO people VALUES(4, 'Johon"s son', '2021-01-01');

INSERT INTO people VALUES(5, "Johon's son", '2021-01-01');

-- "の中に"
INSERT INTO people VALUES(6, "John''s son", '2021-01-01');


SHOW TABLES;

-- 全レコード、全カラム
SELECT * FROM people;

-- カラム一部
SELECT name, id, birth_day, name FROM people;

SELECT id AS "番号", name AS "名前" FROM people;

-- WHERE句
SELECT * FROM people WHERE id = 1;

-- UPDATE文
UPDATE people SET birth_day = "1900-01-01", name = "";

-- UPDATE where
UPDATE people SET name = "Taro", birth_day = "2000-01-01" WHERE id = 3;

-- idが4より大きい人が全てupdateされる
UPDATE people SET name = "Taro", birth_day = "2000-01-01" WHERE id > 4;

-- DELETE: レコード削除
DELETE FROM people WHERE id = 2;
-- idが4より大きいもの削除
DELETE FROM people WHERE id > 4;

-- 全削除
DELETE FROM people;







