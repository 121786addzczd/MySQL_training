# 使用するデータベースを選択する
USE my_db;

# 使用しているデータベースを表示する
SELECT DATABASE();

# テーブル作成
CREATE TABLE `users`(
  id INT PRIMARY KEY,  -- idカラムINT型
  name VARCHAR(10), -- namae,可変長文字列
  age INT,
  phone_number CHAR(13), -- 固定長
  message TEXT
)

# テーブル一覧を表示
SHOW TABLES;

# テーブル定義の確認
DESCRIBE users;

# テーブル削除
DROP TABLE users;
