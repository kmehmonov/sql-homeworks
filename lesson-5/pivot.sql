USE lesson5;
GO

DROP TABLE IF EXISTS Sales;
GO

CREATE TABLE Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    Employee VARCHAR(50),
    SaleMonth VARCHAR(20),
    Amount DECIMAL(10,2)
);
GO


INSERT INTO Sales (Employee, SaleMonth, Amount) VALUES
    ('Alice', 'January', 5000),
    ('Alice', 'February', 7000),
    ('Alice', 'March', 6500),
    ('Bob', 'January', 4000),
    ('Bob', 'February', 6000),
    ('Bob', 'March', 6200),
    ('Charlie', 'January', 5500),
    ('Charlie', 'February', 7200),
    ('Charlie', 'March', 7100);

SELECT * FROM Sales

-- Convert the sales data from rows to columns (months as columns).
SELECT Employee, SALEMONTH, SUM(Amount)
FROM Sales
GROUP BY Employee, SaleMonth
ORDER BY Employee, DATEPART(month, SaleMonth + ' 01 2025')


DECLARE @cols NVARCHAR(MAX);
DECLARE @query NVARCHAR(MAX);

-- Step 1: Get unique months
SELECT @cols = STRING_AGG(QUOTENAME(SaleMonth), ', ')
FROM (SELECT DISTINCT SaleMonth FROM Sales) AS MonthsList;

-- Step 2: Construct the dynamic SQL query
SET @query = 
'SELECT Employee, ' + @cols + ' 
 FROM (SELECT Employee, SaleMonth, Amount FROM Sales) AS SourceTable
 PIVOT (SUM(Amount) FOR SaleMonth IN (' + @cols + ')) AS PivotTable;';

-- Step 3: Execute the query
EXEC sp_executesql @query;

SELECT * FROM SALES

SELECT *
FROM (
    SELECT EMPLOYEE, SALEMONTH, AMOUNT FROM Sales
) AS SourceTable

PIVOT (
    SUM(Amount) FOR SaleMonth IN ([January], [February], [March])
) AS PivotTable;



