USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [info].[MergeSourceToTarget]    Script Date: 12/5/2023 4:43:07 PM ******/
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
CREATE PROCEDURE [info].[MergeSourceToTarget]
     @V_ExecutionGroup 	VARCHAR(25),
     @V_TargetSchema  	VARCHAR(50),
	 @V_Table      		VARCHAR(100) = NULL,
	 @V_LoadType		VARCHAR(100),
	 @LogParentID  		INT
	 -- @RESULT       VARCHAR(1000) OUTPUT
AS

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	--SET XACT_ABORT ON;
BEGIN 

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
	DECLARE @V_Prcs_Sts               varchar(20)
	DECLARE @newline 				  nvarchar(2) 				= NCHAR(13) + NCHAR(10)


	IF (@V_Table IS NULL)
	BEGIN
	----------------------------------------------------------------
	-- Dump Control table data into temp table and use temp table in cursor to avoid locking
	----------------------------------------------------------------
		IF OBJECT_ID('tmp.ExecutionControlDetail_TEMP') IS NOT NULL DROP TABLE tmp.ExecutionControlDetail_TEMP;

		SELECT 
			*
			INTO tmp.ExecutionControlDetail_TEMP
		FROM 
			PBBPDW01.info.ExecutionControlDetail
		WHERE 
			ExecutionReadyFlag = 1  
			AND ExecutionStatus = 'READY'
			AND ExecutionGroup = @V_ExecutionGroup
			AND LoadType = @V_LoadType
			AND TargetSchemaName = @V_TargetSchema
		
		
			DECLARE DB_CURSOR CURSOR LOCAL FOR
			SELECT 
				SourceTableName,ExecutionExp
			FROM 
				tmp.ExecutionControlDetail_TEMP
			WHERE 
				ExecutionReadyFlag = 1  
				AND ExecutionStatus = 'READY'
				AND ExecutionGroup = @V_ExecutionGroup
				AND LoadType = @V_LoadType
				AND TargetSchemaName = @V_TargetSchema
				

			OPEN DB_CURSOR 
			FETCH NEXT FROM DB_CURSOR INTO @V_Table,@V_ExecutionExp

			WHILE @@FETCH_STATUS = 0
				BEGIN
					
					SELECT @LogParentID = COALESCE(MAX(LogParentID)+1,100000) FROM PBBSQL02.PBBPDW01.info.ExecutionLog 
					
					IF (@V_LoadType = 'SCDT1')
					EXECUTE @RC = info.MergeSourceToTargetSCDT1
					@V_ExecutionGroup
					,@V_TargetSchema
					,@V_Table
					,@LogParentID;
					
					IF (@V_LoadType = 'SCDT2')
					EXECUTE @RC = info.MergeSourceToTargetSCDT2
					@V_ExecutionGroup
					,@V_TargetSchema
					,@V_Table
					,@LogParentID;
					
					IF (@V_LoadType = 'SQL')
					EXEC(@V_ExecutionExp);
					
					FETCH NEXT FROM DB_CURSOR INTO @V_Table,@V_ExecutionExp
					
				END
	
		END
	ELSE
		BEGIN
			
			SELECT @LogParentID = COALESCE(MAX(LogParentID)+1,100000) FROM PBBSQL02.PBBPDW01.info.ExecutionLog 
			
			IF (@V_LoadType = 'SCDT1')
			EXECUTE @RC = info.MergeSourceToTargetSCDT1
			@V_ExecutionGroup
			,@V_TargetSchema
			,@V_Table
			,@LogParentID;
			
			IF (@V_LoadType = 'SCDT2')
			EXECUTE @RC = info.MergeSourceToTargetSCDT2
			@V_ExecutionGroup
			,@V_TargetSchema
			,@V_Table
			,@LogParentID;
					
			IF (@V_LoadType = 'SQL')
			BEGIN
				SELECT 
					@V_ExecutionExp = ExecutionExp
				FROM 
					PBBPDW01.info.ExecutionControlDetail
				WHERE 
					ExecutionReadyFlag = 1  
					AND ExecutionStatus = 'READY'
					AND ExecutionGroup = @V_ExecutionGroup
					AND LoadType = @V_LoadType
					AND SourceTableName = @V_Table
				
				EXEC(@V_ExecutionExp);
			END
		END

END
GO
