CREATE DATABASE lesson6;
GO

USE lesson6;
GO


DROP TABLE if EXISTS t;
GO

CREATE TABLE t
(
ID INT
,Typ VARCHAR(1)
,Value1 VARCHAR(1)
,Value2 VARCHAR(1)
,Value3 VARCHAR(1)
)
GO
 

INSERT INTO t(ID,Typ,Value1,Value2,Value3)
VALUES
(1,'I','a','b',''),
(2,'O','a','d','f'),
(3,'I','d','b',''),
(4,'O','g','l',''),
(5,'I','z','g','a'),
(6,'I','z','g','a');
GO

select * from t

select Typ, sum(New) 
from (select *,
    IIF(Value1='a', 1, 0)+IIF(Value2='a', 1, 0)+IIF(Value3='a', 1, 0) as new
from t) as newtable
group by Typ

SELECT * FROM STRING_SPLIT(REPLICATE('1,', 100), ',');





