create database lesson13;
GO

Use lesson13
GO


--================================================
--          FUNCTIONS
--================================================

-- 1. Scalar functions
-- 2. Table-valued functions
    -- 2.1 Inline functions
    -- 2.2 Multi-statement functions

CREATE FUNCTION myfunction() RETURNS INT
AS
BEGIN
    RETURN 1;
END;
GO

CREATE FUNCTION makeSquare(@num int) RETURNS INT
AS
BEGIN
    RETURN @num*@num;
END;
GO

-- Call function with schema name always
SELECT dbo.makeSquare(4);
GO
--================================================
--          Task
--================================================

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FullName VARCHAR(100) NOT NULL,
    Department VARCHAR(50) NOT NULL
);

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY IDENTITY(1,1),
    ProjectName VARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL
);

CREATE TABLE EmployeeProjects (
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    ProjectID INT FOREIGN KEY REFERENCES Projects(ProjectID),
    Role VARCHAR(50),
    HoursWorked DECIMAL(10,2),
    PRIMARY KEY (EmployeeID, ProjectID)
);
INSERT INTO Employees (FullName, Department) VALUES
    ('Alice Johnson', 'IT'),
    ('Bob Smith', 'IT'),
    ('Charlie Brown', 'HR'),
    ('David White', 'Finance');

INSERT INTO Projects (ProjectName, StartDate, EndDate) VALUES
    ('ERP System', '2023-01-01', '2024-06-30'),
    ('Website Redesign', '2023-05-15', '2023-12-31'),
    ('HR Automation', '2023-07-01', '2024-03-15'),
    ('Financial Forecasting', '2023-08-01', NULL); -- Ongoing project

INSERT INTO EmployeeProjects (EmployeeID, ProjectID, Role, HoursWorked) VALUES
    (1, 1, 'Developer', 400),
    (1, 2, 'Lead Developer', 300),
    (2, 1, 'QA Engineer', 250),
    (2, 3, 'Consultant', 150),
    (3, 3, 'HR Specialist', 350),
    (4, 4, 'Analyst', 200);

select * from EmployeeProjects
select * from Employees
select * from Projects
GO

create function getDetails()
returns TABLE
AS
RETURN (
select 
    FullName,
    Department,
    sum(HoursWorked) over(partition by ep.EmployeeID) as TotalHoursWorked,
    LAST_VALUE(ProjectName) over(partition by ep.EmployeeID order by EndDate rows between unbounded preceding and unbounded following ) as LastProjectName

from
    EmployeeProjects as ep 
    join
    Employees as e on ep.EmployeeID = e.EmployeeID
    JOIN
    Projects as p on ep.ProjectID = p.ProjectID
)
GO


create function getDetails2()
returns @newtable TABLE(
    FullName VARCHAR(100),
    Department VARCHAR(50),
    TotalHoursWorked DECIMAL(10,2),
    LastProjectName VARCHAR(100)
)
AS
Begin
insert into @newtable
select 
    FullName,
    Department,
    sum(HoursWorked) over(partition by ep.EmployeeID) as TotalHoursWorked,
    LAST_VALUE(ProjectName) over(partition by ep.EmployeeID order by EndDate rows between unbounded preceding and unbounded following ) as LastProjectName

from
    EmployeeProjects as ep 
    join
    Employees as e on ep.EmployeeID = e.EmployeeID
    JOIN
    Projects as p on ep.ProjectID = p.ProjectID
return 
END
GO

select * from getDetails2()