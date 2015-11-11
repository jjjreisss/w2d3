DROP TABLE IF EXISTS users;

CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255),
  lname VARCHAR(255)
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  body VARCHAR(255) NOT NULL,
  subject_question INTEGER NOT NULL,
  parent_reply INTEGER,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(subject_question) REFERENCES questions(id),
  FOREIGN KEY(parent_reply) REFERENCES replies(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ('Johnny', 'Reis'),
  ('Juraj', 'Cech'),
  ('Mr', 'Happy');

INSERT INTO
  questions(title, body, user_id)
VALUES
  ('Reproduction?', 'How does babby formed?',
    (SELECT id FROM users WHERE fname = 'Johnny' AND lname = 'Reis')),
  ('Hunting?', 'Em are ducks?',
    (SELECT id FROM users WHERE fname = 'Juraj' AND lname = 'Cech')),
  ('Name?', 'What is your name?', 1);

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Johnny' AND lname = 'Reis'), 2),
  ((SELECT id FROM users WHERE fname = 'Juraj' AND lname = 'Cech'), 1),
  ((SELECT id FROM users WHERE fname = 'Juraj' AND lname = 'Cech'), 2),
  (1, 3),
  (2, 3),
  (3, 3);

INSERT INTO
  replies(body, subject_question, parent_reply, user_id)
VALUES
  ('Em got wangz', 2, NULL, 1),
  ('Babby is formed', 1, NULL, 2),
  ('EM ARE DUCKS!', 2, 1, 2);

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  (1,1),
  (1,2),
  (2,2),
  (3,2),
  (1,3),
  (3,3);
