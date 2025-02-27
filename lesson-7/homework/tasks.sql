use lesson7;
Go


drop table if exists Customers;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

drop table if exists Orders;
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);


drop table if exists OrderDetails;
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

drop table if exists Products;
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);
Go



-- Insert data into Customers table
INSERT INTO Customers (CustomerID, CustomerName) VALUES
(1, 'Alice Johnson'),
(2, 'Bob Smith'),
(3, 'Charlie Brown'),
(4, 'David Williams'),
(5, 'Emma Wilson');

-- Insert data into Products table
INSERT INTO Products (ProductID, ProductName, Category) VALUES
(101, 'Laptop', 'Electronics'),
(102, 'Smartphone', 'Electronics'),
(103, 'Desk Chair', 'Furniture'),
(104, 'Coffee Table', 'Furniture'),
(105, 'Headphones', 'Electronics');

-- Insert data into Orders table
INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1001, 1, '2024-01-15'),
(1002, 2, '2024-02-10'),
(1003, 3, '2024-02-20'),
(1004, 1, '2024-03-05'),
(1005, 4, '2024-03-10');

-- Insert data into OrderDetails table
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, Price) VALUES
(1, 1001, 101, 1, 1200.00),
(2, 1001, 105, 2, 150.00),
(3, 1002, 102, 1, 800.00),
(4, 1003, 103, 1, 250.00),
(5, 1003, 104, 1, 300.00),
(6, 1004, 105, 3, 150.00),
(7, 1005, 101, 1, 1200.00);


-- TASK-1️ Retrieve All Customers With Their Orders (Include Customers Without Orders)
--Use an appropriate JOIN to list all customers, their order IDs, and order dates.
--Ensure that customers with no orders still appear.

--method-1
select c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate
FROM 
	Customers as c
	left join
	Orders as o
	on c.CustomerID=o.CustomerID;

--method-2
select c.CustomerID, c.CustomerName, t.OrderID, t.OrderDate
FROM 
	Customers as c
	outer apply
	(
		select * from Orders where c.CustomerID=CustomerID
	) as t
order by CustomerID;


--TAK-2️ Find Customers Who Have Never Placed an Order
--Return customers who have no orders.

--method-1
select *
from
	Customers
where CustomerID not in (select distinct CustomerID from Orders)

--method-2
select c.CustomerID, c.CustomerName
FROM 
	Customers as c
	left join
	Orders as o
	on c.CustomerID=o.CustomerID
where o.OrderID is NULL;

--method-3
select c.CustomerID, c.CustomerName
FROM 
	Customers as c
	outer apply
	(
		select * from Orders where c.CustomerID=CustomerID
	) as t
where t.OrderID is NULL
order by CustomerID;

--method-4
SELECT c.CustomerID, c.CustomerName
FROM Customers AS c
WHERE NOT EXISTS (
    SELECT 1 FROM Orders AS o WHERE o.CustomerID = c.CustomerID
);


--TASK-3️ List All Orders With Their Products
--Show each order with its product names and quantity.

SELECT o.OrderID, p.ProductName, od.Quantity 
FROM 
	Orders AS o
	JOIN
	OrderDetails AS od ON o.OrderID = od.OrderID
	JOIN 
	Products AS p ON od.ProductID = p.ProductID;

--TASK-4️ Find Customers With More Than One Order
--List customers who have placed more than one order.
--method-1
select *
from
	Customers
	where CustomerID in
	(
		select CustomerID from orders
		group by CustomerID
		having COUNT(OrderID)>1

	);

--method-2
SELECT
	DISTINCT c.CustomerID,	c.CustomerName
FROM
	Customers AS c
	JOIN
	Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 1;

--TASK-5️ Find the Most Expensive Product in Each Order
--method-1
select
	*
from
	(
	select
		od.OrderID,
		p.productName,
		od.Price,
		row_number() over(partition by od.OrderID order by od.Price desc) as [rank]
	from
		OrderDetails as od
		join
		Products as p
		on od.ProductID =  p.ProductID
	) as t
WHERE t.[rank]=1

--method-2
SELECT DISTINCT
    od.OrderID,
    FIRST_VALUE(p.ProductName) OVER (PARTITION BY od.OrderID ORDER BY od.Price DESC) AS MostExpensiveProduct,
    FIRST_VALUE(od.Price) OVER (PARTITION BY od.OrderID ORDER BY od.Price DESC) AS Price
FROM
	OrderDetails AS od
	JOIN
	Products AS p ON od.ProductID = p.ProductID;

--TASK-6️ Find the Latest Order for Each Customer
SELECT Distinct
    c.CustomerID,
    FIRST_VALUE(o.OrderDate) OVER (PARTITION BY c.CustomerID ORDER BY o.OrderDate DESC) AS LastOrderDate
FROM
	Customers AS c
	JOIN
	Orders AS o ON c.CustomerID = o.CustomerID;

--TASK-7️ Find Customers Who Ordered Only 'Electronics' Products
--List customers who only purchased items from the 'Electronics' category.

select CustomerName
from
	Customers as c
	join
	Orders as o on c.CustomerID=o.CustomerID
	join 
	OrderDetails as od on o.OrderID=od.OrderID
	join
	Products as p on od.ProductID=p.ProductID
group by CustomerName
having sum(iif(Category='Electronics',1,0))=count(Category)

--TASK-8️ Find Customers Who Ordered at Least One 'Stationery' Product
--List customers who have purchased at least one product from the 'Stationery' category.
select CustomerName
from
	Customers as c
	join
	Orders as o on c.CustomerID=o.CustomerID
	join 
	OrderDetails as od on o.OrderID=od.OrderID
	join
	Products as p on od.ProductID=p.ProductID
group by CustomerName
having sum(iif(Category='Stationery',1,0))>=1

--TASK-9️ Find Total Amount Spent by Each Customer
--Show CustomerID, CustomerName, and TotalSpent
--method-1
select
	c.CustomerID,
	c.CustomerName,
	ISNULL(sum(od.price * od.Quantity), 0) as TotalSpent
from
	Customers as c
	left join
	Orders as o on c.CustomerID=o.CustomerID
	left join 
	OrderDetails as od on o.OrderID=od.OrderID
group by c.CustomerID, c.CustomerName

--method-2
SELECT
	c.CustomerID,
	c.CustomerName,
	ISNULL(t.TotalSpent, 0)
FROM
	Customers AS c
	CROSS APPLY (
		SELECT SUM(od.Price * od.Quantity) AS TotalSpent
		FROM Orders AS o
		JOIN OrderDetails AS od ON o.OrderID = od.OrderID
		WHERE o.CustomerID = c.CustomerID
	) AS t;














