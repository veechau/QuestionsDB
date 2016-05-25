DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL

);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)

);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)

);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  asker_id INTEGER NOT NULL,
  parent_id INTEGER,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (asker_id) REFERENCES users(id)

);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  likes INTEGER,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)

);


INSERT INTO
  users (fname, lname)
VALUES
  ('Kia' , 'Salehi'),
  ('Veronica', 'Chau'),
  ('A', 'B'),
  ('C', 'D'),
  ('E','F');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Sky Question', 'Why is the sky blue?', (SELECT id FROM users WHERE fname ='Kia')),
  ('Tired Question', 'Where''s the coffee?', (SELECT id FROM users WHERE fname = 'Veronica'));

INSERT INTO
  replies (body, asker_id, parent_id, question_id)
VALUES
  ('Because SCIENCE', (SELECT id FROM users WHERE fname ='Kia'), Null, (SELECT id FROM questions WHERE title = 'Sky Question')),
  ('Never close enough', (SELECT id FROM users WHERE fname ='Veronica'), Null, (SELECT id FROM questions WHERE title = 'Tired Question'));

INSERT INTO
  question_likes (likes, user_id, question_id)
VALUES
  (1, (SELECT id FROM users WHERE fname ='Kia'), (SELECT id FROM questions WHERE title = 'Sky Question')),
  (NULL, (SELECT id FROM users WHERE fname = 'Veronica'), (SELECT id FROM questions WHERE title = 'Tired Question')),
  (1, (SELECT id FROM users WHERE fname ='A'), 1),
  (1, (SELECT id FROM users WHERE fname ='C'), 1),
  (1, (SELECT id FROM users WHERE fname ='E'), 1);

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1, (SELECT id FROM questions WHERE title = 'Sky Question')),
  (2, (SELECT id FROM questions WHERE title = 'Sky Question'));
