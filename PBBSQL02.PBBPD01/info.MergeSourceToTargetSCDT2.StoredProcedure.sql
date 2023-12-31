USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [info].[MergeSourceToTargetSCDT2]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================  
-- Description:	Merge Stage table with an Acq table
--  
-- Change histrory: 
-- Name			Auther			Date		Version		Description 
-- Comment      Sunil           06/22/2023  01.00       Initial version
-- =============================================
CREATE PROCEDURE [info].[MergeSourceToTargetSCDT2]
     @V_ExecutionGroup 	VARCHAR(25),
     @V_TargetSchema  	VARCHAR(50),
	 @V_Table      		VARCHAR(100) = NULL,
	 @LogParentID  		INT
	 -- @RESULT         VARCHAR(1000) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- VARIABLES
	DECLARE @Version				  VARCHAR(10) = 'v1.00';
	DECLARE @ProcessDate			  DATE;
	DECLARE @RC						  int
	DECLARE @EtlName				  varchar(50)        
	DECLARE @V_LoadDttm				  varchar(40)             = GETDATE()
	DECLARE @ProcGUID				  varchar(50)
	DECLARE @ExecutionGUID			  varchar(50)
	DECLARE @MachineName			  varchar(50)             = HOST_NAME()
	DECLARE @UserName				  varchar(50)             = SUSER_NAME()
	DECLARE @ExecutionStep			  varchar(1000)
	DECLARE @ExecutionMsg			  varchar(MAX)          
	DECLARE @LogID					  numeric(18,0)           = @LogParentID 
	DECLARE @V_SourceSchema			  varchar(50)
	DECLARE @V_SourceSystem			  nvarchar(300)
	DECLARE @V_SourceDatabaseName	  nvarchar(300)
	DECLARE @V_TargetDatabaseName	  nvarchar(300)
	DECLARE @V_ExecutionExp			  nvarchar(MAX)
	DECLARE @V_Columns_list 		  nvarchar(MAX)
	DECLARE @V_Columns_list_dest	  nvarchar(MAX)
	DECLARE @V_Columns_list_src		  nvarchar(MAX)
	DECLARE @sql_drop_if_exists_temp  nvarchar(MAX)
	DECLARE @sql_create_temp 		  nvarchar(MAX)
	DECLARE @sql_update_stmt 		  nvarchar(MAX)
	DECLARE @sql_insert_stmt 		  nvarchar(MAX)
	DECLARE @V_Prcs_Sts               varchar(20)
	DECLARE @V_LastLoadDttm			  datetime
	DECLARE @V_RowHashExp			  nvarchar(MAX)
	DECLARE @V_RowKeyFields			  nvarchar(MAX)
	DECLARE @V_RowKey				  nvarchar(MAX)
	DECLARE @V_CurrentTimestamp		  datetime					= GETDATE()
	DECLARE @V_temp_schema			  varchar(100)				= 'tmp'
	DECLARE @newline 				  nvarchar(2) 				= NCHAR(13) + NCHAR(10)


BEGIN TRY
	SELECT  @V_SourceSchema 	= SourceSchemaName,
			@V_TargetSchema 	= TargetSchemaName,
			@V_SourceDatabaseName 	= SourceDatabaseName,
			@V_TargetDatabaseName 	= TargetDatabaseName,
			@V_SourceSystem 	= SourceDatabaseName,
			@V_Prcs_Sts 		= ExecutionStatus,
			@V_LoadDttm 		= @V_CurrentTimestamp,
			@V_LastLoadDttm	    = LastLoadDttm,
			@V_Columns_list 	= ColumnList,
			@V_RowKeyFields 	= MetaRowKeyFields,
			@V_RowHashExp		= ColumnRowHashExp,
			@V_ExecutionExp 	= ExecutionExp
	FROM PBBPDW01.info.ExecutionControlDetail
	WHERE ExecutionGroup = @V_ExecutionGroup
			AND SourceTableName = @V_Table
			AND LoadType = 'SCDT2';
	
	SET @V_Columns_list_src = CONCAT('Source.',replace(@V_Columns_list,',',', Source.'));
	SET @V_Columns_list_dest = CONCAT('Target.',replace(@V_Columns_list,',',', Target.'));
	SET @V_RowKey = replace(@V_RowKeyFields,',','||');
	
	SET @EtlName = concat(@V_TargetSchema, '.', @V_Table);
	
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
	  ,@V_TargetSchema
	  ,@V_Table
	  ,@V_LoadDttm
	  ,@ProcGUID 
	  ,@ExecutionGUID 
	  ,@MachineName 
	  ,@UserName 
	  ,'SCDT2'
	  ,@ExecutionMsg 
	  ,@LogID OUTPUT;
	  
-- For Debug purpose - Print value of all the variables
---PRINT CONCAT_WS(@newline,@V_ExecutionGroup,@V_TargetSchema,@V_Table,@V_LoadDttm,@V_Columns_list_dest,@V_Columns_list_src,@LogID,@V_Prcs_Sts,@V_RowKey);


SET @ExecutionMsg = CONCAT_WS(@newline,@V_ExecutionGroup,@V_TargetSchema,@V_Table,@V_LoadDttm,@V_Columns_list_dest,@V_Columns_list,@V_Columns_list_src,@LogID,@V_Prcs_Sts,@V_RowKey,@V_SourceDatabaseName,@V_SourceSystem)

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
SET @sql_drop_if_exists_temp = 'IF OBJECT_ID('''+@V_temp_schema+'.'+@V_Table+'_STG_T2_TEMP'') IS NOT NULL DROP TABLE '+@V_temp_schema+'.'+@V_Table+'_STG_T2_TEMP';

-- For Debug purpose
---PRINT('1' + @sql_drop_if_exists_temp);

IF @V_Prcs_Sts = 'READY'
EXEC(@sql_drop_if_exists_temp);


IF @V_Prcs_Sts = 'READY'
SET @sql_create_temp = 
(
' SELECT
		'+@V_Columns_list_src+'
		into '+@V_temp_schema+'.'+@V_Table+'_STG_T2_TEMP
	FROM '+@V_SourceDatabaseName+'.'+@V_SourceSchema+'.'+@V_Table+' Source
	WHERE Source.MetaUpdateDatetime > CAST('''+CONVERT(VARCHAR(30), @V_LastLoadDttm, 121)+''' AS DATETIME)'
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
-- Meta Operation Code - D(Delete)
---------------------------------------------------------
-- Insert new records both with changed MetaRowHash and new MetaRowHash & MetaRowKey
IF @V_Prcs_Sts = 'READY'
SET @sql_update_stmt =
(
'UPDATE '+@V_TargetDatabaseName+'.'+@V_TargetSchema+'.'+@V_Table+'
	SET
		MetaUpdateDatetime = Source.MetaUpdateDatetime,
		MetaOperationCode = Source.MetaOperationCode,
		MetaDataQualityStatusId = Source.MetaDataQualityStatusId,
		MetaEffectiveEndDatetime = DATEADD(ss,-1,Source.MetaUpdateDatetime),
		MetaCurrentRecordIndicator = ''0''
	FROM '+@V_TargetDatabaseName+'.'+@V_TargetSchema+'.'+@V_Table+' Target
		JOIN '+@V_temp_schema+'.'+@V_Table+'_STG_T2_TEMP Source
			ON Source.MetaRowKey = Target.MetaRowKey
			AND Source.MetaRowHash = Target.MetaRowHash
	WHERE Target.MetaOperationCode IN (''U'',''I'')
		AND Target.MetaCurrentRecordIndicator = ''1''
		AND Source.MetaOperationCode = ''D''
;'
);

-- For debug purpose
---print(@newline+@sql_update_stmt);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step03');

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@sql_update_stmt;

IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_update_stmt;
	
		
---------------------------------------------------------
-- Meta Operation Code - U(Update), mark old record as 'N' and insert new updated records
---------------------------------------------------------

IF @V_Prcs_Sts = 'READY'
SET @sql_update_stmt =
(
'UPDATE '+@V_TargetDatabaseName+'.'+@V_TargetSchema+'.'+@V_Table+'
	SET
		MetaUpdateDatetime = Source.MetaUpdateDatetime,
		MetaOperationCode = Source.MetaOperationCode,
		MetaDataQualityStatusId = Source.MetaDataQualityStatusId,
		MetaEffectiveEndDatetime = DATEADD(ss,-1,Source.MetaUpdateDatetime),
		MetaCurrentRecordIndicator = ''0''
	FROM '+@V_TargetDatabaseName+'.'+@V_TargetSchema+'.'+@V_Table+' Target
		JOIN '+@V_temp_schema+'.'+@V_Table+'_STG_T2_TEMP Source
			ON Source.MetaRowKey = Target.MetaRowKey
			AND Source.MetaRowHash <> Target.MetaRowHash
	WHERE Target.MetaOperationCode IN (''U'',''I'')
		AND Target.MetaCurrentRecordIndicator = ''1''
		AND Source.MetaOperationCode = ''U''
;'
);

-- For debug purpose
---print(@newline+@sql_update_stmt);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step04');

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@sql_update_stmt;

IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_update_stmt;

---------------------------------------------------------
-- Meta Operation Code - I(Insert)
---------------------------------------------------------
-- Insert new records both with changed MetaRowHash and new MetaRowHash & MetaRowKey
IF @V_Prcs_Sts = 'READY'
SET @sql_insert_stmt =
(
'INSERT INTO '+@V_TargetDatabaseName+'.'+@V_TargetSchema+'.'+@V_Table+'
	SELECT '+@V_Columns_list_src+',
			Source.MetaUpdateDatetime as MetaEffectiveStartDatetime,
			CAST(''9999-12-31 00:00:00'' as datetime) as MetaEffectiveEndDatetime,
			''1'' as MetaCurrentRecordIndicator
	FROM '+@V_temp_schema+'.'+@V_Table+'_STG_T2_TEMP Source
	LEFT JOIN '+@V_TargetDatabaseName+'.'+@V_TargetSchema+'.'+@V_Table+' Target
		ON Source.MetaRowKey = Target.MetaRowKey
		AND Source.MetaRowHash = Target.MetaRowHash
		AND Target.MetaOperationCode <> ''D''
	WHERE Target.MetaRowKey IS NULL
		AND Source.MetaOperationCode IN (''U'',''I'')
	;'
);

-- For debug purpose
---print(@newline+@sql_insert_stmt);
SET @ExecutionStep = concat(@EtlName,'|' , 'Step05');

EXECUTE @RC = info.ExecutionLogDetailProc
	   @LogParentID
	  ,@ExecutionStep
	  ,@sql_insert_stmt;

IF @V_Prcs_Sts = 'READY'
EXEC sp_executesql @sql_insert_stmt;
	

---------------------------------------------------------
-- Clean up
---------------------------------------------------------	  
	  
SET @sql_drop_if_exists_temp = 'IF OBJECT_ID('''+@V_temp_schema+'.'+@V_Table+'_STG_T2_TEMP'') IS NOT NULL DROP TABLE '+@V_temp_schema+'.'+@V_Table+'_STG_T2_TEMP';

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
		  ,@V_TargetSchema
		  ,@V_Table
		  ,'SCDT2'
          ,@ExecutionMsg 
        RETURN;
    END CATCH

	SET @ExecutionMsg = 'Load is completed sucessfully!';

	IF @V_Prcs_Sts = 'RUNNING'
	SET @ExecutionMsg = 'Successful Execution (' + @Version + ')'
	EXECUTE @RC = info.ExecutionLogStop
	   @LogID
	  ,@V_TargetSchema
	  ,@V_Table
	  ,@V_CurrentTimestamp
	  ,'SCDT2'
	  ,@ExecutionMsg;

  END

GO
