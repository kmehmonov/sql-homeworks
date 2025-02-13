-- delete database if already exist
DROP DATABASE IF EXISTS lesson1;
GO

-- Creating database
CREATE DATABASE lesson1;
GO

-- Use database
USE lesson1
GO

/*
1. NOT NULL Constraint
Create a table named student with columns:
	id (integer, should not allow NULL values)
	name (string, can allow NULL values)
	age (integer, can allow NULL values)
First, create the table without the NOT NULL constraint.
Then, use ALTER TABLE to apply the NOT NULL constraint to the id column.
*/
-- Drop table if already exist
DROP TABLE IF EXISTS student;
GO

-- Creating table
CREATE TABLE student
(
	id INT,
	name NVARCHAR(50),
	age INT
);
GO

-- Alter id column with  NOT NULL constraint
ALTER TABLE student
ALTER COLUMN id INT NOT NULL;
GO

/*
2. UNIQUE Constraint
Create a table named product with the following columns:
	product_id (integer, should be unique)
	product_name (string, no constraint)
	price (decimal, no constraint)
First, define product_id as UNIQUE inside the CREATE TABLE statement.
Then, drop the unique constraint and add it again using ALTER TABLE.
Extend the constraint so that the combination of product_id and product_name must be unique.
*/

-- Drop table if already exist
DROP TABLE IF EXISTS product;
GO

-- Creating table
CREATE TABLE product
(
	product_id INT UNIQUE,
	product_name NVARCHAR(50),
	price DECIMAL
);
GO

-- drop the unique constraint 
DECLARE @constraint_name NVARCHAR(255);
SELECT @constraint_name = name 
FROM sys.key_constraints 
WHERE type = 'UQ' AND parent_object_id = OBJECT_ID('product');

IF @constraint_name IS NOT NULL
BEGIN
    EXEC('ALTER TABLE product DROP CONSTRAINT ' + @constraint_name);
END
GO

--  add it again using ALTER TABLE
ALTER TABLE product
ADD CONSTRAINT UQ__product__product_id UNIQUE(product_id);
GO

--  Extend the constraint so that the combination of product_id and product_name must be unique.
--drop UK__product__product_id
ALTER TABLE product
DROP CONSTRAINT UQ__product__product_id;
GO

-- the combination of product_id and product_name must be unique.
ALTER TABLE product
ADD CONSTRAINT UQ__product__product_id__product_name UNIQUE(product_id, product_name);
GO

/*
3. PRIMARY KEY Constraint
Create a table named orders with:
	order_id (integer, should be the primary key)
	customer_name (string, no constraint)
	order_date (date, no constraint)
First, define the primary key inside the CREATE TABLE statement.
Then, drop the primary key and add it again using ALTER TABLE.
*/

-- Drop table if already exist
DROP TABLE IF EXISTS orders;
GO

-- Creating table
CREATE TABLE orders
(
	order_id INT,
	customer_name NVARCHAR(50),
	order_date DATE, 
	-- Naming primary key constraint
	CONSTRAINT PK__product__id PRIMARY KEY(order_id)
);
GO


--drop  drop the primary key using ALTER TABLE
ALTER TABLE orders
DROP CONSTRAINT PK__product__id;
GO

-- add it again using ALTER TABLE
ALTER TABLE orders
ADD CONSTRAINT PK__product__id PRIMARY KEY (order_id);
GO

/*
4. FOREIGN KEY Constraint
Create two tables:
	category:
	category_id (integer, primary key)
	category_name (string)
item:
	item_id (integer, primary key)
	item_name (string)
	category_id (integer, should be a foreign key referencing category_id in category table)
First, define the foreign key inside CREATE TABLE.
Then, drop and add the foreign key using ALTER TABLE
*/

-- First table
DROP TABLE IF EXISTS category;
GO

CREATE TABLE category
(
	category_id INT,
	category_name NVARCHAR(50),
	CONSTRAINT PK__category__category_id PRIMARY KEY(category_id)
);
GO

-- Second table
DROP TABLE IF EXISTS item;
GO

CREATE TABLE item
(
	item_id INT,
	item_name  NVARCHAR(50),
	category_id INT,
	CONSTRAINT FK__item__category_id FOREIGN KEY(category_id) REFERENCES category(category_id)
);
GO

--drop and add the foreign key using ALTER TABLE.
ALTER TABLE item
DROP CONSTRAINT FK__item__category_id;
GO

ALTER TABLE item
ADD CONSTRAINT FK__item__category_id FOREIGN KEY(category_id) REFERENCES category(category_id);
GO


/*
5. CHECK Constraint
Create a table named account with:
	account_id (integer, primary key)
	balance (decimal, should always be greater than or equal to 0)
	account_type (string, should only accept values 'Saving' or 'Checking')
Use CHECK constraints to enforce these rules.
First, define the constraints inside CREATE TABLE.
Then, drop and re-add the CHECK constraints using ALTER TABLE.

*/

DROP TABLE IF EXISTS account;
GO

CREATE TABLE account
(
	account_id INT,
	balance  decimal,
	account_type NVARCHAR(10),
	CONSTRAINT PK_account_account_id PRIMARY KEY(account_id),
	CONSTRAINT CC_account_balance CHECK(balance >=0),
	CONSTRAINT CC_account_account_type CHECK (account_type = 'Saving' OR account_type = 'Checking')
);
GO

ALTER TABLE account
DROP CONSTRAINT CC_account_balance;
GO

ALTER TABLE account
DROP CONSTRAINT CC_account_account_type;
GO

ALTER TABLE account
ADD CONSTRAINT
CC_account_balance CHECK(balance >=0);
GO


ALTER TABLE account
ADD CONSTRAINT
CC_account_account_type CHECK (account_type = 'Saving' OR account_type = 'Checking');
GO


/**
6. DEFAULT Constraint
Create a table named customer with:
	customer_id (integer, primary key)
	name (string, no constraint)
	city (string, should have a default value of 'Unknown')
First, define the default value inside CREATE TABLE.
Then, drop and re-add the default constraint using ALTER TABLE.
*/

DROP TABLE IF EXISTS customer;
GO

CREATE TABLE customer
(
	customer_id INT CONSTRAINT PK_customer_customer_id PRIMARY KEY(customer_id),
	name  NVARCHAR(50),
	city NVARCHAR(50) CONSTRAINT DF_customer_city DEFAULT 'Unknown'
);
GO

ALTER TABLE customer
DROP CONSTRAINT DF_customer_city;
GO


ALTER TABLE customer
ADD CONSTRAINT DF_customer_city DEFAULT 'Unknown' FOR city;
GO


/*
7. IDENTITY Column
Create a table named invoice with:
	invoice_id (integer, should auto-increment starting from 1)
	amount (decimal, no constraint)
Insert 5 rows into the table without specifying invoice_id.
Enable and disable IDENTITY_INSERT, then manually insert a row with invoice_id = 100
*/


DROP TABLE IF EXISTS invoice;
GO

CREATE TABLE invoice
(
	invoice_id INT IDENTITY(1,1),
	amount DECIMAL
);
GO

INSERT INTO invoice
VALUES
	(100),
	(200),
	(300),
	(400),
	(500);
GO

SET IDENTITY_INSERT invoice ON;
GO

INSERT INTO invoice(invoice_id, amount) VALUES (100, 600);
GO

SET IDENTITY_INSERT invoice OFF;
GO

INSERT INTO invoice
VALUES
	(700),
	(800);
GO


/*
8. All at once
Create a books table with:
	book_id (integer, primary key, auto-increment)
	title (string, must not be empty)
	price (decimal, must be greater than 0)
	genre (string, default should be 'Unknown')
Insert data and test if all constraints work as expected.
*/

DROP TABLE IF EXISTS books;
GO

CREATE TABLE books(
	book_id int IDENTITY(1,1) CONSTRAINT PK_books_book_id PRIMARY KEY,
	title NVARCHAR(50) CONSTRAINT CC_books_title CHECK(title <> ''),
	price DECIMAL CONSTRAINT CC_books_price CHECK(price > 0),
	genre NVARCHAR(50) CONSTRAINT DC_books_genre DEFAULT 'Unknown'
); 
GO

INSERT INTO books(title, price)
VALUES
	('title1', 10)
GO


select * from books;
GO


--task-9.
--You need to design a simple database for a library where books are borrowed by members.

--create database
CREATE DATABASE lmsdb
GO

--use database
USE lmsdb
GO

--create books table
DROP TABLE IF EXISTS books;
GO

CREATE TABLE books(
	book_id INT IDENTITY(1,1) CONSTRAINT PK_books_book_id PRIMARY KEY,
	title NVARCHAR(100),
	author NVARCHAR(50),
	published_year INT
); 
GO

--create member table
DROP TABLE IF EXISTS member;
GO

CREATE TABLE member(
	member_id INT IDENTITY(1,1) CONSTRAINT PK_member_member_id PRIMARY KEY,
	name NVARCHAR(50),
	email NVARCHAR(50),
	phone_number NVARCHAR(15)
); 
GO

--create loan table
DROP TABLE IF EXISTS loan;
GO

CREATE TABLE loan(
	loan_id INT IDENTITY(1,1) CONSTRAINT PK_loan_loan_id PRIMARY KEY,
	book_id INT CONSTRAINT FK_loan_book_id FOREIGN KEY(book_id) REFERENCES books(book_id),
	
	member_id INT CONSTRAINT FK_loan_member_id FOREIGN KEY(member_id) REFERENCES member(member_id),
	loan_date DATE NOT NULL  DEFAULT GETDATE(),
	return_date DATE NULL
); 
GO


-- Insert sample data into Book table
INSERT INTO books (title, author, published_year) 
VALUES 
	('The Great Gatsby', 'F. Scott Fitzgerald', 1925),
	('To Kill a Mockingbird', 'Harper Lee', 1960),
	('1984', 'George Orwell', 1949);
GO

-- Insert sample data into Member table
INSERT INTO member (name, email, phone_number)
VALUES 
	('Alice Johnson', 'alice@example.com', '1234567890'),
	('Bob Smith', 'bob@example.com', '0987654321'),
	('Charlie Brown', 'charlie@example.com', '1122334455');
GO

-- Insert sample data into Loan table
INSERT INTO loan (book_id, member_id, loan_date, return_date)
VALUES 
	(1, 1, '2025-02-01', NULL),  -- Alice borrowed "The Great Gatsby"
	(2, 2, '2025-02-02', '2025-02-10'),  -- Bob borrowed "To Kill a Mockingbird" and returned it
	(3, 1, '2025-02-05', NULL);  -- Alice borrowed "1984"
GO