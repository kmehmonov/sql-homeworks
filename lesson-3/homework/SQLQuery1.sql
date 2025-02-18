CREATE DATABASE lesson3;
GO

USE lesson3;
GO

DROP TABLE IF EXISTS Employees;
GO

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);
GO

DROP TABLE IF EXISTS Orders;
GO
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);
GO

DROP TABLE IF EXISTS Products;
GO
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);
GO

-- SAMPLE DATAS for working with
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary, HireDate)
VALUES
(1, 'John', 'Doe', 'Sales', 50000.00, '2020-01-15'),
(2, 'Jane', 'Smith', 'Marketing', 55000.00, '2019-03-20'),
(3, 'Sam', 'Brown', 'IT', 70000.00, '2018-07-25'),
(4, 'Lisa', 'White', 'HR', 45000.00, '2021-11-30'),
(5, 'Tom', 'Green', 'Sales', 48000.00, '2020-05-10'),
(6, 'Nancy', 'Black', 'Finance', 65000.00, '2017-06-14'),
(7, 'James', 'Taylor', 'Marketing', 53000.00, '2021-08-05'),
(8, 'Sarah', 'Wilson', 'IT', 75000.00, '2016-12-01'),
(9, 'David', 'Moore', 'Finance', 69000.00, '2019-02-22'),
(10, 'Emily', 'Davis', 'HR', 46000.00, '2022-04-15');

GO
INSERT INTO Orders (OrderID, CustomerName, OrderDate, TotalAmount, Status)
VALUES
(1, 'John Doe', '2025-02-01', 250.75, 'Shipped'),
(2, 'Jane Smith', '2025-02-03', 450.40, 'Delivered'),
(3, 'Sam Brown', '2025-01-15', 125.50, 'Pending'),
(4, 'Lisa White', '2025-01-22', 300.00, 'Cancelled'),
(5, 'Tom Green', '2025-02-05', 800.00, 'Shipped'),
(6, 'Nancy Black', '2025-01-28', 150.25, 'Delivered'),
(7, 'James Taylor', '2025-02-10', 600.80, 'Pending'),
(8, 'Sarah Wilson', '2025-02-12', 250.00, 'Shipped'),
(9, 'David Moore', '2025-01-25', 540.60, 'Cancelled'),
(10, 'Emily Davis', '2025-02-14', 320.90, 'Delivered');
GO

INSERT INTO Products (ProductID, ProductName, Category, Price, Stock)
VALUES
(1, 'Laptop', 'Electronics', 1200.50, 25),
(2, 'Smartphone', 'Electronics', 800.75, 40),
(3, 'Desk Chair', 'Furniture', 150.20, 50),
(4, 'Keyboard', 'Electronics', 45.00, 60),
(5, 'Mouse', 'Electronics', 25.00, 100),
(6, 'Monitor', 'Electronics', 300.00, 30),
(7, 'Dining Table', 'Furniture', 500.00, 15),
(8, 'Sofa', 'Furniture', 700.00, 10),
(9, 'Air Conditioner', 'Electronics', 400.00, 20),
(10, 'Bookshelf', 'Furniture', 200.00, 35);
GO

-- Task-1

--the top 10% highest-paid employees.
select top 10 percent * from Employees
ORDER BY Salary DESC;
GO

--Groups them by department and calculates the average salary per department.
select Department, AVG(Salary) as AverageSalaryPerDepartment from Employees
GROUP BY Department;
GO

/*
Displays a new column SalaryCategory:
'High' if Salary > 80,000
'Medium' if Salary is between 50,000 and 80,000
'Low' otherwise.
*/
;
SELECT *,  
CASE
	WHEN Salary > 80000 then 'High'
	when Salary > 50000 then 'Medium'
	else 'Low'
END AS SalaryCategory 
FROM employees
GO

--Orders the result by AverageSalary descending.
SELECT Department, AVG(Salary) AS AverageSalaryPerDepartment
FROM Employees
GROUP BY Department
ORDER BY AverageSalaryPerDepartment DESC;
GO


----Skips the first 2 records and fetches the next 5.

SELECT * FROM Employees
ORDER BY FirstName
OFFSET 2 ROWS FETCH NEXT 5 ROWS ONLY;
GO
--TASK-2

--Selects customers who placed orders between '2023-01-01' and '2023-12-31

Select * from orders
where orderdate between  '2023-01-01' and '2023-12-31';

--Includes a new column OrderStatus that returns:
--'Completed' for Shipped or Delivered orders.
--'Pending' for Pending orders.
--'Cancelled' for Cancelled orders.

Select *, 
CASE
	WHEN status='Shipped' or status='Delivered' then 'Completed'
	WHEN status='Pending' then 'Pending' 
	WHEN status='Cancelled' then 'Cancelled'
END AS OrderStatus
FROM Orders
GO

--Groups by OrderStatus and finds the total number of orders and total revenue.

SELECT 
    OrderStatus,
    COUNT(*) AS totalOrders,
    SUM(TotalAmount) AS TotalRevenue
FROM (
    SELECT *, 
        CASE
            WHEN status = 'Shipped' OR status = 'Delivered' THEN 'Completed'
            WHEN status = 'Pending' THEN 'Pending' 
            WHEN status = 'Cancelled' THEN 'Cancelled'
        END AS OrderStatus
    FROM Orders
) AS OrderSummary
GROUP BY OrderStatus;
GO

--Filters only statuses where revenue is greater than 5000.

SELECT 
    OrderStatus,
    COUNT(*) AS totalOrders,
    SUM(TotalAmount) AS TotalRevenue
FROM (
    SELECT *, 
        CASE
            WHEN status = 'Shipped' OR status = 'Delivered' THEN 'Completed'
            WHEN status = 'Pending' THEN 'Pending' 
            WHEN status = 'Cancelled' THEN 'Cancelled'
        END AS OrderStatus
    FROM Orders
) AS OrderSummary
GROUP BY OrderStatus
having SUM(TotalAmount)>5000;

GO

--Orders by TotalRevenue descending.

SELECT 
    OrderStatus,
    COUNT(*) AS totalOrders,
    SUM(TotalAmount) AS TotalRevenue
FROM (
    SELECT *, 
        CASE
            WHEN status = 'Shipped' OR status = 'Delivered' THEN 'Completed'
            WHEN status = 'Pending' THEN 'Pending' 
            WHEN status = 'Cancelled' THEN 'Cancelled'
        END AS OrderStatus
    FROM Orders
) AS OrderSummary
GROUP BY OrderStatus
order by TotalRevenue DESC;

GO

--TASK-3
--Selects distinct product categories.
SELECT DISTINCT Category from Products;

--Finds the most expensive product in each category.

SELECT Category, max(Price) AS MostExpensive from Products
group by Category;
GO

--Assigns an inventory status using IIF:
--'Out of Stock' if Stock = 0.
--'Low Stock' if Stock is between 1 and 10.
--'In Stock' otherwise.

select *,
IIF(stock=0, 'Out of Stock',
	IIF(
		stock<10, 'Low Stock', 'In Stock'
	)

) as  inventoryStatus
from Products;
GO


-- Orders the result by Price descending and skips the first 5 rows.

select * from Products
Order by Price DESC
OFFSET 5 ROWS 
GO

