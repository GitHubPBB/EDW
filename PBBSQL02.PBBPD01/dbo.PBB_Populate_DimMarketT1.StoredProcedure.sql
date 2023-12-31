USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_DimMarketT1]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

-- =============================================
-- Author:		Todd Boyer
-- Create date: 2023-10-11
-- Description:	Load DimMarketT1
-- Version:     1.0	Initial Version
--
-- =============================================

CREATE PROCEDURE [dbo].[PBB_Populate_DimMarketT1]
AS


BEGIN

DECLARE @MaxKey smallint=0;
DECLARE @RunDatetime datetime = getdate();


SELECT @MaxKey = coalesce(max(DimMarketKey),0) FROM [PBBPDW01].dbo.DimMarketT1  ;
 

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
			FROM omnia_epbb_p_pbb_dw.dbo.DimAccountCategory_pbb
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
			FROM omnia_epbb_p_pbb_dw.dbo.DimExternalMarket_pbb
			WHERE coalesce(trim(pbb_ExternalMarketAccountGroupMarket),'') NOT LIKE '' 
          ) x
	  WHERE ReportingMarket NOT IN ( SELECT ReportingMarketName FROM [PBBPDW01].dbo.DimMarket )
      GROUP BY AccountMarket, ReportingMarket, MarketSummary, Cast(SortKey as smallint)   
) 
select * into #TempSourceMarkets from SourceMarkets order by Row_num;


INSERT INTO [PBBPDW01].dbo.DimMarketT1
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
			FROM [PBBPDW01].dbo.DimAccountCategory_pbb
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
  UPDATE [PBBPDW01].dbo.DimMarket 
     SET MetaUpdateDatetime = @RunDatetime
	   , MetaOperationCode = 'D'
    FROM [PBBPDW01].dbo.DimMarketT1 dm
    LEFT JOIN SourceMarkets       sm on dm.ReportingMarketName = sm.ReportingMarket
   WHERE sm.AccountMarket IS NULL 
;
   

END
GO
