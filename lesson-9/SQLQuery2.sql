create database lesson9;
Go

use lesson9;
go



declare @word nvarchar(50) = 'aaaaabbbbbcccccc'

;with cte(n, chars) as 
(
    select 1, SUBSTRING(@word, 1, 1) as chars
    union all
    select n+1, SUBSTRING(@word, n+1, 1)
    from cte
    where n < len(@word)
)

select chars, count(n) from cte
group by chars




