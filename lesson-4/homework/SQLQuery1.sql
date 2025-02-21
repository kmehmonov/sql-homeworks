CREATE DATABASE lesson4;
GO

USE lesson4;
GO


--============================================================
--TASK-1
--If all the columns having zero value then don't show that row
--============================================================


DROP TABLE IF EXISTS [TestMultipleZero];
GO


CREATE TABLE [dbo].[TestMultipleZero]
(
    [A] [int] NULL,
    [B] [int] NULL,
    [C] [int] NULL,
    [D] [int] NULL
);
GO

INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0),
	(1,1,1,1);
GO

--ANSWER
SELECT *
FROM [TestMultipleZero]
WHERE NOT (A=0 AND B=0 AND C=0 AND D=0)
GO


--============================================================
--TASK-2
--Write a query which will find maximum value
--FROM multiple columns of the table.
--============================================================

DROP TABLE IF EXISTS TestMax;
GO

CREATE TABLE TestMax
(
    Year1 INT
    ,Max1 INT
    ,Max2 INT
    ,Max3 INT
);
GO
 
INSERT INTO TestMax 
VALUES
    (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);
GO

SELECT * FROM TestMax
GO

--ANSWER
--method-1
SELECT
	Year1, 
	IIF(Max1>Max2 AND Max1>Max3, Max1,
		IIF(Max2>Max3, Max2, Max3)
	) As MaxValue
FROM TestMax;
GO
--method-2
SELECT Year1, 
    CASE 
        WHEN Max1 >= Max2 AND Max1 >= Max3 THEN Max1
        WHEN Max2 >= Max1 AND Max2 >= Max3 THEN Max2
        ELSE Max3
    END AS MaxValue
FROM TestMax;
GO




--============================================================
--TASK-3
-- Write a query which will find the Date of Birth of
--employees whose birthdays lies between May 7 and May 15.
--============================================================



DROP TABLE IF EXISTS EmpBirth;
GO

CREATE TABLE EmpBirth
(
    EmpId INT  IDENTITY(1,1) 
    ,EmpName VARCHAR(50) 
    ,BirthDate DATETIME 
);
GO

INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT'Ramesh', '05/09/1983';
GO

SELECT * FROM EmpBirth;
GO

--ANSWER

SELECT * 
FROM EmpBirth
WHERE MONTH(BirthDate)=5 and DAY(BirthDate) between 7 and 15;


--============================================================
--TASK-4
--Order letters but 'b' must be first/last
--Order letters but 'b' must be 3rd (Optional)
--============================================================
DROP TABLE IF EXISTS letters;
GO

CREATE table letters
(letter char(1));

insert into letters
values ('a'), ('a'), ('a'), 
  ('b'), ('c'), ('d'), ('e'), ('f');

SELECT * FROM letters

--ANSWER
-- b in first
SELECT letter
FROM letters
ORDER BY CASE WHEN letter = 'b' THEN 0 ELSE 1 END, letter;

-- b in last
SELECT letter
FROM letters
ORDER BY CASE WHEN letter = 'b' THEN 1 ELSE 0 END, letter;

-- b in 3rd position

WITH OrderedLetters AS (
    SELECT letter, ROW_NUMBER() OVER (ORDER BY letter) AS rn
    FROM letters
    WHERE letter != 'b'
)
SELECT letter FROM OrderedLetters WHERE rn < 3 
UNION ALL
SELECT 'b'
UNION ALL
SELECT letter FROM OrderedLetters WHERE rn >= 3;









