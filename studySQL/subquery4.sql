-- CREATE SELECT insert
SHOW TABLES;

-- studentsの実行結果をtmp_students作成して格納
CREATE TABLE tmp_students
SELECT * FROM students;

SELECT * FROM tmp_students

-- カラムの設定などは反映されない
DESCRIBE tmp_students;

DESCRIBE students;

DROP TABLE tmp_students;

CREATE TABLE tmp_students
SELECT * FROM students WHERE id < 10;

SELECT * FROM tmp_students;

INSERT INTO tmp_students
SELECT id + 9 AS id, first_name, last_name, 2 AS grade FROM users;

-- それぞれのテーブルのfirst_name, last_nameの重複を削除して結合
CREATE TABLE names
SELECT first_name, last_name FROM students
UNION
SELECT first_name, last_name FROM employees
UNION
SELECT first_name, last_name FROM customers;

SELECT * FROM names;
