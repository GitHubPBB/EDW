USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_SF_TRTC_TOTAL]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[PBB_DB_SF_TRTC_TOTAL](
			@ReportDate date)
RETURNS TABLE 
AS
RETURN 
(
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
	AS (Select [Date] AS ActualEndDate
			,pbb_AccountMarket AS AccountMarket
			,d.MarketSummary
			,Count(DimCaseId) AS TroubleCalls
			,Case
				When COL_NAMES.MarketSummary = '01-Total VA/TN'
				Then Count(DimCaseId) Else 0
			 End As 'TroubleCalls_VATN'
	    From [dbo].[PBB_DB_TRUCK_ROLL_TROUBLE_CALL_MONTHLY_DETAIL](@ReportDate) D
		    FULL OUTER JOIN COL_NAMES ON pbb_AccountMarket = COL_NAMES.AccountMarket
	    Group By [Date]
			  ,COL_NAMES.AccountMarket
			  ,COL_NAMES.MarketSummary
			  ,COL_NAMES.SortOrder
			  ,pbb_AccountMarket
			  ,d.MarketSummary
	    UNION

	    -- External Markets
	    Select FactExternalDailyStatistics_pbb.pbb_DimDateId AS ActualEndDate
			,DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket As 'AccountMarket'
			,DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarketSummary As 'MarketSummary'
			,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsCompletedTRTC AS TroubleCalls
			,Case
				When DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarketSummary = '01-Total VA/TN'
				Then FactExternalDailyStatistics_pbb.pbb_DailyStatisticsCompletedTRTC Else 0
			 End As 'TroubleCalls_VATN'
	    From FactExternalDailyStatistics_pbb
		    JOIN DimExternalMarket_pbb ON FactExternalDailyStatistics_pbb.pbb_DimExternalMarketId = DimExternalMarket_pbb.pbb_DimExternalMarketId
		    FULL OUTER JOIN COL_NAMES ON SUBSTRING(DimExternalMarket_pbb.pbb_ExternalMarketName,4,255) = COL_NAMES.AccountMarket
			
			)
	Select Data.*
		 ,COL_NAMES.SortOrder
	From COL_NAMES
		FULL OUTER JOIN Data ON COL_NAMES.AccountMarket = Data.AccountMarket
	Where Data.AccountMarket Is Not NULL
		 and Data.AccountMarket <> ''
		 and ActualEndDate >= datefromparts(datepart(year,
											case
											    when datepart(weekday,@ReportDate) = 2
											    then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
											end),datepart(month,
													    case
														   when datepart(weekday,@ReportDate) = 2
														   then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
													    end),1)

)
GO
