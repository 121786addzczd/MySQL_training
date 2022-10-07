-- 使用しているDB表示
SELECT DATABASE();

-- テーブル一覧
SHOW TABLES;

-- テーブル名変更
ALTER TABLE users RENAME TO users_table;

-- テーブル定義
DESCRIBE users_table;

-- カラムの削除
ALTER TABLE users_table DROP COLUMN message;

-- カラムの追加(ADD)
ALTER TABLE users_table
ADD post_code CHAR(8);

-- ageカラムの後ろにgenderカラムを追加
ALTER TABLE users_table
ADD gender CHAR(1) AFTER age;

-- 一番最初のカラム追加
ALTER TABLE users_table
ADD new_id INT FIRST;

-- new_idカラム削除
ALTER TABLE users_table DROP COLUMN new_id;

-- カラムの定義変更
ALTER TABLE users_table MODIFY name VARCHAR(50);

-- カラム名の変更(基本的にカラム名は英語ですが、今回は変更がわかりやすいよう日本語で書いています)
ALTER TABLE users_table CHANGE COLUMN name 名前 VARCHAR(50);

-- genderカラムを一番最後に移動する
ALTER TABLE users_table CHANGE COLUMN gender gender CHAR(1) AFTER post_code;

DESCRIBE users_table;

-- 主キーの削除
ALTER TABLE users_table DROP PRIMARY KEY;
