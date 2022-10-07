-- UNION:　重複は削除(処理遅い)
SELECT * FROM new_students
UNION
SELECT * FROM students;

SELECT * FROM new_students
UNION
SELECT * FROM students
ORDER BY id;

-- UNION ALL　重複削除しない:
SELECT * FROM new_students
UNION ALL
SELECT * FROM students
ORDER BY id;


SELECT * FROM students WHERE id < 10
UNION ALL
SELECT * FROM new_students WHERE id > 250;


SELECT id, name FROM students WHERE id < 10
UNION
SELECT age, name FROM users WHERE id < 10
ORDER BY id;
