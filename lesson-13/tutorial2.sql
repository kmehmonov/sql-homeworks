use lesson13;
Go



declare @InputDate date = '1994-12-21'

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
