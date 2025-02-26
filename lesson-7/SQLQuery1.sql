create database lesson7;
Go

Use lesson7;
go

drop table if exists People;
Go

CREATE TABLE People(    ID INT    ,NAME VARCHAR(10)    ,GENDER VARCHAR(1));INSERT INTO dbo.People(ID,NAME,GENDER)VALUES    (1,'Neeraj','M'),    (2,'Mayank','M'),    (3,'Pawan','M'),    (4,'Gopal','M'),    (5,'Sandeep','M'),    (6,'Isha','F'),    (7,'Sugandha','F'),    (8,'kritika','F');select * from People-- method-1select *,	ROW_NUMBER() over(order by id) as newfrom	Peoplewhere GENDER='M'union allselect *,	ROW_NUMBER() over(order by id) as newfrom	Peoplewhere GENDER='F'order by new-- method-2select *from Peopleorder by ROW_NUMBER() over(partition by gender order by id), gender desc;GOcreate table department(	id int primary key,	name varchar(50));create table employee(	id int primary key,	name varchar(50),	salary int,	department int,	mgr_id int);insert into departmentvalues	(1, 'IT'),	(2, 'Marketing'),	(3, 'HR'),	(4, 'Sales')insert into employeevalues 	(1, 'Mardon', 50000, 1, NULL),	(2, 'Iskandar', 4000, 2, 1),	(3, 'Mirshod', 4500, 1, 1),	(4, 'Shavkat', 4200, 3, 2);select	e.name as ename,	d.name as dname,	m.name as  mname,	d2.name as mdnameFROM	employee as e	INNER JOIN	department as d	ON e.department = d.id	inner join 	employee as m	on e.mgr_id=m.id	inner join	department as d2	on d2.id=m.department where e.department <> m.departmentdeclare @n intset @n=11select 	sum(ordinal)from 	string_split(replicate(',', @n), ',',1)group by value	