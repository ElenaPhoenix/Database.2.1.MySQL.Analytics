DROP DATABASE IF EXISTS lesson_4;
CREATE DATABASE lesson_4;
USE lesson_4;

-- Создадим две таблицы — tbl1 и tbl2, которые будут содержать единственный столбец value:
CREATE TABLE tbl1 (
  value VARCHAR(255)
);
INSERT INTO tbl1
  VALUES ('fst1'), 
         ('fst2'), 
         ('fst3');

CREATE TABLE tbl2 (
  value VARCHAR(255)
);
INSERT INTO tbl2
  VALUES ('snd1'), 
		 ('snd2'), 
		 ('snd3');


-- Посмотрим содержимое таблиц.
SELECT * FROM tbl1;
SELECT * FROM tbl2;

-- Чтобы создать соединение этих двух таблиц, 
-- их имена следует перечислить после ключевого слова FROM через запятую.

SELECT * FROM tbl1, tbl2;
SELECT * FROM tbl1 JOIN tbl2;
SELECT * FROM tbl1 CROSS JOIN tbl2;


-- Если мы попробуем явно запросить поле value, мы получим сообщение об ошибке:
SELECT value FROM tbl1, tbl2;

-- СУБД не может определить, столбец какой таблицы — tbl1 или tbl2 — имеется в виду. 
-- Чтобы исключить неоднозначность, можно использовать квалификационные имена:

SELECT tbl1.value, tbl2.value 
  FROM tbl1, tbl2;


-- Для символа звездочки также можно использовать квалификационное имя:
SELECT tbl1.*, tbl2.* 
  FROM tbl1, tbl2;


-- -----------------------------
-- Поработаем с двумя таблицами
CREATE TABLE IF NOT EXISTS teacher (	
  id INT NOT NULL PRIMARY KEY,
  surname VARCHAR(45),
  salary INT
);

INSERT teacher
  VALUES
	(1, "Авдеев", 17000),
    (2, "Гущенко", 27000),
    (3, "Пчелкин", 32000),
    (4, "Питошин", 15000),
    (5, "Вебов", 45000),
    (6, "Шарпов", 30000),
    (7, "Шарпов", 40000),
    (8, "Питошин", 30000);
    

CREATE TABLE IF NOT EXISTS lesson (	
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  course VARCHAR(45),
  teacher_id INT,
  FOREIGN KEY (teacher_id) REFERENCES teacher(id)
);

INSERT INTO lesson(course,teacher_id)
  VALUES
	("Знакомство с веб-технологиями", 1),
    ("Знакомство с веб-технологиями", 2),
    ("Знакомство с языками программирования", 3),
    ("Базы данных и SQL", 4); -- Учитель, который ведет данный предмет, временно отстутствует

SELECT * FROM teacher;
SELECT * FROM lesson;


SELECT * 
  FROM teacher JOIN lesson;

SELECT surname, course, teacher_id, lesson.id
  FROM teacher JOIN lesson;
  
  
-- Нам редко требуется выводить всевозможные комбинации строк соединяемых таблиц. 
-- Чаще количество строк в результирующей таблице ограничивается при помощи условия

-- Получим инфо о учителях и курсах, которые они ведут 
SELECT t.surname, l.course, l.teacher_id, t.id
  FROM teacher t -- teacher = t
  JOIN lesson l -- lesson = l
WHERE l.teacher_id =  t.id; -- Условие сое-я


-- При использовании соединения вместо WHERE-условия используется ON:
-- Получим инфо о учителях и курсах, которые они ведут 
SELECT t.surname, l.course, l.teacher_id, t.id
  FROM teacher t -- teacher = t
  JOIN lesson l -- lesson = l
ON l.teacher_id =  t.id; -- Условие сое-я


-- Получим фамилию учителей, зп и курсы, которые они ведут в 1 строчке
SELECT t.id,
	   CONCAT(t.surname, ", зп: ", t.salary, ", ведет курс: ", l.course) AS "Информация"
  FROM teacher t -- teacher = t
  JOIN lesson l -- lesson = l
ON l.teacher_id =  t.id; -- Условие сое-я


-- Неявное соединение таблиц 
SELECT t.id,
	   CONCAT(t.surname, ", зп: ", t.salary, ", ведет курс: ", l.course) AS "Информация"
  FROM teacher t -- teacher = t
  JOIN lesson l -- lesson = l
WHERE l.teacher_id =  t.id; -- Условие сое-я


-- Получим всех учителей, даже если они ничего не ведут
SELECT *
  FROM teacher t -- teacher = t
  LEFT JOIN lesson l -- lesson = l
	ON l.teacher_id =  t.id;

-- Получим всех учителей, даже если они ничего не ведут
SELECT t.surname, l.course, l.teacher_id, t.id
  FROM teacher t -- teacher = t
  LEFT JOIN lesson l -- lesson = l
	ON l.teacher_id =  t.id; -- Условие сое-я


-- Получим учителей, которые халявничают
SELECT t.surname, l.course, l.teacher_id, t.id
  FROM teacher t -- teacher = t
  LEFT JOIN lesson l -- lesson = l
	ON l.teacher_id = t.id
WHERE l.teacher_id IS NULL;


UPDATE teacher t -- teacher = t
  LEFT JOIN lesson l -- lesson = l
	ON l.teacher_id = t.id
SET t.surname = CONCAT(t.surname, " ", "(Он вообще ничего не сделал)"),
	t.salary = t.salary - t.salary * 0.25
WHERE l.teacher_id IS NULL;

SELECT * FROM teacher;


-- Получим учителей, которые ведут "Знакомство с веб-технологиями"
-- 1. JOIN
SELECT t.surname, l.course, l.teacher_id, t.id
  FROM teacher t 
  JOIN lesson l
	ON l.teacher_id = t.id
WHERE l.course = "Знакомство с веб-технологиями";

SELECT * FROM lesson;
SELECT * FROM teacher;


-- Если мы не хотим удалять из таблицы teacher записи, 
-- то после ключевого слова DELETE мы должны указать только одну таблицу lesson.
DELETE t, l
  FROM teacher t 
  JOIN lesson l
	ON l.teacher_id = t.id
WHERE l.course = "Базы данных и SQL";



SELECT *
  FROM lesson 
WHERE course = "Знакомство с веб-технологиями";

SELECT *
  FROM (SELECT * FROM lesson WHERE course = "Знакомство с веб-технологиями" ) l;

-- JOIN для через вложенный запрос
-- Получим имя преподавателей по курсу Знакомство с веб-технологиями
SELECT t.*, w_l.*
  FROM teacher t 
	JOIN (SELECT course, teacher_id 
			FROM lesson 
		  WHERE course = "Знакомство с веб-технологиями") AS w_l
	  ON t.id = w_l.teacher_id; 
      

-- _______________
-- UNION
-- _______________

DROP TABLE IF EXISTS t1;
CREATE TABLE IF NOT EXISTS t1 (
  id INT PRIMARY KEY
);

DROP TABLE IF EXISTS t2;
CREATE TABLE IF NOT EXISTS t2 (
  id INT PRIMARY KEY
);

INSERT INTO t1 VALUES (1),(2),(3);
INSERT INTO t2 VALUES (2),(3),(4);

-- UNION
SELECT id FROM t1
  UNION
SELECT id FROM t2;

-- UNION ALL
SELECT id FROM t1
  UNION ALL
SELECT id FROM t2;


SELECT id
FROM teacher -- id = 1 - 8 (первые 8 строчек - id из таблицы teacher)
  UNION ALL
SELECT teacher_id
FROM lesson; -- id = 1-4
