CREATE DATABASE BAC_LATAM_SALES
USE BAC_LATAM_SALES

---------------------------------------------------------------------------------RESPUESTA SEGÚN PREGUNTA
CREATE TABLE [dbo].[authors](
	[author_name] [varchar](100) NOT NULL,
	[book_name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_authors] PRIMARY KEY CLUSTERED (
	[book_name] ASC
)) ON [PRIMARY]

INSERT INTO authors(author_name,book_name)
SELECT 'author_1','book_1'
UNION ALL
SELECT 'author_1','book_2'
UNION ALL
SELECT 'author_2','book_3'
UNION ALL
SELECT 'author_2','book_4'
UNION ALL
SELECT 'author_2','book_5'
UNION ALL
SELECT 'author_3','book_6'

SELECT * 
FROM [authors]

CREATE TABLE [dbo].[books](
	[book_name] [varchar](100) NOT NULL,
	[sold_copies] [decimal](18,0) NOT NULL,
 CONSTRAINT [PK_books] PRIMARY KEY CLUSTERED (
	[book_name] ASC
)) ON [PRIMARY]

ALTER TABLE [dbo].[books]  WITH CHECK ADD  CONSTRAINT [FK_authors_solds] FOREIGN KEY([book_name])
REFERENCES [dbo].[authors] ([book_name])

INSERT INTO [books](book_name,sold_copies)
SELECT 'book_1',1000
UNION ALL
SELECT 'book_2',1500
UNION ALL
SELECT 'book_3',34000
UNION ALL
SELECT 'book_4',29000
UNION ALL
SELECT 'book_5',40000
UNION ALL
SELECT 'book_6',4400

SELECT * 
FROM [books]

SELECT TOP 3 AUTHORS.author_name,SUM(sold_copies) AS solds_copies
FROM books AS BOOKS
INNER JOIN authors AS AUTHORS
	ON BOOKS.book_name = AUTHORS.book_name
WHERE 1 = 1
GROUP BY AUTHORS.author_name
ORDER BY solds_copies DESC
---------------------------------------------------------------------------------RESPUESTA SEGÚN PREGUNTA

---------------------------------------------------------------------------------RESPUESTA CON TABLAS NORMALIZADAS
CREATE TABLE [dbo].[authors_2](
	[author_id] [integer] IDENTITY(1,1) NOT NULL,
	[author_name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_authors_2] PRIMARY KEY CLUSTERED (
	[author_id] ASC
)) ON [PRIMARY]

INSERT INTO authors_2(author_name)
SELECT 'author_1'
UNION ALL
SELECT 'author_2'
UNION ALL
SELECT 'author_3'

SELECT * 
FROM authors_2

CREATE TABLE [dbo].[book_2](
	[book_id] [integer] IDENTITY(1,1) NOT NULL,
	[author_id] [integer] NOT NULL,
	[book_name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_book_2] PRIMARY KEY CLUSTERED (
	[book_id] ASC
)) ON [PRIMARY]

ALTER TABLE [dbo].[book_2]  WITH CHECK ADD  CONSTRAINT [FK_books_2_authors2] FOREIGN KEY([author_id])
REFERENCES [dbo].[authors_2] ([author_id])

INSERT INTO book_2(author_id,book_name)
SELECT 1,'book_1'
UNION ALL
SELECT 1,'book_2'
UNION ALL
SELECT 2,'book_3'
UNION ALL
SELECT 2,'book_4'
UNION ALL
SELECT 2,'book_5'
UNION ALL
SELECT 3,'book_6'

select * from book_2

/*ES IMPORTANTE MENCIONAR QUE SI LOS LIBROS TIENEN VARIOS AUTORES SE DEBEN DE CAMBIAR LAS TABLAS, YA QUE ESTE CASO
ES PARA UN AUTOR POR LIBRO*/

CREATE TABLE [dbo].[book_sales](
	[book_id] [integer] NOT NULL,
	[sold_copies] [decimal](18,0) NOT NULL,
 CONSTRAINT [PK_book_sales] PRIMARY KEY CLUSTERED (
	[book_id] ASC,
	[sold_copies] ASC
)) ON [PRIMARY]

ALTER TABLE [dbo].[book_sales]  WITH CHECK ADD  CONSTRAINT [FK_book_sales_books_2] FOREIGN KEY([book_id])
REFERENCES [dbo].[book_2] ([book_id])

INSERT INTO [book_sales](book_id,sold_copies)
SELECT 1,1000
UNION ALL
SELECT 2,1500
UNION ALL
SELECT 3,34000
UNION ALL
SELECT 4,29000
UNION ALL
SELECT 5,40000
UNION ALL
SELECT 6,4400

SELECT TOP 3 AUTHORS.author_id,AUTHORS.author_name,SUM(SALES.sold_copies) as sold_copies
FROM book_sales AS SALES
INNER JOIN book_2 AS BOOKS
	ON SALES.book_id = BOOKS.book_id
INNER JOIN authors_2 AS AUTHORS
	ON BOOKS.author_id = AUTHORS.author_id
WHERE 1 = 1
GROUP BY AUTHORS.author_id,AUTHORS.author_name
ORDER BY sold_copies DESC
---------------------------------------------------------------------------------RESPUESTA CON TABLAS NORMALIZADAS