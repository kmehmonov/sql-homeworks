USE lesson13;
GO

--Enter a date to see that month calendar
declare @InputDate DATE = '2094-12-21';

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