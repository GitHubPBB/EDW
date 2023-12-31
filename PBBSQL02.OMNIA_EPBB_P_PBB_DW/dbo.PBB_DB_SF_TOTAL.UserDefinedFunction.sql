USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_SF_TOTAL]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[PBB_DB_SF_TOTAL](
			@ReportDate date)
RETURNS TABLE 
AS
RETURN 
(
--Total Subsciption Count
WITH COL_NAMES
	AS (SELECT pbb_MarketSummary
			,SUBSTRING(pbb_AccountMarket,4,255) AS AccountMarket
			,SUBSTRING(pbb_AccountMarket,1,2) AS SortOrder
	    FROM DimAccountCategory_pbb
	    WHERE pbb_AccountMarket NOT LIKE ''
	    UNION
	    SELECT pbb_ExternalMarketAccountGroupMarketSummary
			,pbb_ExternalMarketAccountGroupMarket AS AccountMarket
			,pbb_ExternalMarketSort AS SortOrder
	    FROM DimExternalMarket_pbb
	    WHERE pbb_ExternalMarketAccountGroupMarket NOT LIKE ''),
	Data
	AS (Select Sum(ItemQuantity) AS 'Install_Change'
			,pbb_AccountMarket
			,pbb_MarketSummary As 'VATN'
	    From PBB_DB_SMART_HOME_TOTAL_DETAILED(@ReportDate)
		    FULL Outer Join COL_NAMES on pbb_AccountMarket = COL_NAMES.AccountMarket
	    Group By pbb_AccountMarket
			  ,pbb_MarketSummary
	    Union all

	    --External Markets
	    Select pbb_DailyStatisticsSmarthome AS 'Install_Change'
			,DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket As 'pbb_AccountMarket'
			,'' As 'VATN'
	    From FactExternalDailyStatistics_pbb
		    join DimExternalMarket_pbb on FactExternalDailyStatistics_pbb.pbb_DimExternalMarketId = DimExternalMarket_pbb.pbb_DimExternalMarketId
		    FULL Outer Join COL_NAMES on DimExternalMarket_pbb.pbb_ExternalMarketName = COL_NAMES.AccountMarket)
	SELECT COL_Names.AccountMarket
		 ,COL_Names.pbb_MarketSummary
		 ,COL_Names.SortOrder
		 ,Data.Install_Change
	FROM COL_Names
		Full Outer Join Data on COL_Names.AccountMarket = data.pbb_AccountMarket
	Where COL_Names.AccountMarket is not null

)
GO
