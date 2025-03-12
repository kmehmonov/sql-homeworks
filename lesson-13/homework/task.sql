USE lesson13;
GO

declare @InputDate DATE = '2021-09-01';

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
        DATEPART(WEEKDAY, [Date]) AS WeekDayNumber,
        DENSE_RANK() OVER (ORDER BY DATEADD(DAY, -DATEPART(WEEKDAY, [Date]), [Date])) AS WeekNum
    FROM cte
)


select * from cte2;

select DATEPART(WEEKDAY, '2024-10-25')

