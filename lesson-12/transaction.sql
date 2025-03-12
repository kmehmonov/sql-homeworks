use lesson12;
GO

create table tblPhysicalAddress(
    id int,
    empNumber int,
    houseNumber int,
    street varchar(50),
    city varchar(50)
)

insert into tblPhysicalAddress
VALUES
    (1, 101, 10, 'kingstreet', 'londoon')


create table tblMailingAddress(
    id int,
    empNumber int,
    houseNumber int,
    street varchar(50),
    city varchar(50)
)

insert into tblMailingAddress
VALUES
    (1, 101, 10, 'kingstreet', 'londoon')


GO
create procedure usp_UpdateAddress
AS
BEGIN
    begin TRY
        print 'in try block'
        begin TRANSACTION
            update tblMailingAddress set city='london' where empNumber=101
            update tblPhysicalAddress set city='london' where empNumber=101
        COMMIT TRANSACTION
    end try
    begin CATCH
        print 'in catch block'
        rollback TRANSACTION
    end catch

    select * from tblMailingAddress
    SELECT * from  tblPhysicalAddress
end

exec usp_UpdateAddress

