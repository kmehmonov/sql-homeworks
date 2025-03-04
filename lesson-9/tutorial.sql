create database lesson9;
Go

use lesson9;
go


--==================================================================
--Given a Students table, rank students by score using DENSE_RANK().
--==================================================================
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    [Name] VARCHAR(100),
    Score INT
);
INSERT INTO Students (StudentID, [Name], Score) VALUES
(1, 'Alice', 95),
(2, 'Bob', 85),
(3, 'Charlie', 95),
(4, 'David', 80),
(5, 'Eve', 75),
(6, 'Frank', 85);

;with cteRankedStudents as(
	select *,
		DENSE_RANK() over(order by Score desc) as rnk
	from Students
) 

select * from cteRankedStudents order by rnk;


--==================================================================
--Calculate a running total of sales for each month.
--==================================================================
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    SaleDate DATE,
    Amount DECIMAL(10,2)
);
INSERT INTO Sales (SaleID, SaleDate, Amount) VALUES
(1, '2024-01-01', 100),
(2, '2024-01-05', 150),
(3, '2024-01-10', 200),
(4, '2024-02-01', 250),
(5, '2024-02-15', 300),
(6, '2024-03-01', 350);

;with ctePartitionedSalesByMonth as (
	select *,
		sum(Amount) over(partition by MONTH(SaleDate) order by SaleDate) as RunningTotal
	from Sales
)

select * from ctePartitionedSalesByMonth


--==================================================================
--Identify students who were absent for 3 or more consecutive days.
--==================================================================

CREATE TABLE Attendance (
    StudentID INT,
    AttendanceDate DATE,
    Status VARCHAR(10) CHECK (Status IN ('Present', 'Absent'))
);
INSERT INTO Attendance (StudentID, AttendanceDate, Status) VALUES
(1, '2024-02-01', 'Absent'),
(1, '2024-02-02', 'Absent'),
(1, '2024-02-03', 'Absent'),
(1, '2024-02-04', 'Present'),
(2, '2024-02-01', 'Present'),
(2, '2024-02-02', 'Absent'),
(2, '2024-02-03', 'Absent');

; with cteConsecutiveAbsences as(
	select *,
		ROW_NUMBER() over(partition by studentID order by AttendanceDate)-
		DENSE_RANK() over(partition by StudentID, Status order by AttendanceDate) as GroupID
	from Attendance
	where status = 'Absent'
)

SELECT StudentID, COUNT(*) AS ConsecutiveDays
FROM cteConsecutiveAbsences
GROUP BY StudentID, GroupID
HAVING COUNT(*) >= 3;

