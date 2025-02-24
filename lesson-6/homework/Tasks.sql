create database lesson6;
Go

Use lesson6;
go

drop table if exists Departments;
Go

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);
GO

drop table if exists Employees;
Go
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    DepartmentID INT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO

drop table if exists Projects;
Go
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50) NOT NULL,
    EmployeeID INT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Insert data into Departments table
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Marketing');
GO

-- Insert data into Employees table
INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary) VALUES
(1, 'Alice', 101, 60000),
(2, 'Bob', 102, 70000),
(3, 'Charlie', 101, 65000),
(4, 'David', 103, 72000),
(5, 'Eva', NULL, 68000);
GO

-- Insert data into Projects table
INSERT INTO Projects (ProjectID, ProjectName, EmployeeID) VALUES
(1, 'Alpha', 1),
(2, 'Beta', 2),
(3, 'Gamma', 1),
(4, 'Delta', 4),
(5, 'Omega', NULL);
GO


--================================================================
--				TASKS
--================================================================

-- TASK-1
-- INNER JOIN
-- Write a query to get a list of employees along with their department names.
select
	e.Name,
	d.DepartmentName
FROM
	Employees as e
	INNER JOIN
	Departments as d
	ON e.DepartmentID = d.DepartmentID;
GO

-- TASK-2
-- LEFT JOIN
-- Write a query to list all employees, including those who are not assigned to any department.

select
	e.Name,
	COALESCE(d.DepartmentName, 'Not assigned to any department') AS DepartmentName
FROM
	Employees as e
	LEFT OUTER JOIN
	Departments as d
	ON e.DepartmentID = d.DepartmentID;
GO



-- TASK-3
-- RIGHT JOIN
-- Write a query to list all departments, including those without employees.
select
	COALESCE(e.Name, 'No employee'),
	d.DepartmentName
FROM
	Employees as e
	RIGHT OUTER JOIN
	Departments as d
	ON e.DepartmentID = d.DepartmentID;
GO
-- TASK-4
-- FULL OUTER JOIN
-- Write a query to retrieve all employees and all departments, even if there’s no match between them.
select
	COALESCE(e.Name, 'No employee') as EmployeeName,
	COALESCE(d.DepartmentName, 'Not assigned to any department') as DepartmentName
FROM
	Employees as e
	FULL OUTER JOIN
	Departments as d
	ON e.DepartmentID = d.DepartmentID;
GO

-- TASK-5
-- JOIN with Aggregation
-- Write a query to find the total salary expense for each department.

select
	COALESCE(d.DepartmentName, 'unknown department') AS DepartmentName,
	SUM(COALESCE(e.Salary, 0)) AS TotalSalary
FROM
	Employees as e
	LEFT JOIN
	Departments as d
	ON e.DepartmentID = d.DepartmentID
group by d.DepartmentName;
GO


-- TASK-6
-- CROSS JOIN
-- Write a query to generate all possible combinations of departments and projects.
SELECT 
    d.DepartmentName, 
    p.ProjectName
FROM 
    Departments As d
CROSS JOIN 
    Projects as p;


-- TASK-7
-- MULTIPLE JOINS
-- Write a query to get a list of employees 
-- with their department names and assigned project names. Include employees even if they don’t have a project.

select 
	e.Name,
    COALESCE(d.DepartmentName, 'No Department') AS DepartmentName,
    COALESCE(p.ProjectName, 'No Project') AS ProjectName
from
	Employees as e
	left join
	Departments as d
	on e.DepartmentID=d.DepartmentID
	left join
	Projects as p
	on e.EmployeeID=p.EmployeeID
ORDER BY
	e.Name



