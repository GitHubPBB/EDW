USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_CALLSTATS_DAILY]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PBB_DB_CALLSTATS_DAILY]
(@ReportDate DATE
)
RETURNS @callstatsdaily TABLE
(pbb_DimDateID                        DATE, 
 [Account Group]                      NVARCHAR(400), 
 pbb_ExternalMarketAccountGroupMarket NVARCHAR(400), 
 MarketSumamry                        NVARCHAR(400), 
 SortOrder                            NVARCHAR(20), 
 Calls                                INT, 
 Aband                                INT, 
 [Ab Rate]                            DECIMAL(18, 3), 
 [Avg HT (s)]                         DECIMAL(18, 3), 
 [Md HT (s)]                          DECIMAL(18, 3), 
 [CallsAnsw]                          INT
)
AS
     BEGIN
         INSERT INTO @callstatsdaily
		-- declare @ReportDate date = getdate()
                SELECT pbb_DimDateId,[account group], pbb_ExternalMarketAccountGroupMarket, Data.MarketSummary, COL_NAMES.SortOrder, calls, aband, [ab rate],  [Avg HT (s)], [Md HT (s)], [CallsAnsw]  
                FROM
                (
                    SELECT pbb_MarketSummary AS MarketSummary, 
                           SUBSTRING(pbb_AccountMarket, 4, 255) AS AccountMarket, 
                           SUBSTRING(pbb_AccountMarket, 1, 2) AS SortOrder
                    FROM DimAccountCategory_pbb
                    WHERE pbb_AccountMarket NOT LIKE ''
                    UNION
                    SELECT pbb_ExternalMarketAccountGroupMarketSummary, 
                           pbb_ExternalMarketAccountGroupMarket AS AccountMarket, 
                           pbb_ExternalMarketSort AS SortOrder
                    FROM DimExternalMarket_pbb
                    WHERE pbb_ExternalMarketAccountGroupMarket NOT LIKE ''
                ) COL_NAMES
                FULL OUTER JOIN
                (
                    SELECT FactExternalDailyCallStatistics_pbb.pbb_DimDateId, 
                           DimExternalMarket_pbb.pbb_ExternalMarketName AS 'Account Group', 
                           DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket, 
                           DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarketSummary AS MarketSummary, 
                           FactExternalDailyCallStatistics_pbb.pbb_DailyStatisticsCalls AS 'Calls', 
                           FactExternalDailyCallStatistics_pbb.pbb_DailyStatisticsAbandonedCalls AS 'Aband', 
                           FactExternalDailyCallStatistics_pbb.pbb_DailyStatisticsAbanRate AS 'Ab Rate', 
                           FactExternalDailyCallStatistics_pbb.pbb_DailyStatisticsAvgHTs AS 'Avg HT (s)', 
                           FactExternalDailyCallStatistics_pbb.pbb_DailyStatisticsMdHTs AS 'Md HT (s)', 
                           FactExternalDailyCallStatistics_pbb.pbb_DailyStatisticsCalls - FactExternalDailyCallStatistics_pbb.pbb_DailyStatisticsAbandonedCalls AS 'CallsAnsw'
                    FROM FactExternalDailyCallStatistics_pbb
                         LEFT JOIN DimExternalMarket_pbb ON FactExternalDailyCallStatistics_pbb.pbb_DimExternalMarketId = DimExternalMarket_pbb.pbb_DimExternalMarketId
                    WHERE DimExternalMarket_pbb.pbb_ExternalMarketCallStats = 'Yes'
                          AND ((CONVERT(DATE, FactExternalDailyCallStatistics_pbb.pbb_DimDateId) = CONVERT(DATE,
                                                                                                           CASE
                                                                                                               WHEN DATEPART(weekday, @ReportDate) = 2
                                                                                                               THEN DATEADD(day, -3, @ReportDate)
                                                                                                               ELSE DATEADD(day, -1, @ReportDate)
                                                                                                           END))
                               OR CONVERT(DATE, FactExternalDailyCallStatistics_pbb.pbb_DimDateId) = CONVERT(DATE,
                                                                                                             CASE
                                                                                                                 WHEN DATEPART(weekday, @ReportDate) = 2
                                                                                                                 THEN DATEADD(day, -2, @ReportDate)
                                                                                                                 ELSE DATEADD(day, -1, @ReportDate)
                                                                                                             END)
                               OR CONVERT(DATE, FactExternalDailyCallStatistics_pbb.pbb_DimDateId) = CONVERT(DATE,
                                                                                                             CASE
                                                                                                                 WHEN DATEPART(weekday, @ReportDate) = 2
                                                                                                                 THEN DATEADD(day, -1, @ReportDate)
                                                                                                                 ELSE DATEADD(day, -1, @ReportDate)
                                                                                                             END))
                ) Data ON COL_NAMES.AccountMarket = Data.[Account Group]
                WHERE Data.[Account Group] IS NOT NULL
                ORDER BY COL_NAMES.SortOrder;
         RETURN;
     END;
GO
