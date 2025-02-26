create database lesson7;
Go

Use lesson7;
go

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    DepartmentID INT
);

INSERT INTO Employees (EmployeeID, Name, DepartmentID)
VALUES (1, 'Alice', 10), (2, 'Bob', 20), (3, 'Charlie', 10), (4, 'David', 30);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES (10, 'HR'), (20, 'IT'), (30, 'Finance');


select * from Employees;
select * from Departments;

select *
from
	Employees as e
	--cross apply
	outer apply
	(
		select * from Departments where DepartmentID=e.DepartmentID
	) as t
order by EmployeeID


--=========================================

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

INSERT INTO Customers (CustomerID, CustomerName)
VALUES (1, 'Alice'), (2, 'Bob'), (3, 'Charlie');

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    Amount DECIMAL(10,2),
    SaleDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Sales (SaleID, CustomerID, Amount, SaleDate)
VALUES (101, 1, 500.00, '2024-02-01'),
       (102, 1, 300.00, '2024-02-10'),
       (103, 2, 700.00, '2024-02-05');

select * from Customers;
select * from Sales;


SELECT c.CustomerID, c.CustomerName, s.SaleID, s.Amount, s.SaleDate
FROM Customers c
--CROSS APPLY (
Outer APPLY (
    SELECT TOP 1 SaleID, Amount, SaleDate
    FROM Sales
    WHERE Sales.CustomerID = c.CustomerID
    ORDER BY SaleDate DESC
) s;






	