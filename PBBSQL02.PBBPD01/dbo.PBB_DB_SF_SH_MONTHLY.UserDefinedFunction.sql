USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_SF_SH_MONTHLY]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[PBB_DB_SF_SH_MONTHLY](
			@ReportDate date)
RETURNS TABLE 
AS
RETURN 
(

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
	AS (Select OrderReviewDate as pbb_SalesOrderReviewDate
			,Count(Distinct SalesOrderId) AS 'Install_Change'
			,pbb_AccountMarket
			,D.pbb_MarketSummary As 'VATN'
	    From PBB_DB_SMART_HOME_MONTHLY_DETAILED(@ReportDate) D
		    FULL Outer Join COL_NAMES on D.pbb_AccountMarket = COL_NAMES.AccountMarket
	    Where SalesOrderLineItemActivity In('Install','Reconnect')
	    Group By pbb_AccountMarket
			  ,D.pbb_MarketSummary
			  ,OrderReviewDate
	    Union all

	    --External Markets
	    Select FactExternalDailyStatistics_pbb.pbb_DimDateId AS pbb_SalesOrderReviewDate
			,pbb_DailyStatisticsSmarthome AS 'Install_Change'
			,DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket As 'pbb_AccountMarket'
			,'' As 'VATN'
	    From FactExternalDailyStatistics_pbb
		    join DimExternalMarket_pbb on FactExternalDailyStatistics_pbb.pbb_DimExternalMarketId = DimExternalMarket_pbb.pbb_DimExternalMarketId
		    FULL Outer Join COL_NAMES on DimExternalMarket_pbb.pbb_ExternalMarketName = COL_NAMES.AccountMarket
	    Where FactExternalDailyStatistics_pbb.pbb_DimDateId < @ReportDate
			And Year(FactExternalDailyStatistics_pbb.pbb_DimDateId) = Year(case
																  when datepart(weekday,@ReportDate) = 2
																  then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
															   end)
			And Month(FactExternalDailyStatistics_pbb.pbb_DimDateId) = Month(case
																    when datepart(weekday,@ReportDate) = 2
																    then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
																end))
	SELECT Data.pbb_SalesOrderReviewDate
		 ,COL_Names.AccountMarket
		 ,COL_Names.pbb_MarketSummary
		 ,COL_NAMES.SortOrder
		 ,Data.Install_Change
	FROM COL_Names
		Full Outer Join Data on COL_Names.AccountMarket = data.pbb_AccountMarket
	Where COL_Names.AccountMarket is not null


)
GO
