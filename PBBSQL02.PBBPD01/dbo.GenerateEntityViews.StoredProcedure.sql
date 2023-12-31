USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[GenerateEntityViews]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GenerateEntityViews]
	@EntityName NVARCHAR(128) = '%'
AS
DECLARE @DimTable NVARCHAR(128)
DECLARE @ObjectId INT
DECLARE DimTable_Cursor CURSOR		
	LOCAL FAST_FORWARD FOR	
	SELECT name,
		object_id
	FROM sys.tables
	WHERE name LIKE 'Dim%'
	AND name != 'DimDate'
	AND SUBSTRING(name,4,125) LIKE @EntityName

OPEN DimTable_Cursor
FETCH NEXT FROM DimTable_Cursor INTO @DimTable, @ObjectId

WHILE @@FETCH_STATUS = 0
BEGIN

	DECLARE @SelectSQL NVARCHAR(MAX) = 'CREATE VIEW [dbo].[' + SUBSTRING(@DimTable,4,125) + ']' + CHAR(13)+CHAR(10)
		+ 'AS' + CHAR(13)+CHAR(10)
		+ 'SELECT '
	
	DECLARE @FactTableName NVARCHAR(128) = ''
	DECLARE @FactObjectId INT = 0
	SELECT @FactTableName = name,
		@FactObjectId = object_id
		FROM sys.tables
		WHERE name LIKE 'Fact' + SUBSTRING(@DimTable,4,125)

	DECLARE @ColumnSQL NVARCHAR(MAX) = ''
	DECLARE @ColumnTable NVARCHAR(128)
	DECLARE @Column NVARCHAR(128)
	DECLARE @RefObject INT
	DECLARE Column_Cursor CURSOR
		LOCAL FAST_FORWARD FOR
		WITH ColumnTable AS
		(SELECT @DimTable AS TableName,
			name AS ColumnName,
			0 AS RefObject,
			CASE WHEN column_id = 1 THEN 1 ELSE 3 END AS SortOrder
		FROM sys.columns
		WHERE object_id = @ObjectId
			AND column_id != 2
		UNION
		SELECT @FactTableName AS TableName,
			C.name AS ColumnName,
			ISNULL(FK.referenced_object_id, 0) AS RefObject,
			CASE WHEN FK.referenced_object_id IS NOT NULL THEN 2 ELSE 3 END AS SortOrder
		FROM sys.columns C
		LEFT JOIN sys.foreign_key_columns FK ON C.object_id = FK.parent_object_id
			AND C.column_id = FK.parent_column_id
		WHERE C.object_id = @FactObjectId
			AND C.column_id > 2
			AND C.name != @DimTable + 'Id')

		SELECT TableName,
			ColumnName,
			RefObject
		FROM ColumnTable
		ORDER BY SortOrder, ColumnName

	OPEN Column_Cursor
	FETCH NEXT FROM Column_Cursor INTO @ColumnTable, @Column, @RefObject

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ColumnSQL != '' SET @ColumnSQL += ',' + CHAR(13)+CHAR(10) +'	'
		SET @ColumnSQL += '[' + @ColumnTable + '].[' + @Column + ']'
			+ CASE WHEN @Column = @DimTable + 'Id'
				THEN ' AS ' + SUBSTRING(@DimTable,4,125) + 'Id'
				WHEN @RefObject > 0
					AND (@Column LIKE 'Dim%'OR @Column LIKE '%_Dim%')
				THEN ' AS ' + REPLACE(@Column, 'Dim', '')
				ELSE '' END

		FETCH NEXT FROM Column_Cursor INTO @ColumnTable, @Column, @RefObject
	END

	CLOSE Column_Cursor
	DEALLOCATE Column_Cursor

	DECLARE @TableSQL NVARCHAR(MAX) = CHAR(13)+CHAR(10) + 'FROM [dbo].[' + @DimTable + ']' + CHAR(13)+CHAR(10)
		+ CASE WHEN @FactTableName != '' THEN 'LEFT JOIN [dbo].[' + @FactTableName + ']'
		+ ' ON [' + @DimTable + '].[' + @DimTable + 'Id] = [' + @FactTableName + '].[' + @DimTable + 'Id]'
		+ CHAR(13)+CHAR(10) ELSE '' END
		+ 'WHERE [dbo].[' + @DimTable + '].[' + @DimTable + 'Id] > 0'

	DECLARE @SQL NVARCHAR(MAX) = @SelectSQL + @ColumnSQL + @TableSQL
	IF NOT EXISTS ( SELECT  object_id
					FROM sys.objects
					WHERE object_id = OBJECT_ID(SUBSTRING(@DimTable,4,125)))	
		EXECUTE sp_executesql @SQL

	FETCH NEXT FROM DimTable_Cursor INTO @DimTable, @ObjectId
END

CLOSE DimTable_Cursor
DEALLOCATE DimTable_Cursor
GO
