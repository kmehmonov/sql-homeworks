/* */


--create database class1;
--go
use class1;

create table test (
	id int,
	[name] varchar(100)
);


insert into test
values
	(1, 'demo1'),
	(2, 'demo2');

select * from test;

select * from dbo.test;

select * from class1.dbo.test;


/* inserting values using select */
select 1 ;

print 1;

select 1, 2, 3, 4, 'john'

select 1 as first, 2 as second
--as is optional
select 1 first, 2 second

insert into test
select 3, 'demo3';

insert into test
select 4, 'demo4'
union all
select 5, 'demo5';

select * from test;


