create database lesson11;
GO

USE lesson11;
GO


-- ==============================================================
--                          Puzzle 1 DDL                         
-- ==============================================================

drop table if exists Employees;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employees (EmployeeID, Name, Department, Salary)
VALUES
    (1, 'Alice', 'HR', 5000),
    (2, 'Bob', 'IT', 7000),
    (3, 'Charlie', 'Sales', 6000),
    (4, 'David', 'HR', 5500),
    (5, 'Emma', 'IT', 7200);


-- ==============================================================
--                          Puzzle 2 DDL
-- ==============================================================
drop table if exists Orders_DB1;
CREATE TABLE Orders_DB1 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB1 VALUES
(101, 'Alice', 'Laptop', 1),
(102, 'Bob', 'Phone', 2),
(103, 'Charlie', 'Tablet', 1),
(104, 'David', 'Monitor', 1);


drop table if exists Orders_DB2;
CREATE TABLE Orders_DB2 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB2 VALUES
(101, 'Alice', 'Laptop', 1),
(103, 'Charlie', 'Tablet', 1);


-- ==============================================================
--                          Puzzle 3 DDL
-- ==============================================================
drop table if exists WorkLog;
CREATE TABLE WorkLog (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    WorkDate DATE,
    HoursWorked INT
);

INSERT INTO WorkLog VALUES
(1, 'Alice', 'HR', '2024-03-01', 8),
(2, 'Bob', 'IT', '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice', 'HR', '2024-03-03', 6),
(2, 'Bob', 'IT', '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9);

select * from Employees

--=======================================================
--Task-1
--=======================================================

-- Method-1
-- If the number of departments is fixed and small
drop table if exists #EmployeeTransfers
CREATE TABLE #EmployeeTransfers (
    EmployeeID INT,
    Name NVARCHAR(100),
    Department NVARCHAR(50),
    Salary INT
);

INSERT INTO #EmployeeTransfers (EmployeeID, Name, Department, Salary)
SELECT 
    EmployeeID,
    Name,
    CASE 
        WHEN Department = 'HR' THEN 'IT'
        WHEN Department = 'IT' THEN 'Sales'
        WHEN Department = 'Sales' THEN 'HR'
        ELSE Department
    END AS Department,
    Salary
FROM Employees;

SELECT * FROM #EmployeeTransfers;
GO
-- Method-2
-- If departments may change or expand, this code more flexible
-- nth times rotation can be account for using @rotNumber

DECLARE @rotNumber INT = 1;

;WITH cteDepartments (DepartmentID, DepartmentName) AS (
    SELECT 1, 'Hr'
    UNION ALL
    SELECT 2, 'IT'
    UNION ALL
    SELECT 3, 'Sales'
),

cteEmployeeWithDepID AS (
    SELECT
        e.EmployeeID,
        e.Name,
        cteDepartments.DepartmentID,
        e.Salary
    FROM
        Employees AS e
    JOIN
        cteDepartments 
    ON 
        e.Department = cteDepartments.DepartmentName
),

cteEmployeesAfterRot AS (
    SELECT
        EmployeeID,
        Name,
        CASE
            WHEN (DepartmentID + @rotNumber)% (SELECT MAX(DepartmentID) FROM cteDepartments)=0 THEN (SELECT MAX(DepartmentID) FROM cteDepartments)
            ELSE (DepartmentID + @rotNumber)% (SELECT MAX(DepartmentID) FROM cteDepartments)
        END AS newDepartment,
		Salary

    FROM 
        cteEmployeeWithDepID
)

SELECT 
    e.EmployeeID,
    e.Name,
    d.DepartmentName AS Department,
	e.Salary
FROM 
    cteEmployeesAfterRot AS e
JOIN 
    cteDepartments AS d
ON 
    e.newDepartment = d.DepartmentID;
GO
--=======================================================
--Task-2
--=======================================================
--method-1
--using left join finding missing values

declare @missingValTable table (
	OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
)

insert into @missingValTable
select
	db1.*
from
	Orders_DB1 as db1
left join
	Orders_DB2 as db2
	on db1.OrderID=db2.OrderID
where db2.OrderID is NULL

select * from @missingValTable
GO


--method-2
--using except finding missing values
declare @missingValTable table (
	OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
)

insert into @missingValTable
select * from Orders_DB1
except
select * from Orders_DB2

select * from @missingValTable

GO
--=======================================================
--Task-3
--=======================================================

create view vw_MonthlyWorkSummary As
	with cteEmployeesTotalHours as(
		select
			EmployeeID,
			EmployeeName,
			Department,
			sum(HoursWorked) as TotalHoursWorked 
		from WorkLog
		group by EmployeeID, EmployeeName, Department
	),

	cteDepartmentsTotalHours as(
		select
			Department,
			sum(HoursWorked) as TotalHoursDepartment, 
			AVG(HoursWorked*1.0) AS AvgHoursDepartment
		from WorkLog
		group by Department
	)

	SELECT 
		e.EmployeeID,
		e.EmployeeName,
		e.Department,
		e.TotalHoursWorked,
		d.TotalHoursDepartment,
		d.AvgHoursDepartment
	FROM cteEmployeesTotalHours e
	JOIN cteDepartmentsTotalHours d 
	ON e.Department = d.Department;
GO

select * from vw_MonthlyWorkSummary
