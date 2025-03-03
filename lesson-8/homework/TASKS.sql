create database lesson8;
Go

USE lesson8;
GO

DROP TABLE IF EXISTS Groupings;

CREATE TABLE Groupings
(
StepNumber  INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NOT NULL,
[Status]    VARCHAR(100) NOT NULL
);
INSERT INTO Groupings (StepNumber, TestCase, [Status]) 
VALUES
(1,'Test Case 1','Passed'),
(2,'Test Case 2','Passed'),
(3,'Test Case 3','Passed'),
(4,'Test Case 4','Passed'),
(5,'Test Case 5','Failed'),
(6,'Test Case 6','Failed'),
(7,'Test Case 7','Failed'),
(8,'Test Case 8','Failed'),
(9,'Test Case 9','Failed'),
(10,'Test Case 10','Passed'),
(11,'Test Case 11','Passed'),
(12,'Test Case 12','Passed');

-----------------------------------------

DROP TABLE IF EXISTS [dbo].[EMPLOYEES_N];

CREATE TABLE [dbo].[EMPLOYEES_N]
(
    [EMPLOYEE_ID] [int] NOT NULL,
    [FIRST_NAME] [varchar](20) NULL,
    [HIRE_DATE] [date] NOT NULL
)
 
INSERT INTO [dbo].[EMPLOYEES_N]
VALUES
	(1001,'Pawan','1975-02-21'),
	(1002,'Ramesh','1976-02-21'),
	(1003,'Avtaar','1977-02-21'),
	(1004,'Marank','1979-02-21'),
	(1008,'Ganesh','1979-02-21'),
	(1007,'Prem','1980-02-21'),
	(1016,'Qaue','1975-02-21'),
	(1155,'Rahil','1975-02-21'),
	(1102,'Suresh','1975-02-21'),
	(1103,'Tisha','1975-02-21'),
	(1104,'Umesh','1972-02-21'),
	(1024,'Veeru','1975-02-21'),
	(1207,'Wahim','1974-02-21'),
	(1046,'Xhera','1980-02-21'),
	(1025,'Wasil','1975-02-21'),
	(1052,'Xerra','1982-02-21'),
	(1073,'Yash','1983-02-21'),
	(1084,'Zahar','1984-02-21'),
	(1094,'Queen','1985-02-21'),
	(1027,'Ernst','1980-02-21'),
	(1116,'Ashish','1990-02-21'),
	(1225,'Bushan','1997-02-21');


--TASK-1. Write an SQL statement that counts the consecutive values in the Status field.
select 
	Min(StepNumber) as MinStepNumber,
	Max(StepNumber) as MaxStepNumber,
	t.[Status],
	count(StepNumber) as ConsecutiveCount
from
    (SELECT 
        StepNumber,
        [Status],
        row_number() OVER (ORDER BY StepNumber)-ROW_NUMBER() OVER (PARTITION BY [Status] ORDER BY StepNumber) AS GroupNum
    FROM Groupings) as t
GROUP BY t.GroupNum, t.[Status]
order by  MinStepNumber


--TASK-2.Find all the year-based intervals from 1975 up to current when the company did not hire employees.
--Distinct HireYears
--select
--	DISTINCT YEAR(HIRE_DATE) as HiredYears
--from EMPLOYEES_N

----All consequeitive years
--select ordinal+year((select min(HIRE_DATE) from EMPLOYEES_N))-1  as allyears from string_split(replicate(',', year((select max(HIRE_DATE) from EMPLOYEES_N))-year((select min(HIRE_DATE) from EMPLOYEES_N))),',',1)

----grouping Not hired Years
--select 
--	*,
--	allyears-ROW_NUMBER() over(order by allyears)+1 as groupNum
--from
--	--Distinct HireYears
--	(select DISTINCT YEAR(HIRE_DATE) as HiredYears from EMPLOYEES_N) as t1
--right join
--	--All consequeitive years
--	(select ordinal+year((select min(HIRE_DATE) from EMPLOYEES_N))-1  as allyears from string_split(replicate(',', year((select max(HIRE_DATE) from EMPLOYEES_N))-year((select min(HIRE_DATE) from EMPLOYEES_N))),',',1)) as t2
--	on t1.HiredYears =t2.allyears
--where t1.HiredYears is NULL


select 
	cast(min(allyears) as nvarchar(4))+ ' - ' + cast(max(allyears) as nvarchar(4)) as YEARS
from
(
--grouping Not hired Years
select 
	*,
	allyears-ROW_NUMBER() over(order by allyears)+1 as groupNum
from
	--Distinct HireYears
	(select DISTINCT YEAR(HIRE_DATE) as HiredYears from EMPLOYEES_N) as t1
right join
	--All consequeitive years
	(select ordinal+year((select min(HIRE_DATE) from EMPLOYEES_N))-1  as allyears from string_split(replicate(',', year((select max(HIRE_DATE) from EMPLOYEES_N))-year((select min(HIRE_DATE) from EMPLOYEES_N))),',',1)) as t2
	on t1.HiredYears =t2.allyears
where t1.HiredYears is NULL
) as NotHiredYears
group by NotHiredYears.groupNum











