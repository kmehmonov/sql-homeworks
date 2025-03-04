create database lesson9;
Go

use lesson9;
go

drop table if exists Employees;
GO

CREATE TABLE Employees
(
	EmployeeID  INTEGER PRIMARY KEY,
	ManagerID   INTEGER NULL,
	JobTitle    VARCHAR(100) NOT NULL
);
INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
VALUES
	(1001, NULL, 'President'),
	(2002, 1001, 'Director'),
	(3003, 1001, 'Office Manager'),
	(4004, 2002, 'Engineer'),
	(5005, 2002, 'Engineer'),
	(6006, 2002, 'Engineer');

	select * from Employees;
GO

--===============================================================
--TASK-1.
--===============================================================
;WITH EmployeeJobDepth AS(
    SELECT EmployeeID, ManagerID, JobTitle, 0 AS Depth
    FROM Employees
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    SELECT e.EmployeeID, e.ManagerID, e.JobTitle, ejd.Depth + 1
    FROM Employees as e
    JOIN EmployeeJobDepth as ejd ON e.ManagerID = ejd.EmployeeID
)

SELECT * FROM EmployeeJobDepth ORDER BY Depth, EmployeeID;
GO

--===============================================================
--TASK-2.
--===============================================================
declare @N int = 10;
with cteFactorial as (
	select
		1 as NUM,
		1 as Factorial

	UNION ALL

	select
		NUM+1,
		Factorial*(NUM+1)
	from cteFactorial

	where NUM<@N
)

select * from cteFactorial;
GO


--===============================================================
--TASK-3.
--===============================================================

DECLARE @N int = 10;
WITH cteFibonacci AS (
    SELECT
		1 AS n,
		1 AS CurrFibNumber,
		0 AS PrevFibNumber

    UNION ALL

    SELECT
		n + 1 AS n,
		CurrFibNumber + PrevFibNumber AS CurrFibNumber,
		CurrFibNumber AS PrevFibNumber
    FROM cteFibonacci
    WHERE n + 1 <= @N
)
SELECT n, CurrFibNumber as Fibonacci_Number FROM cteFibonacci ORDER BY n;
GO




