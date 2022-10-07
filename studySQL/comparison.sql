SELECT DATABASE();

-- STUDENTSテーブルの作成
CREATE TABLE students(
  id INT PRIMARY KEY,
  name CHAR(10)
);

-- CHAR型は末尾のスペースが削除される
INSERT INTO students VALUES(1, "ABCDEF  ");

SELECT * FROM students;

-- CHAR => VARCHAR
ALTER TABLE students MODIFY name VARCHAR(10);

INSERT INTO students VALUES(2, "ABCDEF  ");

-- 文字の長さ確認
SELECT name, CHAR_LENGTH(name) FROM students;
