USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[MergeAcqTable]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================  
-- Description:	Merge Stage table with an Acq table
--  
-- Change histrory: 
-- Name			Auther			Date		Version		Description  
-- Comment      Boyer           02/01/2023  01.00       Initial version
-- Comment      Sunil           05/23/2023  02.00       Added logic for dynamic t2 load
-- =============================================
CREATE PROCEDURE [dbo].[MergeAcqTable]
     @V_ExecutionGroup VARCHAR(25),
     @V_StgSchema  VARCHAR(50),
	 @V_Table      VARCHAR(100) = NULL,
	 @LogParentID  INT
	 -- @RESULT       VARCHAR(1000) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- VARIABLES
	DECLARE @Version				  VARCHAR(10) = 'v2.00';
	DECLARE @ProcessDate			  DATE;
	DECLARE @RC						  int
	DECLARE @EtlName				  varchar(50)             = concat(@V_StgSchema, '.', @V_Table)
	DECLARE @LoadDttm				  varchar(40)             = GETDATE()
	DECLARE @ProcGUID				  varchar(50)
	DECLARE @ExecutionGUID			  varchar(50)
	DECLARE @MachineName			  varchar(50)             = HOST_NAME()
	DECLARE @UserName				  varchar(50)             = SUSER_NAME()
	DECLARE @ExecutionStep			  varchar(1000)
	DECLARE @ExecutionMsg			  varchar(MAX)          
	DECLARE @LogID					  numeric(18,0)           = @LogParentID 
	DECLARE @AcqSchema				  varchar(50)
	DECLARE @KeyFields				  varchar(100)
	DECLARE @V_ExecutionExp			  nvarchar(MAX)
	DECLARE @V_Columns_list 		  nvarchar(MAX)
	DECLARE @V_Columns_list_dest	  nvarchar(MAX)
	DECLARE @V_Columns_list_src		  nvarchar(MAX)
	DECLARE @sql_drop_if_exists_temp  nvarchar(MAX)
	DECLARE @sql_create_temp 		  nvarchar(MAX)
	DECLARE @sql_update_temp 		  nvarchar(MAX)
	DECLARE @sql_insert_temp 		  nvarchar(MAX)
	DECLARE @sql_Merge_stmt 		  nvarchar(MAX)
	DECLARE @V_Prcs_Sts               varchar(20)
	DECLARE @V_RowHashExp			  nvarchar(MAX)
	DECLARE @V_RowKeyFields			  nvarchar(MAX)
	DECLARE @V_RowKey				  nvarchar(MAX)
	DECLARE @newline 				  nvarchar(2) 				= NCHAR(13) + NCHAR(10)





  IF (@V_Table IS NULL)
   BEGIN
	DECLARE DB_CURSOR CURSOR LOCAL FOR
		SELECT 
			TableName
		FROM 
			info.SourceTable
		WHERE 
			ExecutionGroup = @V_ExecutionGroup
			AND ExecutionReadyFlag = 1  

	OPEN DB_CURSOR 
	FETCH NEXT FROM DB_CURSOR INTO @V_Table

	WHILE @@FETCH_STATUS = 0
	BEGIN

		BEGIN TRY
	SELECT  @V_StgSchema 	= STGSchema,
			@AcqSchema 		= ACQSchema,
			@V_Prcs_Sts 	= ExecutionStatus,
			@LoadDttm 		= GETDATE(),
			@V_Columns_list = ColumnList,
			@V_RowKeyFields = MetaRowKeyFields,
			@V_RowHashExp	= ColumnRowHashExp,
			@V_ExecutionExp = ExecutionExp
	FROM PBBPSTG01.info.SourceTable
	WHERE ExecutionGroup = @V_ExecutionGroup
			AND TableName = @V_Table;
	
	SET @V_Columns_list_src = replace(@V_Columns_list,'[',CONCAT('stg','.['));
	SET @V_Columns_list_dest = replace(@V_Columns_list,'[',CONCAT('acq','.['));
	SET @V_RowKey = replace(@V_RowKeyFields,',','||');
	
	SET @EtlName = concat(@V_StgSchema, '.', @V_Table);
	
	SET @ExecutionStep = concat(@EtlName,'|' , 'Step01');
	SET @ExecutionMsg = concat('Starting MergeAcqTable: ', @EtlName, @Version, ' ... ');

	IF @V_Prcs_Sts <> 'READY'
	raiserror('Execution status not set to READY, Please check!', 11, 1)
	--PRINT('Execution status not set to READY, Please check!')
    --return -1
			
---------------------------------------------------------
-- Start Logging
---------------------------------------------------------	

IF @V_Prcs_Sts = 'READY'
	EXECUTE @RC = info.ExecutionLogStart
	   @LogParentID
	  ,@V_ExecutionGroup
	  ,@V_StgSchema
	  ,@V_Table
	  ,@LoadDttm
	  ,@ProcGUID 
	  ,@ExecutionGUID 
	  ,@MachineName 
	  ,@UserName 
	  ,@ExecutionMsg 
	  ,@LogID OUTPUT;
	  
-- For Debug purpose - Print value of all the variables
---PRINT CONCAT_WS(@newline,@V_ExecutionGroup,@AcqSchema,@V_Table,@LoadDttm,@V_Columns_list_dest,@V_Columns_list_src,@LogID,@V_Prcs_Sts,@V_RowKey);


SET @ExecutionMsg = CONCAT_WS(@newline,@V_ExecutionGroup,@AcqSchema,@V_Table,@LoadDttm,@V_Columns_list_dest,@V_Columns_list,@V_Columns_list_src,@LogID,@V_Prcs_Sts,@V_RowKey)

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@ExecutionMsg;

---------------------------------------------------------
-- Execute Execution expression
---------------------------------------------------------

--IF @V_ExecutionExp IS NOT NULL
--EXEC(@V_ExecutionExp);

---------------------------------------------------------
-- Create _TEMP table with data from STG table including Meta columns
---------------------------------------------------------
IF @V_Prcs_Sts = 'READY'
SET @sql_drop_if_exists_temp = 'IF OBJECT_ID(''PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP'') IS NOT NULL DROP TABLE PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP';

-- For Debug purpose
---PRINT('1' + @sql_drop_if_exists_temp);

IF @V_Prcs_Sts = 'READY'
EXEC(@sql_drop_if_exists_temp);


IF @V_Prcs_Sts = 'READY'
SET @sql_create_temp = 
(
' SELECT
		'+@V_Columns_list_src+',
		'+@V_RowKey+' AS MetaRowKey,
		'''+@V_RowKeyFields+''' AS MetaRowKeyFields,
		'+@V_RowHashExp+' AS MetaRowHash,
		''omnia'' AS MetaSourceSystemCode,
		GETDATE() AS MetaInsertDatetime,
		GETDATE() AS MetaUpdateDatetime,
		''0'' AS MetaDataQualityStatusId
		into PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP
	FROM PBBPSTG01.'+@V_StgSchema+'.'+@V_Table+' stg
'
);

-- For debug purpose
---PRINT('2' + @sql_create_temp);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step02');

SET @ExecutionMsg = len(@sql_create_temp);

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@ExecutionMsg;


IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_create_temp;



---------------------------------------------------------
-- Create _TEMP table by performing join of STG(src) and ACQ(dest) table
---------------------------------------------------------
SET @sql_drop_if_exists_temp = 'IF OBJECT_ID(''PBBPSTG01.tmp.'+@V_Table+'_TEMP'') IS NOT NULL DROP TABLE PBBPSTG01.tmp.'+@V_Table+'_TEMP';

---PRINT(@newline+@sql_drop_if_exists_temp);

IF @V_Prcs_Sts = 'READY'
EXEC(@sql_drop_if_exists_temp);

-- Create Temp table by performing join of STG and ACQ table
IF @V_Prcs_Sts = 'READY'
SET @sql_create_temp =
(
'
SELECT
	*
	into PBBPSTG01.tmp.'+@V_Table+'_TEMP
FROM (
		-- Fetch Records to be deleted
		SELECT 
			'+@V_Columns_list_dest+',
			acq.MetaRowKey,
			acq.MetaRowKeyFields,
			acq.MetaRowHash,
			acq.MetaSourceSystemCode,
			acq.MetaInsertDatetime,
			acq.MetaUpdateDatetime,
			''D'' as MetaOperationCode,
			acq.MetaDataQualityStatusId,
			acq.MetaEffectiveStartDatetime,
			acq.MetaEffectiveEndDatetime,
			acq.MetaCurrentRecordIndicator
		FROM PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP stg
		RIGHT JOIN PBBPACQ01.'+@AcqSchema+'.'+@V_Table+' acq
			ON stg.MetaRowKey = acq.MetaRowKey
		WHERE stg.MetaRowKey IS NULL
			AND stg.MetaRowHash IS NULL
			AND acq.MetaCurrentRecordIndicator = ''Y''
		-- Fetch Records to be Updated
		UNION ALL
		SELECT
			'+@V_Columns_list_dest+',
			acq.MetaRowKey,
			acq.MetaRowKeyFields,
			acq.MetaRowHash,
			acq.MetaSourceSystemCode,
			acq.MetaInsertDatetime,
			stg.MetaUpdateDatetime,
			''U'' as MetaOperationCode,
			stg.MetaDataQualityStatusId,
			acq.MetaEffectiveStartDatetime,
			acq.MetaEffectiveEndDatetime,
			acq.MetaCurrentRecordIndicator
		FROM PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP stg
		JOIN PBBPACQ01.'+@AcqSchema+'.'+@V_Table+' acq
			ON stg.MetaRowKey = acq.MetaRowKey
			AND stg.MetaRowHash <> acq.MetaRowHash
			AND acq.MetaCurrentRecordIndicator = ''Y''
		-- Fetch Records to be Inserted
		UNION ALL
		SELECT
			'+@V_Columns_list_src+',
			stg.MetaRowKey,
			stg.MetaRowKeyFields,
			stg.MetaRowHash,
			stg.MetaSourceSystemCode,
			stg.MetaInsertDatetime,
			stg.MetaUpdateDatetime,
			''I'' as MetaOperationCode,
			stg.MetaDataQualityStatusId,
			CAST(''1900-01-01 00:00:00'' AS datetime) as MetaEffectiveStartDatetime,
			CAST(''9999-12-31 00:00:00'' AS datetime) as MetaEffectiveEndDatetime,
			''Y'' as MetaCurrentRecordIndicator
		FROM PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP stg
		LEFT JOIN PBBPACQ01.'+@AcqSchema+'.'+@V_Table+' acq
			ON stg.MetaRowKey = acq.MetaRowKey
		WHERE acq.MetaRowKey IS NULL
	) tmp;'
);

-- For debug purpose
---PRINT(@newline+@sql_create_temp);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step03');

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@sql_create_temp;

IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_create_temp;

---------------------------------------------------------
-- Update _TEMP table for matching MetaRowkey records
---------------------------------------------------------
IF @V_Prcs_Sts = 'READY'
SET @sql_update_temp =
(
'MERGE PBBPSTG01.tmp.'+@V_Table+'_TEMP AS tmp
using PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP stg
ON tmp.MetaRowKey = stg.MetaRowKey
AND tmp.MetaOperationCode = ''U''

WHEN MATCHED THEN 
	UPDATE 
	SET
		tmp.MetaUpdateDatetime = stg.MetaUpdateDatetime,
		tmp.MetaDataQualityStatusId = stg.MetaDataQualityStatusId,
		tmp.MetaEffectiveEndDatetime = DATEADD(ss,-1,stg.MetaUpdateDatetime),
		tmp.MetaCurrentRecordIndicator = ''N''
;'
);

-- For debug purpose
---PRINT(@newline+@sql_update_temp);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step04');

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@sql_update_temp;

IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_update_temp;

---------------------------------------------------------
-- Update _TEMP table for soft Deleted records
---------------------------------------------------------
IF @V_Prcs_Sts = 'READY'
SET @sql_update_temp =
(
'UPDATE PBBPSTG01.tmp.'+@V_Table+'_TEMP
	SET
		MetaUpdateDatetime = CAST(GETDATE() AS datetime),
		MetaEffectiveEndDatetime = DATEADD(ss,-1,CAST(GETDATE() AS datetime)),
		MetaCurrentRecordIndicator = ''N''
WHERE MetaOperationCode = ''D''
;'
);

-- For debug purpose
---PRINT(@newline+@sql_update_temp);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step05');

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@sql_update_temp;

IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_update_temp;

---------------------------------------------------------
-- Insert records with MetaOperationCode = 'U' from STG to _TEMP table
---------------------------------------------------------

-- Insert new entry for updated records
IF @V_Prcs_Sts = 'READY'
SET @sql_insert_temp = 
(
'INSERT INTO PBBPSTG01.tmp.'+@V_Table+'_TEMP
SELECT
	'+@V_Columns_list_src+',
	stg.MetaRowKey,
	stg.MetaRowKeyFields,
	stg.MetaRowHash,
	stg.MetaSourceSystemCode,
	stg.MetaInsertDatetime,
	stg.MetaUpdateDatetime,
	''I'' as MetaOperationCode,
	stg.MetaDataQualityStatusId,
	stg.MetaUpdateDatetime as MetaEffectiveStartDatetime,
	CAST(''9999-12-31 00:00:00'' as datetime) as MetaEffectiveEndDatetime,
	''Y'' as MetaCurrentRecordIndicator
FROM PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP stg
JOIN PBBPSTG01.tmp.'+@V_Table+'_TEMP tmp
	ON stg.MetaRowKey = tmp.MetaRowKey
	AND stg.MetaRowHash <> tmp.MetaRowHash
	AND tmp.MetaOperationCode = ''U''
;'
);


-- For debug purpose
---print(@newline+@sql_insert_temp);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step06');

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@sql_insert_temp;

IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_insert_temp;

---------------------------------------------------------
-- Reassign variable values for source-target merge statement in next step
---------------------------------------------------------

	IF @V_Prcs_Sts = 'READY'
	SELECT  @AcqSchema 	= ACQSchema,
			@V_Columns_list = COALESCE(ExecutionExp,ColumnList)
	FROM PBBPSTG01.info.SourceTable
	WHERE ExecutionGroup = @V_ExecutionGroup
			AND TableName = @V_Table;
		
	
	SET @V_Columns_list_src = replace(@V_Columns_list,'[',CONCAT('Source','.['));
	SET @V_Columns_list_dest = replace(@V_Columns_list,'[',CONCAT('Target','.['));
---------------------------------------------------------
-- Merge _TEMP(Source) table with ACQ(Target) table
---------------------------------------------------------

IF @V_Prcs_Sts = 'READY'
SET @sql_Merge_stmt =
(
'MERGE PBBPACQ01.'+@AcqSchema+'.'+@V_Table+' AS Target
USING PBBPSTG01.tmp.'+@V_Table+'_TEMP AS Source
ON Source.MetaRowKey = Target.MetaRowKey
AND Source.MetaRowHash = Target.MetaRowHash
AND Target.MetaCurrentRecordIndicator = ''Y''

-- For Deletes & Updates
WHEN MATCHED THEN 
	UPDATE 
	SET
			Target.MetaUpdateDatetime = Source.MetaUpdateDatetime,
			Target.MetaOperationCode = Source.MetaOperationCode,
			Target.MetaDataQualityStatusId = Source.MetaDataQualityStatusId,
			Target.MetaEffectiveStartDatetime = Source.MetaEffectiveStartDatetime,
			Target.MetaEffectiveEndDatetime = Source.MetaEffectiveEndDatetime,
			Target.MetaCurrentRecordIndicator = Source.MetaCurrentRecordIndicator
			
-- For Inserts
WHEN NOT MATCHED BY Target THEN
INSERT 
		(
			'+@V_Columns_list+',
			MetaRowKey,
			MetaRowKeyFields,
			MetaRowHash,
			MetaSourceSystemCode,
			MetaInsertDatetime,
			MetaUpdateDatetime,
			MetaOperationCode,
			MetaDataQualityStatusId,
			MetaEffectiveStartDatetime,
			MetaEffectiveEndDatetime,
			MetaCurrentRecordIndicator			
		)
VALUES 
		(
			'+@V_Columns_list_src+',
			Source.MetaRowKey,
			Source.MetaRowKeyFields,
			Source.MetaRowHash,
			Source.MetaSourceSystemCode,
			Source.MetaInsertDatetime,
			Source.MetaUpdateDatetime,
			Source.MetaOperationCode,
			Source.MetaDataQualityStatusId,
			Source.MetaEffectiveStartDatetime,
			Source.MetaEffectiveEndDatetime,
			Source.MetaCurrentRecordIndicator
		)
	;'
);

-- For debug purpose
---print(@newline+@sql_Merge_stmt);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step07');

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@sql_Merge_stmt;

IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_Merge_stmt;

---------------------------------------------------------
-- Clean up
---------------------------------------------------------	  
	  
SET @sql_drop_if_exists_temp = 'IF OBJECT_ID(''PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP'') IS NOT NULL DROP TABLE PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP';

IF @V_Prcs_Sts = 'READY'
EXEC(@sql_drop_if_exists_temp);


SET @sql_drop_if_exists_temp = 'IF OBJECT_ID(''PBBPSTG01.tmp.'+@V_Table+'_TEMP'') IS NOT NULL DROP TABLE PBBPSTG01.tmp.'+@V_Table+'_TEMP';

IF @V_Prcs_Sts = 'READY'
EXEC(@sql_drop_if_exists_temp);

---------------------------------------------------------
-- Stop Logging
---------------------------------------------------------
	  
 
	END TRY 

	-- ERROR HANDLING
    BEGIN CATCH
 
        SET @ExecutionMsg = 'FAILURE: '
		                              + ' || Error Number : '  + CAST(ERROR_NUMBER() AS VARCHAR(MAX))
                                      + ' , Error Severity : ' + CAST(ERROR_SEVERITY() AS VARCHAR(MAX))
                                      + ' , Error State : '    + CAST(ERROR_STATE() AS VARCHAR(MAX))
                                      + ' , Error Line : '     + CAST(ERROR_LINE() AS VARCHAR(MAX))
                                      + ' , Error Message : '  + ERROR_MESSAGE() + '.'
        EXECUTE @RC = info.ExecutionLogError
           @LogID
		  ,@V_StgSchema
		  ,@V_Table
          ,@ExecutionMsg 
        RETURN;
    END CATCH

	IF @V_Prcs_Sts = 'RUNNING'
	SET @ExecutionMsg = 'Successful Execution (' + @Version + ')'
	EXECUTE @RC = info.ExecutionLogStop
	   @LogID
	  ,@V_StgSchema
	  ,@V_Table
	  ,@ExecutionMsg;
	  
		FETCH NEXT FROM DB_CURSOR INTO @V_Table
	END
	
	CLOSE DB_CURSOR
	
   END
  ELSE
   BEGIN
  
		BEGIN TRY
	SELECT  @V_StgSchema 	= STGSchema,
			@AcqSchema 		= ACQSchema,
			@V_Prcs_Sts 	= ExecutionStatus,
			@LoadDttm 		= GETDATE(),
			@V_Columns_list = ColumnList,
			@V_RowKeyFields = MetaRowKeyFields,
			@V_RowHashExp	= ColumnRowHashExp,
			@V_ExecutionExp = ExecutionExp
	FROM PBBPSTG01.info.SourceTable
	WHERE ExecutionGroup = @V_ExecutionGroup
			AND TableName = @V_Table;
	
	SET @V_Columns_list_src = replace(@V_Columns_list,'[',CONCAT('stg','.['));
	SET @V_Columns_list_dest = replace(@V_Columns_list,'[',CONCAT('acq','.['));
	SET @V_RowKey = replace(@V_RowKeyFields,',','||');
	
	SET @EtlName = concat(@V_StgSchema, '.', @V_Table);
	
	SET @ExecutionStep = concat(@EtlName,'|' , 'Step01');
	SET @ExecutionMsg = concat('Starting MergeAcqTable: ', @EtlName, @Version, ' ... ');

	IF @V_Prcs_Sts <> 'READY'
	raiserror('Execution status not set to READY, Please check!', 11, 1)
	--PRINT('Execution status not set to READY, Please check!')
    --return -1
			
---------------------------------------------------------
-- Start Logging
---------------------------------------------------------	

IF @V_Prcs_Sts = 'READY'
	EXECUTE @RC = info.ExecutionLogStart
	   @LogParentID
	  ,@V_ExecutionGroup
	  ,@V_StgSchema
	  ,@V_Table
	  ,@LoadDttm
	  ,@ProcGUID 
	  ,@ExecutionGUID 
	  ,@MachineName 
	  ,@UserName 
	  ,@ExecutionMsg 
	  ,@LogID OUTPUT;
	  
-- For Debug purpose - Print value of all the variables
---PRINT CONCAT_WS(@newline,@V_ExecutionGroup,@AcqSchema,@V_Table,@LoadDttm,@V_Columns_list_dest,@V_Columns_list_src,@LogID,@V_Prcs_Sts,@V_RowKey);


SET @ExecutionMsg = CONCAT_WS(@newline,@V_ExecutionGroup,@AcqSchema,@V_Table,@LoadDttm,@V_Columns_list_dest,@V_Columns_list,@V_Columns_list_src,@LogID,@V_Prcs_Sts,@V_RowKey)

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@ExecutionMsg;

---------------------------------------------------------
-- Execute Execution expression
---------------------------------------------------------

--IF @V_ExecutionExp IS NOT NULL
--EXEC(@V_ExecutionExp);

---------------------------------------------------------
-- Create _TEMP table with data from STG table including Meta columns
---------------------------------------------------------
IF @V_Prcs_Sts = 'READY'
SET @sql_drop_if_exists_temp = 'IF OBJECT_ID(''PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP'') IS NOT NULL DROP TABLE PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP';

-- For Debug purpose
---PRINT('1' + @sql_drop_if_exists_temp);

IF @V_Prcs_Sts = 'READY'
EXEC(@sql_drop_if_exists_temp);


IF @V_Prcs_Sts = 'READY'
SET @sql_create_temp = 
(
' SELECT
		'+@V_Columns_list_src+',
		'+@V_RowKey+' AS MetaRowKey,
		'''+@V_RowKeyFields+''' AS MetaRowKeyFields,
		'+@V_RowHashExp+' AS MetaRowHash,
		''omnia'' AS MetaSourceSystemCode,
		GETDATE() AS MetaInsertDatetime,
		GETDATE() AS MetaUpdateDatetime,
		''0'' AS MetaDataQualityStatusId
		into PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP
	FROM PBBPSTG01.'+@V_StgSchema+'.'+@V_Table+' stg
'
);

-- For debug purpose
---PRINT('2' + @sql_create_temp);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step02');

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@sql_create_temp;


IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_create_temp;



---------------------------------------------------------
-- Create _TEMP table by performing join of STG(src) and ACQ(dest) table
---------------------------------------------------------
SET @sql_drop_if_exists_temp = 'IF OBJECT_ID(''PBBPSTG01.tmp.'+@V_Table+'_TEMP'') IS NOT NULL DROP TABLE PBBPSTG01.tmp.'+@V_Table+'_TEMP';

---PRINT(@newline+@sql_drop_if_exists_temp);

IF @V_Prcs_Sts = 'READY'
EXEC(@sql_drop_if_exists_temp);

-- Create Temp table by performing join of STG and ACQ table
IF @V_Prcs_Sts = 'READY'
SET @sql_create_temp =
(
'
SELECT
	*
	into PBBPSTG01.tmp.'+@V_Table+'_TEMP
FROM (
		-- Fetch Records to be deleted
		SELECT 
			'+@V_Columns_list_dest+',
			acq.MetaRowKey,
			acq.MetaRowKeyFields,
			acq.MetaRowHash,
			acq.MetaSourceSystemCode,
			acq.MetaInsertDatetime,
			acq.MetaUpdateDatetime,
			''D'' as MetaOperationCode,
			acq.MetaDataQualityStatusId,
			acq.MetaEffectiveStartDatetime,
			acq.MetaEffectiveEndDatetime,
			acq.MetaCurrentRecordIndicator
		FROM PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP stg
		RIGHT JOIN PBBPACQ01.'+@AcqSchema+'.'+@V_Table+' acq
			ON stg.MetaRowKey = acq.MetaRowKey
		WHERE stg.MetaRowKey IS NULL
			AND stg.MetaRowHash IS NULL
			AND acq.MetaCurrentRecordIndicator = ''Y''
		-- Fetch Records to be Updated
		UNION ALL
		SELECT
			'+@V_Columns_list_dest+',
			acq.MetaRowKey,
			acq.MetaRowKeyFields,
			acq.MetaRowHash,
			acq.MetaSourceSystemCode,
			acq.MetaInsertDatetime,
			stg.MetaUpdateDatetime,
			''U'' as MetaOperationCode,
			stg.MetaDataQualityStatusId,
			acq.MetaEffectiveStartDatetime,
			acq.MetaEffectiveEndDatetime,
			acq.MetaCurrentRecordIndicator
		FROM PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP stg
		JOIN PBBPACQ01.'+@AcqSchema+'.'+@V_Table+' acq
			ON stg.MetaRowKey = acq.MetaRowKey
			AND stg.MetaRowHash <> acq.MetaRowHash
			AND acq.MetaCurrentRecordIndicator = ''Y''
		-- Fetch Records to be Inserted
		UNION ALL
		SELECT
			'+@V_Columns_list_src+',
			stg.MetaRowKey,
			stg.MetaRowKeyFields,
			stg.MetaRowHash,
			stg.MetaSourceSystemCode,
			stg.MetaInsertDatetime,
			stg.MetaUpdateDatetime,
			''I'' as MetaOperationCode,
			stg.MetaDataQualityStatusId,
			CAST(''1900-01-01 00:00:00'' AS datetime) as MetaEffectiveStartDatetime,
			CAST(''9999-12-31 00:00:00'' AS datetime) as MetaEffectiveEndDatetime,
			''Y'' as MetaCurrentRecordIndicator
		FROM PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP stg
		LEFT JOIN PBBPACQ01.'+@AcqSchema+'.'+@V_Table+' acq
			ON stg.MetaRowKey = acq.MetaRowKey
		WHERE acq.MetaRowKey IS NULL
	) tmp;'
);

-- For debug purpose
---PRINT(@newline+@sql_create_temp);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step03');

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@sql_create_temp;

IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_create_temp;

---------------------------------------------------------
-- Update _TEMP table for matching MetaRowkey records
---------------------------------------------------------
IF @V_Prcs_Sts = 'READY'
SET @sql_update_temp =
(
'MERGE PBBPSTG01.tmp.'+@V_Table+'_TEMP AS tmp
using PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP stg
ON tmp.MetaRowKey = stg.MetaRowKey
AND tmp.MetaOperationCode = ''U''

WHEN MATCHED THEN 
	UPDATE 
	SET
		tmp.MetaUpdateDatetime = stg.MetaUpdateDatetime,
		tmp.MetaDataQualityStatusId = stg.MetaDataQualityStatusId,
		tmp.MetaEffectiveEndDatetime = DATEADD(ss,-1,stg.MetaUpdateDatetime),
		tmp.MetaCurrentRecordIndicator = ''N''
;'
);

-- For debug purpose
---PRINT(@newline+@sql_update_temp);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step04');

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@sql_update_temp;

IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_update_temp;

---------------------------------------------------------
-- Update _TEMP table for soft Deleted records
---------------------------------------------------------
IF @V_Prcs_Sts = 'READY'
SET @sql_update_temp =
(
'UPDATE PBBPSTG01.tmp.'+@V_Table+'_TEMP
	SET
		MetaUpdateDatetime = CAST(GETDATE() AS datetime),
		MetaEffectiveEndDatetime = DATEADD(ss,-1,CAST(GETDATE() AS datetime)),
		MetaCurrentRecordIndicator = ''N''
WHERE MetaOperationCode = ''D''
;'
);

-- For debug purpose
---PRINT(@newline+@sql_update_temp);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step05');

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@sql_update_temp;

IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_update_temp;

---------------------------------------------------------
-- Insert records with MetaOperationCode = 'U' from STG to _TEMP table
---------------------------------------------------------

-- Insert new entry for updated records
IF @V_Prcs_Sts = 'READY'
SET @sql_insert_temp = 
(
'INSERT INTO PBBPSTG01.tmp.'+@V_Table+'_TEMP
SELECT
	'+@V_Columns_list_src+',
	stg.MetaRowKey,
	stg.MetaRowKeyFields,
	stg.MetaRowHash,
	stg.MetaSourceSystemCode,
	stg.MetaInsertDatetime,
	stg.MetaUpdateDatetime,
	''I'' as MetaOperationCode,
	stg.MetaDataQualityStatusId,
	stg.MetaUpdateDatetime as MetaEffectiveStartDatetime,
	CAST(''9999-12-31 00:00:00'' as datetime) as MetaEffectiveEndDatetime,
	''Y'' as MetaCurrentRecordIndicator
FROM PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP stg
JOIN PBBPSTG01.tmp.'+@V_Table+'_TEMP tmp
	ON stg.MetaRowKey = tmp.MetaRowKey
	AND stg.MetaRowHash <> tmp.MetaRowHash
	AND tmp.MetaOperationCode = ''U''
;'
);


-- For debug purpose
---print(@newline+@sql_insert_temp);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step06');

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@sql_insert_temp;

IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_insert_temp;

---------------------------------------------------------
-- Reassign variable values for source-target merge statement in next step
---------------------------------------------------------

	IF @V_Prcs_Sts = 'READY'
	SELECT  @AcqSchema 	= ACQSchema,
			@V_Columns_list = COALESCE(ExecutionExp,ColumnList)
	FROM PBBPSTG01.info.SourceTable
	WHERE ExecutionGroup = @V_ExecutionGroup
			AND TableName = @V_Table;
		
	
	SET @V_Columns_list_src = replace(@V_Columns_list,'[',CONCAT('Source','.['));
	SET @V_Columns_list_dest = replace(@V_Columns_list,'[',CONCAT('Target','.['));
		
---------------------------------------------------------
-- Merge _TEMP(Source) table with ACQ(Target) table
---------------------------------------------------------

IF @V_Prcs_Sts = 'READY'
SET @sql_Merge_stmt =
(
'MERGE PBBPACQ01.'+@AcqSchema+'.'+@V_Table+' AS Target
USING PBBPSTG01.tmp.'+@V_Table+'_TEMP AS Source
ON Source.MetaRowKey = Target.MetaRowKey
AND Source.MetaRowHash = Target.MetaRowHash
AND Target.MetaCurrentRecordIndicator = ''Y''

-- For Deletes & Updates
WHEN MATCHED THEN 
	UPDATE 
	SET
			Target.MetaUpdateDatetime = Source.MetaUpdateDatetime,
			Target.MetaOperationCode = Source.MetaOperationCode,
			Target.MetaDataQualityStatusId = Source.MetaDataQualityStatusId,
			Target.MetaEffectiveStartDatetime = Source.MetaEffectiveStartDatetime,
			Target.MetaEffectiveEndDatetime = Source.MetaEffectiveEndDatetime,
			Target.MetaCurrentRecordIndicator = Source.MetaCurrentRecordIndicator
			
-- For Inserts
WHEN NOT MATCHED BY Target THEN
INSERT 
		(
			'+@V_Columns_list+',
			MetaRowKey,
			MetaRowKeyFields,
			MetaRowHash,
			MetaSourceSystemCode,
			MetaInsertDatetime,
			MetaUpdateDatetime,
			MetaOperationCode,
			MetaDataQualityStatusId,
			MetaEffectiveStartDatetime,
			MetaEffectiveEndDatetime,
			MetaCurrentRecordIndicator			
		)
VALUES 
		(
			'+@V_Columns_list_src+',
			Source.MetaRowKey,
			Source.MetaRowKeyFields,
			Source.MetaRowHash,
			Source.MetaSourceSystemCode,
			Source.MetaInsertDatetime,
			Source.MetaUpdateDatetime,
			Source.MetaOperationCode,
			Source.MetaDataQualityStatusId,
			Source.MetaEffectiveStartDatetime,
			Source.MetaEffectiveEndDatetime,
			Source.MetaCurrentRecordIndicator
		)
	;'
);

-- For debug purpose
---print(@newline+@sql_Merge_stmt);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step07');

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@sql_Merge_stmt;

IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_Merge_stmt;

---------------------------------------------------------
-- Clean up
---------------------------------------------------------	  
	  
SET @sql_drop_if_exists_temp = 'IF OBJECT_ID(''PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP'') IS NOT NULL DROP TABLE PBBPSTG01.tmp.'+@V_Table+'_STG_TEMP';

IF @V_Prcs_Sts = 'READY'
EXEC(@sql_drop_if_exists_temp);


SET @sql_drop_if_exists_temp = 'IF OBJECT_ID(''PBBPSTG01.tmp.'+@V_Table+'_TEMP'') IS NOT NULL DROP TABLE PBBPSTG01.tmp.'+@V_Table+'_TEMP';

IF @V_Prcs_Sts = 'READY'
EXEC(@sql_drop_if_exists_temp);

---------------------------------------------------------
-- Stop Logging
---------------------------------------------------------
	  
 
	END TRY 

	-- ERROR HANDLING
    BEGIN CATCH
 
        SET @ExecutionMsg = 'FAILURE: '
		                              + ' || Error Number : '  + CAST(ERROR_NUMBER() AS VARCHAR(MAX))
                                      + ' , Error Severity : ' + CAST(ERROR_SEVERITY() AS VARCHAR(MAX))
                                      + ' , Error State : '    + CAST(ERROR_STATE() AS VARCHAR(MAX))
                                      + ' , Error Line : '     + CAST(ERROR_LINE() AS VARCHAR(MAX))
                                      + ' , Error Message : '  + ERROR_MESSAGE() + '.'
        EXECUTE @RC = info.ExecutionLogError
           @LogID
		  ,@V_StgSchema
		  ,@V_Table
          ,@ExecutionMsg 
        RETURN;
    END CATCH

	IF @V_Prcs_Sts = 'RUNNING'
	SET @ExecutionMsg = 'Successful Execution (' + @Version + ')'
	EXECUTE @RC = info.ExecutionLogStop
	   @LogID
	  ,@V_StgSchema
	  ,@V_Table
	  ,@ExecutionMsg;

  END
END

GO
