-- 副問合せ6:CASEと使う
SELECT * FROM departments WHERE name = "経営企画部"

SELECT
  emp.*,
  CASE
    zzWHEN emp.department_id = (SELECT id FROM departments WHERE name = "経営企画部")
  THEN "経営層"
  ELSE "その他"
  END AS "役割"
FROM
  employees AS emp

SELECT * FROM employees

SELECT
 emp.*,
 CASE
   WHEN emp.id IN(
      SELECT DISTINCT employee_id FROM  salaries WHERE payment > (SELECT AVG(payment) FROM salaries)
   ) THEN "○"
   ELSE "×"
   END AS "給料が平均より高いか"
FROM
employees emp
