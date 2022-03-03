/*
	Связь «один ко многим»
Она означает, что каждый автор написал несколько книг, но каждую книгу написал только один автор.
На самом деле, это не совсем верное утверждение. Например, книга «12 стульев» написана двумя авторами Ильфом И.А. и Петровым Е.П. 
С другой стороны, эти авторы написали и другие книги, например «Золотой теленок».
	
Для соединения таких таблиц используется связь «многие ко многим».
Создать новую таблицу-связку, состоящую из двух столбцов, соответствующих по имени и типу ключевым столбцам исходных таблиц. 
Каждый из этих столбцов является внешним ключом (FOREIGN KEY)  и связан с ключевым столбцом каждой таблицы. 
Для наглядности связи на схеме обозначаются стрелкой от ключевого столбца исходной таблицы к внешнему ключу связной таблицы.
Дальше необходимо определиться с первичным ключом таблицы-связки. 
В некоторых случаях записи в таблице-связке могут повторяться, например, если мы будем продавать книги покупателям 
(один человек может купить несколько книг, а одну и ту же книгу могут купить несколько человек). 
Тогда в таблицу-связку включают дополнительные столбцы для идентификации записей, например, дату продажи,  
также в таблицу-связку добавляют первичный ключ.

- один определенный объект  ———>  много объектов
- много объектов <———> много объектов
*/

CREATE TABLE author(
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(50)
    );
INSERT INTO author(name_author) VALUES 
    ("Булгаков М.А."), 
    ("Достоевский Ф.М."),
    ("Есенин С.А."),
    ("Пастернак Б.Л.");
SELECT * FROM author;

/* Создание таблицы с внешними ключами
При создании зависимой таблицы (таблицы, которая содержит внешние ключи) необходимо учитывать, что :
	- каждый внешний ключ должен иметь такой же тип данных, как связанное поле главной таблицы (в наших примерах это INT);
	- необходимо указать главную для нее таблицу и столбец, по которому осуществляется связь:
FOREIGN KEY (связанное_поле_зависимой_таблицы)  
REFERENCES главная_таблица (связанное_поле_главной_таблицы)
	Для внешних ключей рекомендуется устанавливать ограничение NOT NULL
*/
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8,2),
    amount INT,
    FOREIGN KEY (author_id) REFERENCES author (author_id),
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id)
    );
SHOW COLUMNS FROM book;
/* Действия при удалении записи главной таблицы
С помощью выражения ON DELETE можно установить действия, которые выполняются для записей подчиненной таблицы при удалении 
связанной строки из главной таблицы. При удалении можно установить следующие опции:
	- CASCADE: автоматически удаляет строки из зависимой таблицы при удалении  связанных строк в главной таблице.
	- SET NULL: при удалении  связанной строки из главной таблицы устанавливает для столбца внешнего ключа значение NULL. 
(В этом случае столбец внешнего ключа должен поддерживать установку NULL).
	- SET DEFAULT похоже на SET NULL за тем исключением, что значение  внешнего ключа устанавливается не в NULL, а в значение по умолчанию для данного столбца.
	- RESTRICT: отклоняет удаление строк в главной таблице при наличии связанных строк в зависимой таблице.

здать таблицу book той же структуры, что и на предыдущем шаге. Будем считать, что при удалении автора из таблицы author, 
должны удаляться все записи о книгах из таблицы book, написанные этим автором. А при удалении жанра из таблицы genre для 
соответствующей записи book установить значение Null в столбце genre_id.
*/
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL, 
    genre_id INT,
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE SET NULL
);
SHOW COLUMNS FROM book;




/* Соединение INNER JOIN
	-каждая строка одной таблицы сопоставляется с каждой строкой второй таблицы;
	-для полученной «соединённой» строки проверяется условие соединения;
	-если условие истинно, в таблицу результата добавляется соответствующая «соединённая» строка;
SELECT
 ...
FROM
    таблица_1 INNER JOIN  таблица_2
    ON условие (таблица_2.столбец_PrimaryKey = таблица1.столбец_ForeignKey)

Вывести название, жанр и цену тех книг, количество которых больше 8, в отсортированном по убыванию цены виде.
*/
SELECT title, name_genre, price FROM book
INNER JOIN genre ON genre.genre_id = book.genre_id
WHERE amount > 8
ORDER BY price DESC;


/* Внешнее соединение LEFT и RIGHT OUTER JOIN
Вывести все жанры, которые не представлены в книгах на складе.
*/
SELECT name_genre FROM genre
LEFT JOIN book ON book.genre_id = genre.genre_id
WHERE book.genre_id IS NULL;


/*Перекрестное соединение CROSS JOIN
SELECT
 ...
FROM
    таблица_1 CROSS JOIN  таблица_2
...

или

SELECT
 ...
FROM
    таблица_1, таблица_2
...
    
    Необходимо в каждом городе провести выставку книг каждого автора в течение 2020 года. 
Дату проведения выставки выбрать случайным образом. Создать запрос, который выведет город, автора и дату проведения выставки. 
Последний столбец назвать Дата. Информацию вывести, отсортировав сначала в алфавитном порядке по названиям городов, 
а потом по убыванию дат проведения выставок
*/
SELECT name_city, name_author, DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND()*360) DAY) AS 'Дата'
FROM author CROSS JOIN city
ORDER BY name_city ASC, Дата DESC;

/* Запросы на выборку из нескольких таблиц
 Вывести информацию о книгах (жанр, книга, автор), относящихся к жанру, включающему слово «роман» в отсортированном по названиям книг виде.
*/

SELECT name_genre, title, name_author 
FROM genre
    INNER JOIN book ON genre.genre_id = book.genre_id
    INNER JOIN author ON author.author_id = book.author_id
WHERE name_genre LIKE 'Роман'
ORDER BY title ASC;

/* Запросы для нескольких таблиц с группировкой
Посчитать количество экземпляров  книг каждого автора из таблицы author.  
Вывести тех авторов,  количество книг которых меньше 10, в отсортированном по возрастанию количества виде. 
Последний столбец назвать Количество.
*/

SELECT name_author, SUM(book.amount) AS 'Количество'
FROM author
    LEFT JOIN book ON author.author_id = book.author_id
GROUP BY name_author
HAVING SUM(amount) < 10 OR SUM(book.title) IS NULL
ORDER BY Количество ASC;

/*Запросы для нескольких таблиц со вложенными запросами
 Вывести в алфавитном порядке всех авторов, которые пишут только в одном жанре. 
 Поскольку у нас в таблицах так занесены данные, что у каждого автора книги только в одном жанре,  
 для этого запроса внесем изменения в таблицу book. Пусть у нас  книга Есенина «Черный человек» относится к жанру «Роман», 
 а книга Булгакова «Белая гвардия» к «Приключениям» (эти изменения в таблицы уже внесены).

Шаг 1 - отбираем ID авторов и ID жанров 

    SELECT author_id, COUNT(DISTINCT genre_id) AS genre_id FROM book
    GROUP BY author_id;

Шаг 2 - отбираем ID авторов у которых книга в одном жанре, чтобы потом по этому запросу сделать WHERE = "этому запросу"

    SELECT MIN(genre_id) 
    FROM(
        SELECT author_id, COUNT(DISTINCT genre_id) AS genre_id FROM book
        GROUP BY author_id
    ) genre_min

Шаг 3 - Выводим авторов по фамилии и genre_id 

    SELECT name_author FROM author
    INNER JOIN book ON author.author_id = book.author_id
    GROUP BY name_author

Шаг 4 - Включим запрос с шага 2 в условие отбора запроса с шага 3 и получим результат 

    SELECT name_author FROM author
    INNER JOIN book ON author.author_id = book.author_id
    GROUP BY name_author    
    HAVING COUNT(DISTINCT genre_id) = 
    (
        SELECT MIN(genre_id) 
        FROM(
            SELECT author_id, COUNT(DISTINCT genre_id) AS genre_id FROM book
            GROUP BY author_id
        ) genre_min
    )

__________________________
Вложенные запросы в операторах соединения
    Вывести информацию о книгах (название книги, фамилию и инициалы автора, название жанра, цену и количество экземпляров книг), 
    написанных в самых популярных жанрах, в отсортированном в алфавитном порядке по названию книг виде. Самым популярным считать жанр, 
    общее количество экземпляров книг которого на складе максимально.

Шаг 1 - Найдем общее количество книг по каждому жанру, отсортируем его по убыванию и ограничим вывод одной строкой. 
Рекомендуется, если запрос будет использоваться в качестве вложенного (особенно в операциях соединения), 
вычисляемым полям запроса давать собственное имя.

    SELECT genre_id, SUM(amount) AS sum_amount
    FROM book
    GROUP BY genre_id
    ORDER BY SUM(amount) DESC
    LIMIT 1

Кажется, что, уже используя этот запрос, можно получить id самого популярного жанра. 
Но это не так, поскольку несколько жанров могут иметь одинаковую популярность. 
Поэтому нам необходим запрос, который отберет ВСЕ жанры, суммарное количество книг которых равно sum_amount.

Шаг 2 - Используя запрос с предыдущего шага, найдем названия самых популярных жанров

       SELECT request_1.name_genre
        FROM
        (
            SELECT name_genre, SUM(amount) AS sum_amount
            FROM book
                INNER JOIN genre ON book.genre_id = genre.genre_id
            GROUP BY name_genre
        ) request_1
        INNER JOIN
        (
            SELECT name_genre, SUM(amount) AS sum_amount
            FROM genre
                INNER JOIN book ON book.genre_id = genre.genre_id
            GROUP BY name_genre
            ORDER BY sum_amount DESC
            LIMIT 1    
        ) request_2
        ON request_1.sum_amount = request_2.sum_amount

Шаг 3 - Сделаем финальный вывод 
*/
    SELECT title, name_author, name_genre, price, amount
    FROM book
        INNER JOIN author ON author.author_id = book.author_id
        INNER JOIN genre ON genre.genre_id = book.genre_id
    WHERE name_genre IN 
    (
        SELECT request_1.name_genre
        FROM
        (
            SELECT name_genre, SUM(amount) AS sum_amount
            FROM book
                INNER JOIN genre ON book.genre_id = genre.genre_id
            GROUP BY name_genre
        ) request_1
        INNER JOIN
        (
            SELECT name_genre, SUM(amount) AS sum_amount
            FROM genre
                INNER JOIN book ON book.genre_id = genre.genre_id
            GROUP BY name_genre
            ORDER BY sum_amount DESC
            LIMIT 1    
        ) request_2
        ON request_1.sum_amount = request_2.sum_amount
    )
    ORDER BY title;

/* Операция соединение, использование USING()
При описании соединения таблиц с помощью JOIN в некоторых случаях вместо ON и следующего за ним условия можно использовать оператор USING().
USING позволяет указать набор столбцов, которые есть в обеих объединяемых таблицах. Если база данных хорошо спроектирована, 
а каждый внешний ключ имеет такое же имя, как и соответствующий первичный ключ (например, genre.genre_id = book.genre_id), 
тогда можно использовать предложение USING для реализации операции JOIN. 

 Если в таблицах supply  и book есть одинаковые книги, которые имеют равную цену,  вывести их название и автора, 
 а также посчитать общее количество экземпляров книг в таблицах supply и book,  столбцы назвать Название, Автор  и Количество.
*/

SELECT book.title AS Название, name_author AS Автор, (supply.amount + book.amount) AS Количество
FROM book
    INNER JOIN author USING (author_id)
    INNER JOIN supply ON supply.title = book.title and supply.price = book.price and supply.author = author.name_author;






/* 3.2 Запросы на обновление, связанные таблицы
    UPDATE таблица_1
         ... JOIN таблица_2
         ON выражение
         ...
    SET ...   
    WHERE ...;
*/

UPDATE book 
    INNER JOIN author USING (author_id)
    INNER JOIN supply ON supply.title = book.title and supply.author = author.name_author
SET book.amount = book.amount + supply.amount,
    book.price = (book.price * book.amount + supply.price * supply.amount) / (book.amount + supply.amount),
    supply.amount = 0
WHERE book.price != supply.price;

SELECT * FROM book;

SELECT * FROM supply;

/* Запросы на добавление, связанные таблицы
    INSERT INTO таблица (список_полей)
    SELECT список_полей_из_других_таблиц
    FROM 
        таблица_1 
        ... JOIN таблица_2 ON ...
        ...

Включить новых авторов в таблицу author с помощью запроса на добавление, а затем вывести все данные из таблицы author. 
 Новыми считаются авторы, которые есть в таблице supply, но нет в таблице author.
*/

INSERT INTO author(name_author)
    SELECT supply.author
    FROM author
    RIGHT JOIN supply on author.name_author = supply.author
    WHERE name_author IS Null;

SELECT * FROM author

/* Запрос на добавление, связанные таблицы



