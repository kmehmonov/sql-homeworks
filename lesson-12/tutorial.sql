use lesson12;
go

--==============================================
--Task-1   
--==============================================
-- This is one of my best interview question for 5 years plus experience people.
-- In this you have to find out rows where for each Id you have only one type of Type that is 21.
-- In the sample you should get 2 and 4 rows as output. Please see the sample input and expected output.


CREATE TABLE OnlyOneType
(
     Id INT
    ,[Type] INT
    ,Vals DECIMAL(10,2)
)
GO
 
INSERT INTO OnlyOneType VALUES
(1,3 ,900.00 ),
(1,3 ,200.00 ),
(1,3 ,800.00 ),
(1,21,200.00 ),
(2,21,100.00  ),
(2,21,100.00  ),
(3,3 ,100.00 ),
(3,3 ,100.00 ),
(4,21,100.00)
GO
 
SELECT * FROM OnlyOneType t1
WHERE
    [Type]=21 and not exists (select * from OnlyOneType as t2 where t1.id=t2.id and t2.[Type]<>21)

--==============================================
--Task-2   
--==============================================
-- In this puzzle you have to find the maximum value for each Id and then
-- get the Item for that Id and Maximum value. The Challenge is to do that in
-- a SINGLE SELECT. Please check out sample input and expected output.

CREATE TABLE TestMaximum
(
     [ID] INT
    ,[Item] VARCHAR(20)
    ,Vals INT
)
 
INSERT TestMaximum VALUES
(1, 'a1',15),
(1, 'a2',20),
(1, 'a3',90),
(2, 'q1',10),
(2, 'q2',40),
(2, 'q3',60),
(2, 'q4',30),
(3, 'q5',20);

select * from TestMaximum
-- method-1 
SELECT top 3 *
FROM TestMaximum
order by ROW_NUMBER() over(partition by id order by Vals desc)


-- method-2
SELECT TOP 1 WITH TIES [ID], [Item], Vals
FROM TestMaximum
ORDER BY ROW_NUMBER() OVER (PARTITION BY [ID] ORDER BY Vals DESC)

--==============================================
--Task-3    
--==============================================
-- In this puzzle the requirement is you have to write a SINGLE T-SQL to get
-- Minimum balance, Average balance, Maximum Balance and last and first value of
-- balance per month and account. Please see expected output and input for more details.
-- For more details please check the sample input and expected output.


CREATE TABLE GetMinMaxAvgVal
(
     Id INT
    ,Acct INT
    ,Months INT  
    ,Bal INT
)
GO
 
INSERT INTO GetMinMaxAvgVal VALUES
(1, 10011, 1, 345),
(2, 10011, 1, 122),
(3, 10011, 1, 190),
(4, 10011, 2, 111),
(5, 10011, 3, 2300),
(6, 10011, 3, 87820),
(7, 10012, 1, 345),
(8, 10012, 1, 190),
(9, 10012, 3, 5000),
(10, 10012, 3, 1500),
(11, 10012, 3, 7000)

select * from GetMinMaxAvgVal
-- method-1
SELECT 
    Id
    ,Acct
    ,Months
    ,Bal
    ,MIN(Bal) over (partition by Acct, Months) AS MinBal
    ,AVG(Bal*1.0) over (partition by Acct, Months) AS AvgBal
    ,MAX(Bal) over (partition by Acct, Months) AS MaxBal
    ,FIRST_VALUE(Bal) OVER (PARTITION BY Acct, Months ORDER BY Id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED following ) AS FirstBal
    ,LAST_VALUE(Bal) OVER (PARTITION BY Acct, Months ORDER BY Id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED following) AS LastBal
FROM GetMinMaxAvgVal
order by id

-- method-2
SELECT 
    Id
    ,Acct
    ,Months
    ,Bal
    ,(select Min(Bal) from GetMinMaxAvgVal t2 where t2.Acct=t1.Acct and t2.Months=t1.Months ) AS MinBal
    ,(select avg(Bal) from GetMinMaxAvgVal t2 where t2.Acct=t1.Acct and t2.Months=t1.Months )  AS AvgBal
    ,(select Max(Bal) from GetMinMaxAvgVal t2 where t2.Acct=t1.Acct and t2.Months=t1.Months )  AS MaxBal
    ,(select top 1 Bal from GetMinMaxAvgVal t2 where t2.Acct=t1.Acct and t2.Months=t1.Months   order by id ) AS FirstBal
    ,(select top 1 Bal from GetMinMaxAvgVal t2 where t2.Acct=t1.Acct and t2.Months=t1.Months   order by id desc ) AS LastBal
FROM GetMinMaxAvgVal t1
order by id

--==============================================
--Task-3    
--==============================================
-- In this puzzle we have to manipulate the column PhoneNumber to get
-- the phone numbers in the US format. The expectation is minimal transformation.

CREATE TABLE USNumber
(
     ID INT
    ,PhoneNumber VARCHAR(13)
)
GO
 
INSERT INTO USNumber VALUES (1, '+1 3039293143'),(2,'+1 3059293143') 
GO

select * from USNumber

SELECT Id, FORMAT(cast(replace(PhoneNumber,'+1 ', '') as bigint), '###-###-####')
FROM USNumber

--====================================================
--Task-4
--====================================================

CREATE TABLE Employees1
(
     EmployeeName         VARCHAR(100)
    ,EmployeeType        VARCHAR(100)       
    ,StartDateTime    DATETIME
    ,EndDateTime DATETIME
)
GO
 
INSERT INTO Employees1 VALUES
('Pawan K'            ,          'N'                      ,'2016-09-01 06:00:00'    , '2016-09-01 14:00:00' ),
('Ramesh K'             ,             'N'                 ,     '2016-09-01 13:00:00' ,    '2016-09-02 09:00:00' ),
('Sharlee D'              ,         'D'                    , '2016-09-01 09:00:00'     ,'2016-09-01 13:00:00' ),
('Mizan D'                ,           'D'                  ,   '2016-09-01 20:00:00'    , '2016-09-02 08:00:00' )
GO
 
SELECT * FROM Employees1
GO

DECLARE @StartingTime DATETIME = '2016-09-01 07:00:00';
DECLARE @EndingTime DATETIME = '2016-09-02 06:59:59';

;WITH DateBreakdown AS (
    SELECT 
        EmployeeName,
        EmployeeType,
        CAST(StartDateTime AS DATE) AS WorkDate,  -- Extract the date
        StartDateTime,
        EndDateTime
    FROM Employees1
),
AdjustedHours AS (
    SELECT 
        EmployeeName,
        EmployeeType,
        WorkDate,
        
        -- Adjust start time within the range
        CASE 
            WHEN StartDateTime < @StartingTime THEN @StartingTime
            ELSE StartDateTime
        END AS AdjustedStart,

        -- Adjust end time within the range
        CASE 
            WHEN EndDateTime > @EndingTime THEN @EndingTime
            ELSE EndDateTime
        END AS AdjustedEnd
    FROM DateBreakdown
)
SELECT 
    EmployeeType,
    CAST(AdjustedStart AS DATE) AS WorkDate,  -- Group by each day
    SUM(DATEDIFF(MINUTE, AdjustedStart, AdjustedEnd)) / 60.0 AS TotalHoursWorked
FROM AdjustedHours
WHERE AdjustedEnd > AdjustedStart  -- Exclude invalid entries
GROUP BY EmployeeType, CAST(AdjustedStart AS DATE)
ORDER BY EmployeeType, WorkDate;

