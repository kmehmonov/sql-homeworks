CREATE DATABASE lesson4;
GO

USE lesson4;
GO


DROP TABLE IF EXISTS sampleTable;
GO

CREATE TABLE sampleTable (
    ID INT,
    [Name] NVARCHAR(50),
    Age INT,
    City NVARCHAR(50)
);

INSERT INTO SampleTable (ID, Name, Age, City) VALUES
(1, 'Alice', 25, 'New York'),
(2, 'Bob', 30, 'Los Angeles'),
(3, 'Charlie', 28, 'Chicago'),
(4, 'David', 35, 'Houston'),
(5, 'Emma', 22, 'Miami'),
(6, 'Frank', 40, 'Seattle'),
(7, 'Grace', 27, 'Boston'),
(8, 'Henry', 33, 'San Francisco'),
(9, 'Ivy', 29, 'Denver'),
(10, 'Jack', 31, 'Dallas'),
(11, 'Jack', 31, 'Dallas'),
(NULL, NULL, NULL, NULL);
GO

SELECT * FROM SampleTable;
GO

--FUNCTIONS
--Aggregate functions
--1. COUNT()

SELECT COUNT(*) from sampleTable;
SELECT COUNT(Name) from sampleTable;
SELECT COUNT(DISTINCT [Name]) from sampleTable;
GO

--2. SUM()
--3. AVG()
--4. MIN()
--5. MAX()
--6. STRING_AGG()
SELECT
	City,
	STRING_AGG(Name, ' * ')
from sampleTable
GROUP BY City

--===============================================
create table agents(    name varchar(50),    office varchar(50),    isheadoffice varchar(3));insert into agentsvalues    ('Rich', 'UK', 'yes'),    ('Rich', 'US', 'no'),    ('Rich', 'NZ', 'no'),    ('Brandy', 'US', 'yes'),    ('Brandy', 'UK', 'no'),    ('Brandy', 'AUS', 'no'),    ('Karen', 'NZ', 'yes'),    ('Karen', 'UK', 'no'),    ('Karen', 'RUS', 'no'),    ('Mary', 'US', 'yes'),    ('Mary', 'UK', 'no'),    ('Mary', 'CAN', 'no'),    ('Charles', 'US', 'yes'),    ('Charles', 'UZB', 'no'),    ('Charles', 'AUS', 'no');

select
	[name],
	string_agg(office,'-') as new
from agents
where office='US' OR office='UK'
group by [name]
having string_agg(office,'-')='US-UK'

--=============================================================

create table parent(    pname varchar(50),    cname varchar(50),    gender char(1));insert into parentvalues    ('Karen', 'John', 'M'),    ('Karen', 'Steve', 'M'),    ('Karen', 'Ann', 'F'),    ('Rich', 'Cody', 'M'),    ('Rich', 'Stacy', 'F'),    ('Rich', 'Mike', 'M'),    ('Tom', 'John', 'M'),    ('Tom', 'Ross', 'M'),    ('Tom', 'Rob', 'M'),    ('Roger', 'Brandy', 'F'),    ('Roger', 'Jennifer', 'F'),    ('Roger', 'Sara', 'F')

select
	pname, string_agg(gender, ', ') as childs_gender 
from parent
group by pname
having count(distinct gender) = 2
--==============================================================
--Number functions
--1. SQRT()
select sqrt(5)

--2. ABS
select abs(-5)

--3. ROUND()
select round(5.68745, 2)
select round(-5.68745, 2)

--4. CEILING()
select ceiling(4.1)

--5. FLOOR()
select floor(4.9)

--6. POWER()
select POWER(2,5)

--7. EXP()
select exp(3)

--8. LOG()
select log(exp(1))
select log(100,2)

--9. LOG10()
select log10(10)

--10. SIGN()

select sign(-10)
select sign(10)
select sign(0)

--11. RAND()
select RAND()


--String functions
--1. LEN()
select len('Men kjdfksa hjskdfh')

--2. LEFT()/ RIGHT()
select left('abcdefg',3)
select right('abcdefg',3)

--3. SUBSTRING()
select substring('abcdefg',5,2)

--4. REVERSE()
select REVERSE('abc')

--5. CHARINDEX()
select CHARINDEX('c', 'abcdc',  CHARINDEX('c', 'abcdc')+1)

--6. REPLACE()
select REPLACE('abcdefga', 'a', 'b') 

--7. TRIM(), LTRIM(), RTRIM()
select TRIM('    salom   ')
select LTRIM('    salom   ')
select RTRIM('    salom   ')

--8. UPPER()/ LOWER()
select upper('abc')
select lower('Adjkd')

--9. CONCAT()
select 'a'+NULL
select CONCAT('hello', 'world', 'another')

--10. STRING_AGG()

--11. SPACE()
select 'a'+space(5)+'b'

--12. REPLICATE()
select replicate('abc',5)


--13. SPLIT()
select * from  string_split('a,b,c', ',', 1)
select * from  string_split('a,b,c', ',')

select @@VERSION
--Date or Time functions
--1. GETDATE(), CURRENT_TIMESTAMP
select getdate(), current_timestamp

--2. year()/ month/ day
select GETDATE(), year(GETDATE()), MONTH(GETDATE()), DAY(GETDATE()) 


--Kunlar va vaqt ustida amallar.
--3. DATEDIFF()

select DATEDIFF(DAY, '2025-2-19', '1994-12-21')
select DATEDIFF(MONTH, '2025-2-19', '1994-12-21')
select DATEDIFF(YEAR, '2025-2-19', '1994-12-21')

--4. DATEADD()
select DATEADD(DAY, 10, GETDATE())
select DATEADD(DAY, -10, GETDATE())

--5. EOMONTH
select GETDATE(), EOMONTH(GETDATE())

-- CAST() for converting

select cast(11 as varchar) + 'a'
select TRY_CAST('a' as int)*5


--window functions