--Use lesson5 database
USE lesson5;
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
-- checking table
SELECT * FROM Employees;
GO

-- Assign a Unique Rank to Each Employee Based on Salary
SELECT *,
    ROW_NUMBER() OVER(ORDER BY Salary desc) AS SalaryRank
    FROM Employees

-- Find Employees Who Have the Same Salary Rank
SELECT *,
    RANK() OVER(ORDER BY Salary desc) AS SalaryRank
    FROM Employees

-- Identify the Top 2 Highest Salaries in Each Department
SELECT * FROM (
    SELECT *, 
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
    FROM Employees
) AS RankedData
WHERE SalaryRank <= 2;


-- Find the Lowest-Paid Employee in Each Department
select * 
FROM
    (SELECT *,
    DENSE_RANK() OVER(PARTITION By Department ORDER BY Salary asc) AS SalaryRank
    FROM Employees) as RankedData
WHERE SalaryRank=1

-- Calculate the Running Total of Salaries in Each Department
SELECT *,
    SUM(Salary) OVER (PARTITION BY Department ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSalary
FROM Employees;

-- Find the Total Salary of Each Department Without GROUP BY
SELECT Distinct Department,
    SUM(Salary) OVER (PARTITION BY Department) AS TotalSalaryOfDeparment
FROM Employees


-- Calculate the Average Salary in Each Department Without GROUP BY
select Distinct Department, 
    AVG(Salary) OVER (PARTITION BY Department) AS AvgSalaryOfDeparment
FROM Employees


-- Find the Difference Between an Employee’s Salary and Their Department’s Average
SELECT *,
    AVG(Salary) OVER (PARTITION BY Department) AS AvgSalaryOfDeparment, 
    Salary - AVG(Salary) OVER (PARTITION BY Department) AS SalaryDiff
FROM Employees

-- Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
SELECT *,
    AVG(Salary) OVER (order by HireDate rows between 1 preceding and 1 following) AS MovingAvgSalary
FROM Employees

-- Find the Sum of Salaries for the Last 3 Hired Employees
SELECT SUM(Salary) AS SalaryOfLastHired3Empl
FROM (SELECT TOP 3 Salary FROM Employees ORDER BY HireDate DESC) AS LastHired;



-- Calculate the Running Average of Salaries Over All Previous Employees
select *,
    AVG(salary) over(order by HireDate rows between unbounded preceding and CURRENT row) AS RunningAvgSalary
FROM Employees


-- Find the Maximum Salary Over a Sliding Window of 2 Employees Before and After
select *,
    Max(salary) over(order by HireDate rows between 2 preceding and 2 following) AS RunningMaxSalary
FROM Employees

-- Determine the Percentage Contribution of Each Employee’s Salary to Their Department’s Total Salary

select *, 
    Cast(Salary / NULLIF(SUM(Salary) over(PARTITION by Department),0) * 100 as decimal(10,2)) 
from Employees





