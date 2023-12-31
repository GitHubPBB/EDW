USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[Populate_DimMarketT1]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Populate_DimMarketT1]
AS


BEGIN

DECLARE @Version				  VARCHAR(10) = 'v1.00';
	DECLARE @LogParentID              numeric(18,0)
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
	DECLARE @V_Table                  varchar(MAX)
	DECLARE @V_TargetSchema           varchar(MAX)
	DECLARE @V_ExecutionGroup         varchar(MAX)
	DECLARE @V_CurrentTimestamp		  datetime					= GETDATE()

BEGIN TRY
SELECT @LogParentID = COALESCE(MAX(LogParentID)+1,100000) FROM PBBPDW01.info.ExecutionLog
SET @V_ExecutionGroup = 'Load into T1 Table'
SET @V_TargetSchema = 'dbo'
SET @V_Table = 'DimMarketT1'
SET @ExecutionMsg = 'Starting Process'
SET @EtlName = concat(@V_TargetSchema, '.', @V_Table);	
SET @ExecutionStep = concat(@EtlName,'|' , 'Step01');

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
	  ,NULL
	  ,@ExecutionMsg 
	  ,@LogID OUTPUT;


	SET @ExecutionMsg = 'Drop and Recreate Temporary Table #TempSourceMarkets'

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;

DECLARE @MaxKey smallint=0;
DECLARE @RunDatetime datetime = getdate();


SELECT @MaxKey = coalesce(max(DimMarketKey),0) FROM dbo.DimMarketT1  ;
 

DROP TABLE if exists #TempSourceMarkets;
	
WITH 
SourceMarkets

AS (SELECT AccountMarket, ReportingMarket, MarketSummary, Cast(SortKey as smallint) AccountMarketSortKey
         , max(IsInternalMarket) IsInternalMarket, max(IsExternalMarket) IsExternalMarket
		 , row_number() over (order by Cast(SortKey as smallint) , ReportingMarket) Row_Num
      FROM (
		SELECT   pbb_MarketSummary MarketSummary
				, case when pbb_ReportingMarket like 'Baldwin%' then 'South AL' else SUBSTRING(pbb_AccountMarket,4,255) end AS AccountMarket
				, pbb_ReportingMarket ReportingMarket
				, max(SUBSTRING(pbb_AccountMarket,1,2)) AS SortKey
				, 'Y' IsInternalMarket
				, 'N' IsExternalMarket
				, 'Omnia DW' MetaSourceSystemCode 
			FROM [PBBPACQ01].[AcqPbbDW].DimAccountCategory_pbb
			WHERE pbb_AccountMarket NOT LIKE ''
			GROUP BY pbb_MarketSummary, case when pbb_ReportingMarket like 'Baldwin%' then 'South AL' else SUBSTRING(pbb_AccountMarket,4,255) end 
			       , pbb_ReportingMarket
		UNION
		SELECT   distinct
		          pbb_ExternalMarketAccountGroupMarketSummary MarketSummary
				, pbb_ExternalMarketAccountGroupMarket AS AccountMarket
				, case when pbb_ExternalMarketname ='Island'       then 'Island Fiber'
    				   when pbb_ExternalMarketname ='N AL - Fixed' then 'North AL - Fixed'
    				   when pbb_ExternalMarketname ='N AL - FTTH'  then 'North AL - FTTH'
    				   when pbb_ExternalMarketname ='Clarity NY'   then 'New York'
				       else pbb_ExternalMarketName end AS ReportingMarket
				, pbb_ExternalMarketSort AS SortKey
				, 'N' IsInternalMarket
				, 'Y' IsExternalMarket
				, 'External DW' MetaSourceSystemCode
			FROM [PBBPACQ01].[AcqPbbDW].DimExternalMarket_pbb
			WHERE coalesce(trim(pbb_ExternalMarketAccountGroupMarket),'') NOT LIKE '' 
          ) x
	  WHERE ReportingMarket NOT IN ( SELECT ReportingMarketName FROM [PBBPDW01].dbo.DimMarketT1 )
      GROUP BY AccountMarket, ReportingMarket, MarketSummary, Cast(SortKey as smallint)   
) 
select * into #TempSourceMarkets from SourceMarkets order by Row_num;


	SET @ExecutionStep = concat(@EtlName,'|' , 'Step02');
	SET @ExecutionMsg = 'Insert into DimMarketT1 table';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;

INSERT INTO dbo.DimMarketT1
SELECT @MaxKey+Row_Num     DimMarketKey
     , ReportingMarket     DimMarketNaturalKey
	 , case when IsInternalMarket ='Y' AND IsExternalMarket='Y'  THEN 'pbb_ReportingMarket|pbb_ExternalMarketName'
	        WHEN IsInternalMarket ='Y'  THEN 'pbb_ReportingMarket'
			ELSE 'pbb_ExternalMarketName'
			END MetaSourceSystemCode
     , AccountMarket       AccountMarketName
     , ReportingMarket     ReportingMarketName
	 , MarketSummary       MarketSummaryName
	 , IsInternalMarket  
	 , IsExternalMarket
	 , AccountMarketSortKey
	 , CASE WHEN IsInternalMarket ='Y' AND IsExternalMarket='Y'  THEN 'Omnia CRM|External'
	        WHEN IsInternalMarket ='Y'  THEN 'Omnia CRM'
			ELSE 'External'
			END MetaSourceSystemCode
	 , @RunDatetime MetaInsertDatetime
	 , @RunDatetime MetaUpdateDatetime
	 , 'I' MetaOperationCode
	 , 0 MetaDataQualityStatusId
  FROM #TempSourceMarkets
;
 
 -- DELETES

-- DECLARE @RunDatetime datetime=getdate();

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step03');
	SET @ExecutionMsg = 'Update DimMarket table';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;
WITH 
SourceMarkets

AS (SELECT AccountMarket, ReportingMarket, MarketSummary, Cast(SortKey as smallint) AccountMarketSortKey
         , max(IsInternalMarket) IsInternalMarket, max(IsExternalMarket) IsExternalMarket
		 , row_number() over (order by Cast(SortKey as smallint) , ReportingMarket) Row_Num
      FROM (
		SELECT distinct pbb_MarketSummary MarketSummary
				, SUBSTRING(pbb_AccountMarket,4,255) AS AccountMarket
				, pbb_ReportingMarket ReportingMarket
				, SUBSTRING(pbb_AccountMarket,1,2) AS SortKey
				, 'Y' IsInternalMarket
				, 'N' IsExternalMarket
				, 'Omnia DW' MetaSourceSystemCode 
			FROM [PBBPACQ01].[AcqPbbDW].DimAccountCategory_pbb
			WHERE pbb_AccountMarket NOT LIKE ''
		UNION
		SELECT    pbb_ExternalMarketAccountGroupMarketSummary MarketSummary
				, pbb_ExternalMarketAccountGroupMarket AS AccountMarket
				, case when pbb_ExternalMarketname ='Island'       then 'Island Fiber'
    				   when pbb_ExternalMarketname ='N AL - Fixed' then 'North AL - Fixed'
    	 			   when pbb_ExternalMarketname ='N AL - FTTH'  then 'North AL - FTTH'
    				   when pbb_ExternalMarketname ='Clarity NY'   then 'New York'
				       else pbb_ExternalMarketName end AS ReportingMarket
				, pbb_ExternalMarketSort AS SortKey
				, 'N' IsInternalMarket
				, 'Y' IsExternalMarket
				, 'External DW' MetaSourceSystemCode
			FROM [PBBPDW01].dbo.DimExternalMarket_pbb
			WHERE coalesce(trim(pbb_ExternalMarketAccountGroupMarket),'') NOT LIKE '' 
          ) x
      GROUP BY AccountMarket, ReportingMarket, MarketSummary, Cast(SortKey as smallint)   
) 
  UPDATE [PBBPDW01].dbo.DimMarketT1 
     SET MetaUpdateDatetime = @RunDatetime
	   , MetaOperationCode = 'D'
    FROM dbo.DimMarketT1 dm
    LEFT JOIN SourceMarkets       sm on dm.ReportingMarketName = sm.ReportingMarket
   WHERE sm.AccountMarket IS NULL 
;
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
		  ,NULL
          ,@ExecutionMsg 
        RETURN;
    END CATCH

	SET @ExecutionMsg = 'Data Load is completed sucessfully!';

    SET @ExecutionMsg = 'Successful Execution (' + @Version + ')'
	EXECUTE @RC = info.ExecutionLogStop
	   @LogID
	  ,@V_TargetSchema
	  ,@V_Table
	  ,@V_CurrentTimestamp
	  ,NULL
	  ,@ExecutionMsg;
 

END
GO
