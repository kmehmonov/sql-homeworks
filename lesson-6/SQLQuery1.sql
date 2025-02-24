CREATE DATABASE lesson6;
GO

USE lesson6;
GO

--Delete table if exists
DROP TABLE IF EXISTS Employees;
GO

-- Sample table DDL for homework
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
);
GO

-- Sample table data for homework
INSERT INTO Employees (Name, Department, Salary, HireDate) VALUES
    ('Alice', 'HR', 50000, '2020-06-15'),
    ('Bob', 'HR', 60000, '2018-09-10'),
    ('Charlie', 'IT', 70000, '2019-03-05'),
    ('David', 'IT', 80000, '2021-07-22'),
    ('Eve', 'Finance', 90000, '2017-11-30'),
    ('Frank', 'Finance', 75000, '2019-12-25'),
    ('Grace', 'Marketing', 65000, '2016-05-14'),
    ('Hank', 'Marketing', 72000, '2019-10-08'),
    ('Ivy', 'IT', 67000, '2022-01-12'),
    ('Alice1', 'HR', 50000, '2020-06-15'),
    ('Bob1', 'HR', 60000, '2018-09-10'),
    ('Charlie1', 'IT', 70000, '2019-03-05'),
    ('David1', 'IT', 80000, '2021-07-22'),
    ('Jack', 'HR', 52000, '2021-03-29');
GO

select * from employees

select *,
	lag(Salary, 1, 0) over(partition by department order by hiredate)
from employees

select Name,
	FIRST_VALUE(Name) over(partition by department order by hiredate)
from employees

GO

drop table if exists Departments
-- Create Departments table
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY IDENTITY(1,1),
    DeptName VARCHAR(50) NOT NULL
);
Go

drop table if exists Employees
-- Create Employees table
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY IDENTITY(1,1),
    EmpName VARCHAR(100) NOT NULL,
    DeptID INT FOREIGN KEY REFERENCES Departments(DeptID),
    Salary DECIMAL(10,2),
    HireDate DATE
);
Go

drop table if exists Projects
-- Create Projects table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY IDENTITY(1,1),
    ProjectName VARCHAR(100) NOT NULL,
    DeptID INT FOREIGN KEY REFERENCES Departments(DeptID)
);
Go

drop table if exists EmployeeProjects
-- Create EmployeeProjects table (Many-to-Many Relationship)
CREATE TABLE EmployeeProjects (
    EmpID INT FOREIGN KEY REFERENCES Employees(EmpID),
    ProjectID INT FOREIGN KEY REFERENCES Projects(ProjectID),
    AssignedDate DATE,
    PRIMARY KEY (EmpID, ProjectID)
);
Go
-- Insert data into Departments
INSERT INTO Departments (DeptName) VALUES 
('HR'), 
('IT'), 
('Finance');
Go

-- Insert data into Employees
INSERT INTO Employees (EmpName, DeptID, Salary, HireDate) VALUES 
('Alice', 1, 50000, '2020-01-10'),
('Bob', 2, 70000, '2019-05-23'),
('Charlie', 2, 80000, '2021-08-19'),
('David', 3, 65000, '2018-11-03'),
('Eve', 3, 75000, '2022-02-25');
Go

-- Insert data into Projects
INSERT INTO Projects (ProjectName, DeptID) VALUES 
('HR Automation', 1),
('Software Development', 2),
('Cloud Migration', 2),
('Financial Analysis', 3);
Go

-- Insert data into EmployeeProjects
INSERT INTO EmployeeProjects (EmpID, ProjectID, AssignedDate) VALUES 
(1, 1, '2023-01-15'),
(2, 2, '2023-02-20'),
(3, 2, '2023-03-05'),
(3, 3, '2023-04-10'),
(4, 4, '2023-05-25'),
(5, 4, '2023-06-30');
Go


select * from Departments;
select * from Employees;
select * from Projects;
select * from EmployeeProjects;

select *
from 
	Employees
	inner join -- =join
	Departments
	on Employees.DeptID = Departments.DeptID

select *
from 
	Employees
	left outer join 
	Departments
	on Employees.DeptID = Departments.DeptID

select *
from 
	Employees
	right outer join 
	Departments
	on Employees.DeptID = Departments.DeptID

select *
from 
	Employees
	full outer join 
	Departments
	on Employees.DeptID = Departments.DeptID





