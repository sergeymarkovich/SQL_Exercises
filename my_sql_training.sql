




1.2.6
При анализе продаж книг выяснилось, что наибольшей популярностью пользуются книги Михаила Булгакова, на втором месте книги Сергея Есенина. 
Исходя из этого решили поднять цену книг Булгакова на 10%, а цену книг Есенина - на 5%. Написать запрос, куда включить автора, название книги и новую цену, последний столбец назвать new_price. 
Значение округлить до двух знаков после запятой.

/*
SELECT author, title, 
    CASE
        WHEN author = "Булгаков М.А." 
            THEN ROUND((price * 110 / 100), 2)
        WHEN author = "Есенин С.А."
            THEN ROUND((price * 105 / 100), 2)
        ELSE price
    END AS new_price
FROM book;
*/

SELECT author, title, 
    ROUND(IF(author = "Булгаков М.А.", (price * 110 / 100), IF(author = "Есенин С.А.", (price * 105 / 100), price)), 2) AS new_price
FROM book;

1.2.7
Вывести автора, название  и цены тех книг, количество которых меньше 10.

SELECT author, title, price 
FROM book
WHERE amount < 10;

1.2.8
Вывести название, автора,  цену  и количество всех книг, 
цена которых меньше 500 или больше 600, а стоимость всех экземпляров этих книг больше или равна 5000.

SELECT title, author, price, amount 
FROM book
WHERE ( price < 500 or price > 600) and (price * amount >= 5000);

1.2.9
Оператор BETWEEN позволяет отобрать данные, относящиеся к некоторому интервалу, включая его границы
Оператор  IN  позволяет выбрать данные, соответствующие значениям из списка.
Вывести название и авторов тех книг, цены которых принадлежат интервалу от 540.50 до 800 (включая границы),  а количество или 2, или 3, или 5, или 7 

SELECT title, author
FROM book
WHERE (price BETWEEN 540.50 AND 800) AND (amount IN (2, 3, 5, 7));

1.2.10
Логический порядок операций для запроса SQL следующий:
	FROM
	WHERE
	SELECT
	ORDER BY
ORDER BY column_name [ASC | DESC]

Вывести  автора и название  книг, количество которых принадлежит интервалу от 2 до 14 (включая границы). Информацию  отсортировать сначала по авторам (в обратном алфавитном порядке), а затем по названиям книг (по алфавиту).

SELECT author, title
FROM book
WHERE amount BETWEEN 2 AND 14
/*
ORDER BY 1 DESC, 2;
*/
ORDER BY author DESC, title;

1.2.11
Оператор LIKE используется для сравнения строк. В отличие от операторов отношения равно (=) и не равно (<>), 
LIKE позволяет сравнивать строки не на полное совпадение (не совпадение), а в соответствии с шаблоном. 
Шаблон может включать обычные символы и символы шаблоны. При сравнении с шаблоном, его обычные символы должны в точности совпадать с символами, указанными в строке. 
Символы шаблоны могут совпадать с произвольными элементами символьной строки

SELECT * FROM book WHERE author LIKE '%М.%'
выполняет поиск и выдает все книги, инициалы авторов которых содержат «М.»
SELECT * FROM book WHERE title LIKE 'Поэм_'
выполняет поиск и выдает все книги, названия которых либо «Поэма», либо «Поэмы» и пр.

 "_%" - сначала идет символ, а за ним любое количество символов;
"%_" - сначала идет любое количество символов, а затем обязательный символ;
"%_%" - сначала идет любое количество символов, потом обязательный символ, а за ним любое количество символов.

Вывести название и автора тех книг, название которых состоит из двух и более слов, а инициалы автора содержат букву «С». 
Считать, что в названии слова отделяются друг от друга пробелами и не содержат знаков препинания, между фамилией автора и инициалами обязателен пробел, 
инициалы записываются без пробела в формате: буква, точка, буква, точка. Информацию отсортировать по названию книги в алфавитном порядке.

SELECT title, author
FROM book
WHERE (title LIKE "%__ %__") AND (author LIKE "%С.%")
ORDER BY title ASC;

1.2.12

SELECT author, title, price AS real_price, amount,
	IF(price <= 500, 99.99, IF(amount < 5, 149.99, 0.00)) AS delivery_price,
	IF(price * amount > 5000, price * 120 / 100, price * 80 / 100) AS new_price

FROM book
WHERE (author LIKE "Булгаков%") AND (author LIKE "Есенин%") AND (amount BETWEEN 3 AND 14)
ORDER BY author ASC, title DESC, delivery_price ASC;

1.3.2
Отобрать различные (уникальные) элементы столбца amount таблицы book.

SELECT DISTINCT amount 
FROM book;
-------
SELECT amount 
FROM book
GROUP BY amount

1.3.3
COUNT(*) —  подсчитывает  все записи, относящиеся к группе, в том числе и со значением NULL;
COUNT(имя_столбца) — возвращает количество записей конкретного столбца (только NOT NULL), относящихся к группе
SUM(amount) - сумма значений в группе
Посчитать, количество различных книг и количество экземпляров книг каждого автора , хранящихся на складе. 
 Столбцы назвать Автор, Различных_книг и Количество_экземпляров соответственно.


SELECT author as Автор, COUNT(DISTINCT title) as Различных_книг, SUM(amount) as Количество_экземпляров
FROM book
GROUP BY author;

1.3.4
MIN(), MAX() и AVG() - вычисляют мин, макс и среднее
Вывести фамилию и инициалы автора, минимальную, максимальную и среднюю цену книг каждого автора.
Вычисляемые столбцы назвать Минимальная_цена, Максимальная_цена и Средняя_цена соответственно.

SELECT author, MIN(price) AS Минимальная_цена, MAX(price) AS Максимальная_цена, AVG(price) AS Средняя_цена
FROM book
GROUP BY author

1.3.5
Для каждого автора вычислить суммарную стоимость книг S (имя столбца Стоимость), а также вычислить налог на добавленную стоимость 
для полученных сумм (имя столбца НДС ) , который включен в стоимость и составляет k = 18%,  
а также стоимость книг  (Стоимость_без_НДС) без него. Значения округлить до двух знаков после запятой

SELECT author, SUM(price * amount) AS Стоимость, ROUND((SUM(price * amount)*0.18) / (1 + 0.18), 2) AS НДС,
ROUND(SUM(price * amount) / (1 + 0.18), 2) AS Стоимость_без_НДС
FROM book
GROUP BY author;

1.3.6
Вывести  цену самой дешевой книги, цену самой дорогой и среднюю цену уникальных книг на складе. 
Названия столбцов Минимальная_цена, Максимальная_цена, Средняя_цена соответственно. Среднюю цену округлить до двух знаков после запятой

SELECT MIN(price) AS 'Минимальная_цена', MAX(price) AS "Максимальная_цена", ROUND(AVG(DISTINCT price), 2) AS "Средняя_цена"
FROM book;

1.3.7
Вычислить среднюю цену и суммарную стоимость тех книг, количество экземпляров которых принадлежит интервалу от 5 до 14, включительно. 
Столбцы назвать Средняя_цена и Стоимость, значения округлить до 2-х знаков после запятой.

SELECT ROUND(AVG(price),2) AS "Средняя_цена", SUM(price * amount) AS "Стоимость"
FROM book
WHERE amount BETWEEN 5 AND 14;

1.3.8
Последовательность выполнения операций на сервере:
	MySQL: FROM => WHERE = SELECT = GROUP BY = HAVING = ORDER BY = LIMIT.   
	PostgreSQL: FROM => WHERE = GROUP BY = HAVING = SELECT = DISTINCT = ORDER BY = LIMIT.

Посчитать стоимость всех экземпляров каждого автора без учета книг «Идиот» и «Белая гвардия». 
В результат включить только тех авторов, у которых суммарная стоимость книг (без учета книг «Идиот» и «Белая гвардия») более 5000 руб. 
Вычисляемый столбец назвать Стоимость. Результат отсортировать по убыванию стоимости.


SELECT author, SUM(price * amount) AS "Стоимость"
FROM book
WHERE (title NOT LIKE "Идиот") AND (title NOT LIKE "Белая гвардия")
GROUP BY author
HAVING SUM(price * amount) > 5000
ORDER BY SUM(price * amount) DESC;

1.3.9

1.4.1
Вложенный запрос определяет минимальную цену книг во всей таблице (это 460.00), а затем в основном запросе для каждой записи проверяется, равна ли цена минимальному значению, если равна, информация о книге включается в результирующую таблицу запроса.
SELECT title, author, price, amount
FROM book
WHERE price = (
         SELECT MIN(price) 
         FROM book
      );

Вывести информацию (автора, название и цену) о  книгах, цены которых меньше или равны средней цене книг на складе. Информацию вывести в отсортированном по убыванию цены виде. Среднее вычислить как среднее по цене книги.

SELECT author, title, price
FROM book
WHERE price <= (
    SELECT AVG(price)
    FROM book
    )
ORDER BY price DESC;

1.4.2
Вывести информацию (автора, название и цену) о тех книгах, цены которых превышают минимальную цену книги на складе 
не более чем на 150 рублей в отсортированном по возрастанию цены виде.

SELECT author, title, price 
FROM book
WHERE ABS(price - (SELECT MIN(price) FROM book)) <= 150 
ORDER BY price ASC;

1.4.3
Вывести информацию (автора, книгу и количество) о тех книгах, количество экземпляров которых в таблице book не дублируется.

SELECT author, title, amount
FROM book
WHERE amount IN (
    SELECT amount
    FROM book
    GROUP BY amount
    HAVING count(amount) = 1
)

/* 1.4.4
Операторы ANY и ALL используются  в SQL для сравнения некоторого значения с результирующим набором вложенного запроса, состоящим из одного столбца. 
При этом тип данных столбца, возвращаемого вложенным запросом, должен совпадать с типом данных столбца (или выражения), с которым происходит сравнение.

amount > ANY (10, 12) эквивалентно amount > 10
amount < ANY (10, 12) эквивалентно amount < 12
amount = ANY (10, 12) эквивалентно (amount = 10) OR (amount = 12), а также amount IN  (10,12)

amount > ALL (10, 12) эквивалентно amount > 12
amount < ALL (10, 12) эквивалентно amount < 10
amount = ALL (10, 12) не вернет ни одной записи, так как эквивалентно (amount = 10) AND (amount = 12)

Вывести информацию о книгах(автор, название, цена), цена которых меньше самой большой 
из минимальных цен, вычисленных для каждого автора. */

SELECT author, title, price
FROM book
WHERE price < ANY (
    SELECT MIN(price)
    FROM book
    GROUP BY author
    );

/*
1.4.5
Посчитать сколько и каких экземпляров книг нужно заказать поставщикам, чтобы на складе стало одинаковое количество 
экземпляров каждой книги, равное значению самого большего количества экземпляров одной книги на складе. 
Вывести название книги, ее автора, текущее количество экземпляров на складе и количество заказываемых экземпляров книг. 
Последнему столбцу присвоить имя Заказ. В результат не включать книги, которые заказывать не нужно.
*/

SELECT title, author, amount, 
    ((SELECT MAX(amount) FROM book) - amount) as "Заказ"
FROM book
WHERE ((SELECT MAX(amount) FROM book) - amount > 0);

/*
1.5.2 
Создать таблицу поставка (supply), которая имеет ту же структуру, что и таблиц book.
*/

CREATE TABLE supply(
    supply_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8,2),
    amount INT
);

/*
1.5.3 Занесите в таблицу supply четыре записи
*/

INSERT INTO supply(title, author, price, amount)
VALUES
    ("Лирика", "Пастернак Б.Л.", 518.99, 2),
    ("Черный человек", "Есенин С.А.", 570.20, 6),
    ("Белая гвардия", "Булгаков М.А.", 540.50, 7),
    ("Идиот", "Достоевский Ф.М.", 360.80, 3);
SELECT * FROM supply;

/*
1.5.4
Добавление записей из другой таблицы
Добавить из таблицы supply в таблицу book, все книги, кроме книг, написанных Булгаковым М.А. и Достоевским Ф.М.
Задание нужно выполнить без вложенных запросов.
*/
INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE (author NOT LIKE "Булгаков М.А.") AND (author NOT LIKE "Достоевский Ф.М.");

SELECT * FROM book;

/*
1.5.5 Добавление записей, вложенные запросы
Занести из таблицы supply в таблицу book только те книги, авторов которых нет в  book.
С ИСПОЛЬЗОВАНИЕМ ВЛОЖЕННОГО ЗАПРОСА
*/

INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount 
FROM supply
WHERE author NOT IN (
    SELECT author
    FROM book
    );
    
SELECT * FROM book;

/*
1.5.6 Запросы на обновление
UPDATE таблица SET поле = выражение
Уменьшить на 10% цену тех книг в таблице book, количество которых принадлежит интервалу от 5 до 10, включая границы.
*/

UPDATE book
SET price = 0.9 * price
WHERE (amount BETWEEN 5 AND 10);

SELECT * FROM book;

/*
1.5.7 Запросы на обновление нескольких столбцов
UPDATE таблица SET поле1 = выражение1, поле2 = выражение2

В таблице book необходимо скорректировать значение для покупателя в столбце buy таким образом, 
чтобы оно не превышало количество экземпляров книг, указанных в столбце amount. 
А цену тех книг, которые покупатель не заказывал, снизить на 10%.
*/

UPDATE book
SET buy = IF(amount - buy < 0, amount, buy),
    price = IF(buy = 0, price * 0.9, price);

SELECT * FROM book;

/*
1.5.8 Запросы на обновление нескольких таблиц 
    для столбцов, имеющих одинаковые имена, необходимо указывать имя таблицы, к которой они относятся, 
например, book.price – столбец price из таблицы book, supply.price – столбец price из таблицы supply;
    все таблицы, используемые в запросе, нужно перечислить после ключевого слова UPDATE;
    в запросе обязательно условие WHERE, в котором указывается условие при котором обновляются данные.

*/
Для тех книг в таблице book , которые есть в таблице supply, 
не только увеличить их количество в таблице book ( увеличить их количество на значение столбца amountтаблицы supply), 
но и пересчитать их цену (для каждой книги найти сумму цен из таблиц book и supply и разделить на 2).

UPDATE book, supply 
SET book.amount = book.amount + supply.amount,
    book.price = (book.price + supply.price) / 2
WHERE book.title = supply.title AND book.author = supply.author;

SELECT * FROM book;

/*
1.5.9 Запросы на удаление
DELETE FROM таблица;    Этот запрос удаляет все записи из указанной после FROM таблицы.

Удалить из таблицы supply книги тех авторов, общее количество экземпляров книг которых в таблице book превышает 10.
*/

DELETE FROM supply
WHERE author IN 
    (
    SELECT author 
    FROM book
    WHERE amount > 10
    );

SELECT * FROM supply;

/*
1.5.10 Запросы на создание таблицы
    CREATE TABLE имя_таблицы AS
    SELECT ...

Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых в таблице book 
меньше среднего количества экземпляров книг в таблице book. В таблицу включить столбец   amount, 
в котором для всех книг указать одинаковое значение - среднее количество экземпляров книг в таблице book.
*/

CREATE TABLE ordering AS
    SELECT author, title, 
        (
            SELECT ROUND(AVG(amount))
            FROM book
        ) AS "amount"
    FROM book
    WHERE amount < (SELECT ROUND(AVG(amount)) FROM book);

SELECT * FROM ordering;

/* Таблица "Командировки"   */
CREATE TABLE trip
(
trip_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(30),
city VARCHAR(25),
per_diem DECIMAL(8,2),
date_first DATE,
date_last DATE
);

INSERT INTO trip VALUES
("1", "Баранов П.Е.", "Москва", "700", "2020-01-12", "2020-01-17"), 
("2", "Абрамова К.А.", "Владивосток", "450", "2020-01-14", "2020-01-27"), 
("3", "Семенов И.В.", "Москва", "700", "2020-01-23", "2020-01-31"), 
("4", "Ильиных Г.Р.", "Владивосток", "450", "2020-01-12", "2020-02-02"), 
("5", "Колесов С.П.", "Москва", "700", "2020-02-01", "2020-02-06"), 
("6", "Баранов П.Е.", "Москва", "700", "2020-02-14", "2020-02-22"), 
("7", "Абрамова К.А.", "Москва", "700", "2020-02-23", "2020-03-01"), 
("8", "Лебедев Т.К.", "Москва", "700", "2020-03-03", "2020-03-06"), 
("9", "Колесов С.П.", "Новосибирск", "450", "2020-02-27", "2020-03-12"), 
("10", "Семенов И.В.", "Санкт-Петербург", "700", "2020-03-29", "2020-04-05"), 
("11", "Абрамова К.А.", "Москва", "700", "2020-04-06", "2020-04-14"), 
("12", "Баранов П.Е.", "Новосибирск", "450", "2020-04-18", "2020-05-04"), 
("13", "Лебедев Т.К.", "Томск", "450", "2020-05-20", "2020-05-31"), 
("14", "Семенов И.В.", "Санкт-Петербург", "700", "2020-06-01", "2020-06-03"), 
("15", "Абрамова К.А.", "Санкт-Петербург", "700", "2020-05-28", "2020-06-04"), 
("16", "Федорова А.Ю.", "Новосибирск", "450", "2020-05-25", "2020-06-04"), 
("17", "Колесов С.П.", "Новосибирск", "450", "2020-06-03", "2020-06-12"), 
("18", "Федорова А.Ю.", "Томск", "450", "2020-06-20", "2020-06-26"), 
("19", "Абрамова К.А.", "Владивосток", "450", "2020-07-02", "2020-07-13"), 
("20", "Баранов П.Е.", "Воронеж", "450", "2020-07-19", "2020-07-25");
SELECT * FROM trip;

/*
Вывести из таблицы trip информацию о командировках тех сотрудников, фамилия которых заканчивается на букву «а»,
 в отсортированном по убыванию даты последнего дня командировки виде. 
 В результат включить столбцы name, city, per_diem, date_first, date_last
*/

SELECT name, city, per_diem, date_first, date_last
FROM trip 
WHERE (name LIKE "%а _._.")
ORDER BY date_last DESC;

/*
Вывести в алфавитном порядке фамилии и инициалы тех сотрудников, которые были в командировке в Москве.
*/

SELECT name
FROM trip
WHERE city = "Москва"
GROUP BY name
ORDER BY name ASC;

/*
Для каждого города посчитать, сколько раз сотрудники в нем были.  
Информацию вывести в отсортированном в алфавитном порядке по названию городов. Вычисляемый столбец назвать Количество.
*/

SELECT city, COUNT(city) AS "Количество"
FROM trip
GROUP BY city
ORDER BY city ASC;