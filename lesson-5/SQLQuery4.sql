CREATE DATABASE lesson5;
GO

USE lesson5;
GO

--WINDOW FUNCTION
DROP TABLE IF EXISTS Sales;
GO

CREATE TABLE Sales (    SaleID INT IDENTITY(1,1) PRIMARY KEY,    SaleDate DATE NOT NULL,    Amount DECIMAL(10,2) NOT NULL);INSERT INTO Sales (SaleDate, Amount) VALUES('2024-01-01', 100),('2024-01-02', 200),('2024-01-03', 150),('2024-01-04', 300),('2024-01-05', 250),('2024-01-06', 400),('2024-01-07', 350),('2024-01-08', 450),('2024-01-09', 500),('2024-01-10', 100);select *,ROW_NUMBER() over(order by amount asc) as rn_asc,ROW_NUMBER() over(order by amount desc) as rn_descfrom Salesselect top 10 amount from sales;