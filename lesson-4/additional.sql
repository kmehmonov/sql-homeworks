CREATE DATABASE dbAdditional;
GO

USE dbAdditional;
GO


DROP TABLE IF EXISTS tblEmployees;
GO

CREATE TABLE tblEmployees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE,
    Age INT,
    PerformanceRating INT
);
GO

INSERT INTO tblEmployees (EmployeeID, FirstName, LastName, Department, Salary, HireDate, Age, PerformanceRating)  
VALUES  
(1, 'John', 'Doe', 'IT', 75000, '2018-06-15', 30, 4),  
(2, 'Jane', 'Smith', 'HR', 60000, '2020-09-10', 28, 3),  
(3, 'Mike', 'Brown', 'Finance', 80000, '2015-03-25', 35, 5),  
(4, 'Emily', 'Davis', 'IT', 72000, '2019-07-01', 32, 4),  
(5, 'Daniel', 'Wilson', 'Marketing', 65000, '2021-01-20', 27, 2),  
(6, 'Sophia', 'Anderson', 'Finance', 85000, '2017-11-30', 40, 5),  
(7, 'David', 'White', 'HR', 59000, '2022-05-18', 25, 3),  
(8, 'Emma', 'Taylor', 'IT', 77000, '2016-08-12', 37, 4),  
(9, 'Oliver', 'Martinez', 'Marketing', 70000, '2023-02-05', 29, 2),  
(10, 'Ava', 'Thomas', 'Finance', 90000, '2014-12-10', 42, 5);
GO

--Find the average salary for employees in each department, 
--but only include departments where the average salary is greater than the company's overall average salary.

SELECT
	Department, 
	AVG(Salary) as [DepartmentAverageSalary]
FROM tblEmployees
GROUP BY Department
having AVG(Salary)>(select avg(salary) from tblEmployees)

--Retrieve the departments where at least two employees have a salary greater than 75,000.
SELECT Department FROM tblEmployees
where Salary> 75000
group by Department
having count(*)>=2

--List all unique first names of employees who work in either
--the IT or Finance department using UNION, ensuring no duplicates appear.
select FirstName  from tblEmployees
where Department = 'IT'
UNION
select FirstName from tblEmployees
where Department = 'Finance'

--Retrieve the top 5 highest-paid employees but skip the first 3 highest-paid ones.
select * from tblEmployees
order by Salary desc
OFFSET 3 rows fetch next 5 rows only

/* CASE Statement for Salary Bands
Classify employees into three salary bands:

"Junior" for salaries below 60,000
"Mid-level" for salaries between 60,000 and 79,999
"Senior" for salaries 80,000 and above
Return the EmployeeID, Full Name, Salary, and Salary Band. */

select EmployeeID, concat(FirstName, ' ', LastName) as [Full Name], Salary,
	Case
		when salary>=80000 then 'Senior'
		when salary >= 60000 then 'Mid-level'
		else 'Junior'
	END AS [Salary Band]
from tblEmployees

/* Complex IIF Condition
Create a column that determines if an employee is "Eligible for Promotion" based on the following rules:
Performance rating is 4 or higher
They have worked for more than 5 years in the company*/

select *,
	IIF (PerformanceRating>=4 AND DATEDIFF(MONTH, HireDate, getdate())>60, 'Eligible', 'NOT elligible') as [Promotion elligibilty]
from tblEmployees

/*GROUP BY with Multiple Aggregations
For each department, calculate:

The total number of employees
The highest salary
The lowest salary
The average age of employees*/

select Department, Count(*) as noe, Max(salary) as maxSalary, MIN(Salary) as minsalary, AVG(Salary) as avgSalary, AVG(AGE) as avgAge
from tblEmployees
group by Department

--Retrieve all employees, ordered by department (ascending) and then by salary (descending).
select * from tblEmployees
order by Department asc, salary desc

--Return employee first names in uppercase, their last names in lowercase,
--and their hire date in the format Month DD, YYYY (e.g., "February 21, 2025").
select UPPER(FirstName), lower(LastName), concat(DATENAME(weekday, HireDate), ' ', DAY(HireDate),' ', YEAR(HireDate)) from tblEmployees

--Find all departments where the sum of salaries is greater than 150,000, and the number of employees is more than 3.
select department from tblEmployees
group by department
having sum(Salary)>150000 and count(*)>3