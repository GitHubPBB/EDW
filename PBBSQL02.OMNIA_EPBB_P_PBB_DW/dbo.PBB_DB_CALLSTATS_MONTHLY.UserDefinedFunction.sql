USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_CALLSTATS_MONTHLY]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PBB_DB_CALLSTATS_MONTHLY](
			@ReportDate date)
RETURNS TABLE
AS
	RETURN(
	WITH COL_NAMES
		AS (SELECT pbb_MarketSummary AS MarketSummary
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
		AS (Select FactExternalDailyCallStatistics_pbb.pbb_DimDateId
				,DimExternalMarket_pbb.pbb_ExternalMarketName AS 'Account Group'
				,DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket
				,DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarketSummary As MarketSummary
				,COL_NAMES.SortOrder
				,FactExternalDailyCallStatistics_pbb.pbb_DailyStatisticsCalls As 'Calls'
				,FactExternalDailyCallStatistics_pbb.pbb_DailyStatisticsAbandonedCalls As 'Aband'
				,FactExternalDailyCallStatistics_pbb.pbb_DailyStatisticsAbanRate As 'Ab Rate'
				,FactExternalDailyCallStatistics_pbb.pbb_DailyStatisticsAvgHTs As 'Avg HT (s)'
				,FactExternalDailyCallStatistics_pbb.pbb_DailyStatisticsMdHTs As 'Md HT (s)'
				,FactExternalDailyCallStatistics_pbb.pbb_DailyStatisticsCalls - FactExternalDailyCallStatistics_pbb.pbb_DailyStatisticsAbandonedCalls As 'CallsAnsw'
		    FROM FactExternalDailyCallStatistics_pbb
			    LEFT JOIN DimExternalMarket_pbb ON FactExternalDailyCallStatistics_pbb.pbb_DimExternalMarketId = DimExternalMarket_pbb.pbb_DimExternalMarketId
			    FULL OUTER JOIN COL_NAMES ON COL_NAMES.AccountMarket = DimExternalMarket_pbb.pbb_ExternalMarketName
		    Where DimExternalMarket_pbb.pbb_ExternalMarketCallStats = 'Yes'
				And FactExternalDailyCallStatistics_pbb.pbb_DimDateId < @ReportDate
				And Year(FactExternalDailyCallStatistics_pbb.pbb_DimDateId) = Year(dateadd(day,-1,@ReportDate))
				And Month(FactExternalDailyCallStatistics_pbb.pbb_DimDateId) = Month(dateadd(day,-1,@ReportDate)))
		Select Data.*
		From COL_NAMES
			FULL OUTER JOIN Data ON COL_NAMES.AccountMarket = Data.[Account Group]
		Where Data.[Account Group] Is Not NULL
		--ORDER BY COL_NAMES.SortOrder
		)
GO
