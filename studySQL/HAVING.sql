/* HAVINGとは、GROUP化して集計した結果に対しいて、絞り込みをする場合に用いるSQL */
-- HAVING
SELECT department, AVG(salary) FROM employees
GROUP BY department
HAVING AVG(salary) > 3980000


SELECT birth_place, age, COUNT(*) FROM users
GROUP BY birth_place, age
HAVING COUNT(*) > 2
ORDER BY COUNT(*);


-- HAVINGのみ(まず使うことない)
SELECT
  "重複なし"
FROM
  users
HAVING
  COUNT(DISTINCT name) = COUNT(NAME);

SELECT
  "重複なし" AS "check"
FROM
  users
HAVING
  COUNT(DISTINCT age) = COUNT(age);
