create database lesson11;
GO

Use lesson1;
Go


--=========================================
--		SQL Server Variables
--=========================================

declare @txt varchar(max);
-- print NULL
select @txt

set @txt = 'Text'
--reassign value
set @txt = 'Text1'
--print Text1
select @txt

--assign value to variable with select : set = variable
select @txt = 'Text2'
select @txt

--Biita batch orasida ikkita bir xil nomli variable mumkin emas. ADD GO
Go;

with cte as( 
	select 1 as num
	union all
	select num+1 from cte
	where num<10
	)
select * into numbers from cte

--table
select * from numbers

-- n=last value of table
declare @n int;
select @n=num from numbers
select @n

go;
-- n=sum value of table
declare @n int = 0;
select @n=@n+num from numbers
select @n

Go

create table new1(
	id int,
	name varchar(10)
);

insert into new1
values (1, 'kamol'), (2, 'ali')

select * from new1
-- table variablega table tenglab bo'lmaydi
declare @tab table(id int, name varchar(20))
--xatolik beradi
set @tab = (select * from new1)

