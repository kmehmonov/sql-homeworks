USE lesson13;
GO

--method-1
--Enter a date to see that month calendar
declare @InputDate date = '2025-03-14'

--build monthly calendar
;with cte as (
	Select
		DATEFROMPARTS(YEAR(@InputDate), MONTH(@InputDate), 1) as [Date],
		DATENAME(WEEKDAY, DATEFROMPARTS(YEAR(@InputDate), MONTH(@InputDate), 1)) as WeekDayName,
		DATEPART(weekday, DATEFROMPARTS(YEAR(@InputDate), MONTH(@InputDate), 1)) as WeekDayNum,
		1 as weekNum

	UNION ALL
	
	select
		DATEADD(day, 1, [Date]),
		DATENAME(WEEKDAY, DATEADD(day, 1, [Date])),
		DATEPART(weekday, DATEADD(day, 1, [Date])),
		case
			when WeekDayNum>DATEPART(weekday, DATEADD(day, 1, [Date])) then weekNum+1 else weekNum
		end
	from cte
	where [date] < eomonth(@InputDate)
)

--build calendar table
select 
    WeekNum,
    MAX(CASE WHEN WeekDayName = 'Sunday' THEN DAY([Date]) END) AS Sunday,
    MAX(CASE WHEN WeekDayName = 'Monday' THEN DAY([Date]) END) AS Monday,
    MAX(CASE WHEN WeekDayName = 'Tuesday' THEN DAY([Date]) END) AS Tuesday,
    MAX(CASE WHEN WeekDayName = 'Wednesday' THEN DAY([Date]) END) AS Wednesday,
    MAX(CASE WHEN WeekDayName = 'Thursday' THEN DAY([Date]) END) AS Thursday,
    MAX(CASE WHEN WeekDayName = 'Friday' THEN DAY([Date]) END) AS Friday,
    MAX(CASE WHEN WeekDayName = 'Saturday' THEN DAY([Date]) END) AS Saturday
FROM cte
GROUP BY WeekNum
ORDER BY WeekNum;

GO


--method-2
--Enter a date to see that month calendar
declare @InputDate DATE = '1994-12-21';

-- first day of the week is sunday
;WITH cte AS
	(
    -- Start from the 1st of the month
    SELECT 
        DATEFROMPARTS(YEAR(@InputDate), MONTH(@InputDate), 1) AS [Date], 
        DATEPART(WEEKDAY, DATEFROMPARTS(YEAR(@InputDate), MONTH(@InputDate), 1)) AS WeekDayNumber
    
    UNION ALL

    -- Generate all dates in the month
    SELECT 
        DATEADD(DAY, 1, [Date]),
        DATEPART(WEEKDAY, DATEADD(DAY, 1, [Date]))
    FROM cte
    WHERE [Date] < EOMONTH(@InputDate)
),
cte2 AS
	(
    -- Add a week number to group weeks
    SELECT 
        [Date], 
        DATENAME(WEEKDAY, [Date]) AS [DayName],
        WeekDayNumber,
		--DATEADD(DAY, -WeekDayNumber, [Date]) as new,
        DENSE_RANK() OVER (ORDER BY DATEADD(DAY, -WeekDayNumber, [Date])) AS WeekNum
    FROM cte
)
-- convert into calendar table
SELECT 
    WeekNum,
    MAX(CASE WHEN DayName = 'Sunday' THEN DAY([Date]) END) AS Sunday,
    MAX(CASE WHEN DayName = 'Monday' THEN DAY([Date]) END) AS Monday,
    MAX(CASE WHEN DayName = 'Tuesday' THEN DAY([Date]) END) AS Tuesday,
    MAX(CASE WHEN DayName = 'Wednesday' THEN DAY([Date]) END) AS Wednesday,
    MAX(CASE WHEN DayName = 'Thursday' THEN DAY([Date]) END) AS Thursday,
    MAX(CASE WHEN DayName = 'Friday' THEN DAY([Date]) END) AS Friday,
    MAX(CASE WHEN DayName = 'Saturday' THEN DAY([Date]) END) AS Saturday
FROM cte2
GROUP BY WeekNum
ORDER BY WeekNum;

