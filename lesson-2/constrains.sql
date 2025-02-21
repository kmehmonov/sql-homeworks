-- constraint = cheklov 


use class1

create table person
(
	id int,
	name varchar(50)
);

insert into person
values
	(1, 'a');

select * from person;

insert into person
values
	(1, 'null');

select * from person;

insert into person
values
	(null, 'a');

select * from person;

drop table if exists person;
create table person
(
	id int not null,
	name varchar(50)
);

insert into person
values
	(-1, 'a'),
	('  ', 'a');

select * from person


/* UNIQUE constraint */


drop table if exists person;
create table person
(
	id int unique,
	name varchar(50)
);

insert into person
values
	(1, 'John'),
	(-1, 'John'),
	(null, 'Adam');
select * from person

if ''=0
begin
	print 'true'
end
else
begin
	print 'false'
end


drop table if exists person;
create table person
(
	id int not null,
	name varchar(50)
);

alter table person
--add unique(id);
add constraint UC__person__id unique(id)

insert into person
values
	(1, 'John'),
	(-1, 'John');

select * from person;

-- constraintni o'chirish

alter table person
drop constraint UC__person__id;


--unique constrain bitta null ga ruxsat beradi
-- unique constraintni hoxlagancha columnga qo'yish mumkin


drop table if exists person;
create table person
(
	id int not null,
	name varchar(50)
);

alter table person
add unique(id, name)
-- combinatsiyani unique qiladi
insert into person
values
	(1, 'John'),
	(1, 'John1');

select * from person;




/* PRIMARY KEY = not null & unique &  clustered index*/

drop table if exists person;
create table person
(
	id int primary key,
	name varchar(50)
);

INSERT INTO person
values
	(null, 'john1');


/* Foreign key */

use class1
go

--==========================================
DROP TABLE IF EXISTS person; 

CREATE TABLE person
(
	[id] INT PRIMARY KEY,
	[name] VARCHAR(50),
	[department_id] int
);

-- Ensure column names match exactly with table definition
INSERT INTO person (id, name, department_id)
VALUES
	(1, 'john', 1);

INSERT INTO person (id, name, department_id)
VALUES
	(2, 'john', 2);

INSERT INTO person (id, name, department_id)
VALUES
	(3, 'smith', 5);
 


create table department
(
	id int primary key,
	name varchar(50)
);

insert into department
values
	(1, 'HR'),
	(2, 'IT');


select * from person
select * from department

--==================================--
drop table if exists department
create table department
(
	id int primary key,
	name varchar(50)
);

insert into department
values
	(1, 'HR'),
	(2, 'IT'),
	(3, 'Marketing');


DROP TABLE IF EXISTS person; 
CREATE TABLE person
(
	[id] INT PRIMARY KEY,
	[name] VARCHAR(50),
	[department_id] int foreign key references department(id)
);

-- Ensure column names match exactly with table definition
INSERT INTO person (id, name, department_id)
VALUES
	(1, 'john', 3);


/* CHECK CONSTRAINTS */
drop table if exists employee;
create table employee
(
	id int primary key,
	name varchar(50),
	age int check (age between 0 and 100)
);

insert into employee
values
	(1, 'tom', 100)

select * from employee


/* DEFAULT CONSTRAINTS */
drop table if exists employee;
create table employee
(
	id int primary key,
	name varchar(50),
	age int check (age between 0 and 100),
	email varchar(50) DEFAULT 'no email'
);

insert into employee(id, name, age)
values
	(1, 'tom', 100);

select * from employee;

/* identity constraints  */

drop table if exists person;
create table person
(
	id int primary key identity(1,1),
	name varchar(50)
);

insert into person
values
	('john');

select * from person

--==========

SET IDENTITY_INSERT person ON

insert into person
values
	(1, 'john');










