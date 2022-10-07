SHOW TABLES;

DESCRIBE people;

ALTER TABLE people ADD age INT AFTER name;

INSERT INTO people VALUES(1,"John", 18, "2004-01-01");
INSERT INTO people VALUES(2,"Alice", 15, "2007-06-05");
INSERT INTO people VALUES(3,"Paul", 19, "2003-12-11");
INSERT INTO people VALUES(4,"Chris", 17, "2005-10-15");
INSERT INTO people VALUES(5,"Vette", 20, "2002-01-24");
INSERT INTO people VALUES(6,"Julius", 21, "2001-03-28");
INSERT INTO people VALUES(7,"Keen", 18, "2004-01-01");


SELECT * FROM people;

-- 年齢順に並び変えて昇順表示
SELECT * FROM people ORDER BY age;

-- 年齢順に並び変えて降順表示
SELECT * FROM people ORDER BY age DESC;

-- nameで並び替え(アルファベット順)
SELECT * FROM people ORDER BY name;

-- 2つカラム
SELECT * FROM people ORDER BY birth_day DESC, name DESC;

-- ASC:昇順
-- DESC:降順

-- DISNTICT
SELECT DISTINCT birth_day FROM people ORDER BY birth_day;

-- nameとbirth_dayが重複しているのは表示しない
SELECT DISTINCT name, birth_day FROM people;

-- LIMITは最初の行だけ表示
SELECT id, name, age FROM people LIMIT 3;

-- 飛ばして表示(id1,2,3とばして4,5表示)
SELECT * FROM people LIMIT 3, 2;
SELECT * FROM people LIMIT 2 OFFSET 3;

