-- ROUNOD, FLOOR, CEILING

--- けた数を指定せず、小数点1桁を四捨五入
SELECT ROUND(3.14); -- 3と表示

-- 小数点以下1桁目まで残し、小数点2桁目を四捨五入
SELECT ROUND(3.14,1); -- 3.1と表示

-- 整数1桁目を四捨五入
SELECT ROUND(956, -1); -- 960と表示

-- 小数点以下を切り捨て
SELECT FLOOR(3.14); -- 3と表示

-- 小数点以下を切り上げ
SELECT CEILING(3.14); -- 4と表示


-- 0~1のランダム値
SELECT RAND();

-- 0~9のランダム値
SELECT FLOOR(RAND() * 10);

-- 2~11のランダム価
SELECT FLOOR(RAND() * 10) + 2;

-- power
SELECT POWER(3,4); -- べき乗

SELECT weight / POWER(height/100,2) AS BMI FROM students;


-- COALESCE: NULLではない最初の値を返す
SELECT * FROM tests_score;

SELECT COALESCE(NULL, NULL, NULL, "A", NULL, "B");

SELECT COALESCE(test_score_1, test_score_2, test_score_3), test_score_1, test_score_2, test_score_3 AS SCORE FROM tests_score;
