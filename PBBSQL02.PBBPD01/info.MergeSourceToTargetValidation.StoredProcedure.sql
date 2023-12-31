USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [info].[MergeSourceToTargetValidation]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [info].[MergeSourceToTargetValidation]
AS
BEGIN
-----------------------------------------------
-- Declare Variables
-----------------------------------------------
	Declare 
		@sql nvarchar(max),
		@T_name varchar(200),
		@RunDate date,
		@V_RecordCount numeric(16),
		@newline nvarchar(2) = NCHAR(13) + NCHAR(10),
		@TestCase varchar(200)


	
	DECLARE @ValueTable  TABLE
		(    
		     s numeric(16)
		)
	-- ignore output message for each execution	
	SET NOCOUNT ON; 

-----------------------------------------------
-- Declare Cursor
-----------------------------------------------	
	DECLARE DQC_CURSOR CURSOR LOCAL FOR
	  SELECT  RunDate,TableName,Script, TestCase
		FROM PBBPDW01.info.DataQualityCheck
	--WHERE RunDate = (SELECT MAX(CAST(ExecutionDttm AS DATE)) FROM PBBPDW01.info.ExecutionControldetail)
			--------AND 
		--	WHERE TestCase IN( 'Count Validation','MetaRowHash  Validation','MetaRowKey  Validation','MetaSourceSystemCode Validation ')

		--WHERE --TableName = 'SrvLocationX'
		----	AND 
		--WHERE TestCase IN( 'Count Validation','MetaRowHash  Validation','MetaRowKey  Validation','MetaSourceSystemCode Validation ')
--;
-----------------------------------------------
-- Fetch first values into variables
-----------------------------------------------	
	OPEN DQC_CURSOR 
	FETCH NEXT FROM DQC_CURSOR INTO @RunDate, @T_name, @sql , @TestCase
	
	-- Start loop
	WHILE @@FETCH_STATUS = 0
	BEGIN

		-- SELECT @sql
		 --print @sql;
		INSERT INTO @ValueTable 
			EXEC sp_executesql @sql; 

		SELECT @V_RecordCount = s FROM @ValueTable

		--select * from @ValueTable
		--SELECT @T_name,@V_RecordCount;
		
	
		-- Update DataQualityCheck table to 
		UPDATE PBBPDW01.info.DataQualityCheck
			SET RecordCount = @V_RecordCount,
				IssueType = CASE 
				                WHEN @V_RecordCount <> 0 AND TestCase = 'Count Validation | Source To Target Count Mismatch|'
								THEN 'Count Mismtach'
								WHEN @V_RecordCount <> 0 AND TestCase = 'MetaRowHash  Validation|Duplicates Check|'
								THEN 'MetaRowHash Duplicates'
								WHEN @V_RecordCount <> 0 AND TestCase = 'MetaRowKey  Validation|Duplicates Check|'
								THEN 'MetaRowKey Duplicates'
								WHEN @V_RecordCount <> 0 AND TestCase = 'MetaSourceSystemCode Validation' 
								THEN 'SourceSystemCode Issues'
								WHEN @V_RecordCount <> 0 AND TestCase = 'MetaRowhash Validation|Null Check|'
								THEN 'MetaRowhash Null issues'
								WHEN @V_RecordCount <> 0 AND TestCase = 'MetaRowKey Validation|Null Check|' 
								THEN 'MetaRowKey Null issues '
							ELSE 'PASSED'
							END,
				ExecutionStatus = 'COMPLETED'
			WHERE TableName = @T_name
				AND RunDate = @RunDate
				AND  TestCase =  @TestCase
				;

		-- clean up temp ValueTable
		 DELETE FROM @ValueTable;
		 SET @V_RecordCount = 0;
-----------------------------------------------
-- Fetch next values into variables
-----------------------------------------------	
		FETCH NEXT FROM DQC_CURSOR INTO @RunDate, @T_name, @sql , @TestCase
	END
-----------------------------------------------
-- Deallocate Cursor
-----------------------------------------------

	CLOSE DQC_CURSOR
	DEALLOCATE DQC_CURSOR
 --Insert new rundate records for next execution
	--INSERT INTO PBBPDW01.info.DataQualityCheck
	--SELECT 
	--	Cycle_Number+1 as CycleNumber,
	--	Dateadd(day,1,RunDate) as RunDate,
	--	TargetSystem,
	--	TableName,
	--	TestCase,
	--	Script, 
	--	NULL,
	--	NULL,
	--	NULL
	--FROM PBBPDW01.info.DataQualityCheck
	--WHERE RunDate = @RunDate

END 
GO
