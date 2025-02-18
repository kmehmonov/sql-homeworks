--creating database
CREATE DATABASE lesson2;
GO

-- using lesson2 database as main database
USE lesson2;
GO

--TASK1.
--delete table if exists
DROP TABLE IF EXISTS test_identity;
GO

--creating new table
CREATE TABLE test_identity(
	id INT IDENTITY(1,1),
	[name] NVARCHAR(50)
);
GO

--Inserting vaues into test_identity table
INSERT INTO test_identity
VALUES
	('kamoliddin'),
	('tursunpulat'),
	('feruz'),
	('jamshid'),
	('otaxon');
GO

-- deleting row which id=5
delete from test_identity 
where id=5;
GO
--Inserting vaues into test_identity table
INSERT INTO test_identity
VALUES
	('kamoliddin2');
GO

--print all rows
select * from test_identity;
Go

-- ANSWER FOR 1's i: When we use DELETE statement, identity column continue with lastID+1.
--==============================================================================================

-- TRUNCATE table 
TRUNCATE TABLE test_identity;
GO

--Inserting vaues into test_identity table
INSERT INTO test_identity
VALUES
	('kamoliddin3');
GO

--print all rows
select * from test_identity;
Go
-- ANSWER FOR 1's ii: When we use TRUNCATE identity column start with 1
--==============================================================================================


-- DROP table 
DROP TABLE test_identity;
GO


--print all rows
select * from test_identity;
Go
-- ANSWER FOR 1's iii: When we use DROP statement, table removed permanently with all data
--==============================================================================================
--TASK-2
--delete table if exists
DROP TABLE IF EXISTS data_types_demo ;
GO

--creating new table
CREATE TABLE data_types_demo (
	id UNIQUEIDENTIFIER ,
	[name] NVARCHAR(50),
	birthday DATE,
	meeting TIME,
	cv NVARCHAR(MAX),
	[transaction] DATETIME
);
GO
--inserting values into table
INSERT INTO data_types_demo
VALUES
	(NEWID(), 'jamshid', '1994-12-21', '18:24', 'He was born in 1994', GETDATE()),
	(NEWID(), 'jamshid2', '1995-12-21', '18:24', 'He was born in 1995', GETDATE());
GO

--display data_types_demo table
select * from data_types_demo
GO


--TASK-3
DROP TABLE IF EXISTS photos;
GO

CREATE TABLE photos(
	id INT PRIMARY KEY IDENTITY(1,1),
	[name] nvarchar(50),
	photo varbinary(MAX)
);

INSERT INTO  photos
SELECT 'photo1', BulkColumn from openrowset(
	BULK 'C:\Users\Builder\Downloads\image.jpg', SINGLE_BLOB
) AS image_file

select * from photos

-- python fileto retrieve and save image: lesson-2\homework\test.ipynb

--TASK-4
-- drop table if already exists
DROP TABLE IF EXISTS student;
GO

-- creating table
CREATE TABLE student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    classes INT,
    tuition_per_class DECIMAL(10, 2),
    total_tuition AS (classes * tuition_per_class) PERSISTED -- calculate and save it table in storage
);
GO

--inserting values student table
INSERT INTO student (student_id, student_name, classes, tuition_per_class)
VALUES
(1, 'John Doe', 5, 300.00),
(2, 'Jane Smith', 3, 350.00),
(3, 'Sam Brown', 4, 400.00);

GO

-- retrieving and displaying table 
SELECT * FROM student;
GO


--TASK-5

--Drop table if already exists
DROP TABLE IF EXISTS workers;
GO

--Crete table name workers
CREATE TABLE workers(
	id INT PRIMARY KEY,
	[name] NVARCHAR(50)
);
GO

-- import data for workers table from csv file 
BULK INSERT workers
FROM 'D:\hobby\maab_academy\sql-homeworks\lesson-2\homework\workers.csv'
WITH (
	firstrow = 2, -- skipping header
	fieldterminator = ',', -- delimator
	rowterminator = '\n' -- row end with \n
);
GO

select * from workers;
Go




