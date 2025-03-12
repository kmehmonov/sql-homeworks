create database lesson12;
GO

use lesson12;
go

--=======================================================
-- task-1
--=======================================================

-- Table for storing all metadata
DECLARE @temp table(
	DatabaseName nvarchar(255),
	SchemaName nvarchar(255),
	ColumnName nvarchar(255),
	DataType nvarchar(255)
);

-- table for storing all database Names
DECLARE @Databases TABLE (
    database_id INT IDENTITY(1,1),
    name NVARCHAR(255)
);

INSERT INTO @Databases (name)
SELECT [name]
FROM sys.databases
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')
ORDER BY database_id;




DECLARE @i INT = 1;
DECLARE @NumberOFDatabases INT;
DECLARE @DatabaseName NVARCHAR(255);

-- Get total databases count
SELECT @NumberOFDatabases = COUNT(*) FROM @Databases;

-- Loop through the databases
WHILE @i <= @NumberOFDatabases
BEGIN
    -- Get database name by ID
    SELECT @DatabaseName = name FROM @Databases WHERE database_id = @i;
    
    -- prepare query to get metadata of @DatabaseName
	declare @sql_query nvarchar(max) = '
	SELECT 
		TABLE_CATALOG AS [DatabaseName],
		TABLE_SCHEMA AS [Schema],
		COLUMN_NAME AS [ColumnName],
		CONCAT(DATA_TYPE, 
			   ''('' + 
			   IIF(CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) = ''-1'', ''max'', CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR))  
			   + '')'') AS DataType
	FROM ' + QUOTENAME(@DatabaseName) + '.INFORMATION_SCHEMA.COLUMNS;';

	--get metadata of @DatabaseName and save it @temp table
	insert into @temp
		EXEC sp_executesql @sql_query;

    -- Increment counter
    SET @i = @i + 1;
END;

select * from @temp
GO

--=======================================================
-- task-2
--=======================================================


create procedure usp_GetProceduresAndFunctions
	@DatabaseName NVARCHAR(255) = NULL
AS
Begin
	-- Table for storing all metadata
	DECLARE @temp table(
		DatabaseName nvarchar(255),
		SchemaName nvarchar(255),
		ObjectName nvarchar(255),
		ObjectType nvarchar(255)
	);

	-- table for storing all database Names
	DECLARE @Databases TABLE (
		database_id INT IDENTITY(1,1),
		name NVARCHAR(255)
	);

	IF @DatabaseName IS NULL
    BEGIN
        INSERT INTO @Databases (name)
        SELECT name FROM sys.databases
        WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb') -- Exclude system databases
        ORDER BY database_id;
    END
    ELSE
    BEGIN
        INSERT INTO @Databases (name) VALUES (@DatabaseName);
    END;



	DECLARE @i INT = 1;
	DECLARE @NumberOFDatabases INT;
	--DECLARE @DatabaseName NVARCHAR(255);

	-- Get total databases count
	SELECT @NumberOFDatabases = COUNT(*) FROM @Databases;

	-- Loop through the databases
	WHILE @i <= @NumberOFDatabases
	BEGIN
		-- Get database name by ID
		SELECT @DatabaseName = name FROM @Databases WHERE database_id = @i;
    
		-- prepare query to get metadata of @DatabaseName
		DECLARE @sql_query NVARCHAR(MAX);

		SET @sql_query = '
		SELECT ' + QUOTENAME(@DatabaseName, '''') + ' AS DatabaseName,
			SchmList.name AS SchemaName,
			ObjList.name AS ObjectName,
			ObjList.type AS ObjectType
		FROM 
			' + QUOTENAME(@DatabaseName) + '.sys.all_objects AS ObjList
		JOIN 
			' + QUOTENAME(@DatabaseName) + '.sys.schemas AS SchmList 
			ON ObjList.schema_id = SchmList.schema_id
		WHERE ObjList.type IN (''FN'', ''P'');';

		--get metadata of @DatabaseName and save it @temp table
		insert into @temp
			EXEC sp_executesql @sql_query;

		-- Increment counter
		SET @i = @i + 1;
	END;
	select * from @temp
END;
go

-- run save dprocedure
exec usp_GetProceduresAndFunctions 


