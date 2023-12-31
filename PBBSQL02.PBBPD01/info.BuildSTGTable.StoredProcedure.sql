USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [info].[BuildSTGTable]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*****************************************************************************
 **
 ** Name:      BuildACQTable.sql
 **
 ** Purpose:   Insert Audit Log Record
 **
 ** Output:
 **
 ** Revisions:
 **
 ** Ver        Date        Author           Description
 ** ---------  ----------  ---------------  ----------------------------------
 ** 1.0        01/01/2023  Boyer            Created
 ** 1.1        06/07/2023  Sunil            Updated meta fields data type
 **
 *****************************************************************************/


-- BUILD ACQ table  :  ONE TIME PER TABLE  :  DO NOT EXECUTE IF TABLE EXISTS
CREATE PROCEDURE [info].[BuildSTGTable]
AS

DECLARE @SSchema varchar(50), @TSchema varchar(50), @ISchema varchar(50), @TTable varchar(100) , @KeyFields varchar(200)
DECLARE @sql nvarchar(max)
DECLARE @sqlTable table(s varchar(max), id int identity)
DECLARE @newline 				  nvarchar(2) 				= NCHAR(13) + NCHAR(10)

BEGIN
	set @ISchema = 'info'   

	DECLARE DB_CURSOR CURSOR LOCAL FOR
	  SELECT STGSchema, ACQSchema, TableName, MetaRowKeyFields
		FROM info.SourceTable st
	   WHERE NOT EXISTS (SELECT 1 FROM [PBBPACQ01].INFORMATION_SCHEMA.TABLES ist WHERE st.ACQSchema = ist.TABLE_SCHEMA AND st.TableName = ist.TABLE_NAME)
	     AND EXISTS     (SELECT 1 FROM [PBBPSTG01].INFORMATION_SCHEMA.TABLES ist WHERE st.STGSchema = ist.TABLE_SCHEMA AND st.TableName = ist.TABLE_NAME)
	   -- and MetaRowKeyFields <> 'NA'
	   ORDER BY 1,2

	OPEN DB_CURSOR 
	FETCH NEXT FROM DB_CURSOR INTO @SSchema, @TSchema, @TTable, @KeyFields

	WHILE @@FETCH_STATUS = 0
	BEGIN
	 	 --PRINT CONCAT_WS(@newline,@SSchema,@TSchema,@TTable,@KeyFields);

	    set @sql = ''
		delete from @sqlTable
	
		-- create statement  
		-- DECLARE @sql varchar(max) , @TSchema varchar(50) ='AcqOmnia',@TTable varchar(50)='Srvitem', @schema varchar(50)='Info'
		insert into  @sqlTable values ( 'create table [PBBPACQ01].' + @TSchema + '.' +  @TTable + ' (' )

		-- column list
		insert into @sqlTable(s)
		select  
			'  ['+column_name+'] ' 
			+ case when data_type = 'timestamp' then 'int' else data_type end 
			+ case when character_maximum_length=-1 then '(max)' 
							 else coalesce('('+cast(character_maximum_length as varchar)+')','') 
							 end + ' ' +

			+ ' ' +
			( case when IS_NULLABLE = 'No' then 'NOT ' else '' end ) + 'NULL ' + 
			coalesce('DEFAULT '+COLUMN_DEFAULT,'') + ','

		 from INFORMATION_SCHEMA.COLUMNS where table_name = @TTable AND table_schema = @SSchema and column_name not like 'Meta%'
		 order by ordinal_position

		 --print @sql

		 -- Add Meta Columns
		 insert into @sqlTable(s) values ( 'MetaRowKey varchar(2000) not null, '  )
		 insert into @sqlTable(s) values ( 'MetaRowKeyFields varchar(2000) not null, '  )
		 insert into @sqlTable(s) values ( 'MetaRowHash varbinary(200) not null, '  )
		 insert into @sqlTable(s) values ( 'MetaSourceSystemCode varchar(100) not null, '  )
		 insert into @sqlTable(s) values ( 'MetaInsertDateTime datetime not null, '  )
		 insert into @sqlTable(s) values ( 'MetaUpdateDateTime datetime not null, '  )
		 insert into @sqlTable(s) values ( 'MetaEffectiveStartDatetime datetime not null, '  )
		 insert into @sqlTable(s) values ( 'MetaEffectiveEndDatetime datetime not null, '  )
		 insert into @sqlTable(s) values ( 'MetaCurrentRecordIndicator varchar(1) not null, '  )
		 insert into @sqlTable(s) values ( 'MetaOperationCode char(1) not null, '  )
		 insert into @sqlTable(s) values ( 'MetaDataQualityStatusId varchar(50) not null '  )

		 -- select * from  @sqlTable;
		 /*
		-- primary key
		declare @pkname   varchar(100)
		select  @pkname = constraint_name from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
		where table_name = @TTable and table_schema = @SSchema and constraint_type='PRIMARY KEY'

		if ( @pkname is not null ) begin
			insert into @sqlTable(s) values('  PRIMARY KEY (')
			insert into @sqlTable(s)
				select '   ['+COLUMN_NAME+'],' from INFORMATION_SCHEMA.KEY_COLUMN_USAGE
				where constraint_name = @pkname
				order by ordinal_position
			-- remove trailing comma
			update @sqlTable set s=left(s,len(s) ) where id=@@identity
			insert into @sqlTable(s) values ('  )')
		end
		else begin
			-- remove trailing comma
			update @sqlTable set s=left(s,len(s) ) where id=@@identity
		end
		*/
		
		select @sql =@sql+s from @sqlTable order by id 
		 
		--set @sql = @sql + ' CONSTRAINT idx_u1_'+@TTable+' UNIQUE ('+ replace(@KeyFields,'|',',') + ',MetaEffectiveStartDatetime)'
	 
	 

		-- closing bracket
		set @sql = @sql +  ');'  

		-- result!
		--select s from @sqlTable order by id 
		 --select @sql
		 --print @sql;
		 EXEC sp_executesql @sql  

		--  UNIQUE INDEX

	 

		FETCH NEXT FROM DB_CURSOR INTO @SSchema, @TSchema, @TTable, @KeyFields
	END

	CLOSE DB_CURSOR
	DEALLOCATE DB_CURSOR

END
 
 
 
GO
