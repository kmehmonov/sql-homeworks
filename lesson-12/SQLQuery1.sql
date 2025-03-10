create database lesson12;
GO

use lesson12;
go

--=======================================================
-- Stored protsedures
--=======================================================

declare  @temp table (
	n int
);

declare @n int = 0;

while @n<10
begin
	insert into @temp
	select @n
	set @n=@n+1
end

select * from @temp


