-- nameカラムの値がnullのみを取り出す
SELECT * FROM customers WHERE name IS NULL;

-- nameカラムの値が河野 文典,稲田 季雄もしくはNULLだけを取り出す
SELECT * FROM customers WHERE name IN ("河野 文典", "稲田 季雄") OR name IS NULL;

-- NOT IN
SELECT * FROM customers WHERE name NOT IN ("河野 文典", "稲田 季雄", NULL);

-- nullの人と河野 文典, 稲田 季雄以外を全て取り出す
SELECT * FROM customers WHERE name NOT IN ("河野 文典", "稲田 季雄") AND name IS NOT NULL;


-- NOT IN → name != "河野 文典" != 稲田 季雄 name != NULL

-- ALL
-- cutomerersテーブルからud<10のの誕生日よりも古い誕生日の人をusersから取り出すSQL
SELECT * FROM users WHERE birth_day <= ALL(SELECT birth_day FROM customers WHERE id < 10 AND birth_day IS NOT NULL);

-- ALLとINの場合はNULLに気をつける
