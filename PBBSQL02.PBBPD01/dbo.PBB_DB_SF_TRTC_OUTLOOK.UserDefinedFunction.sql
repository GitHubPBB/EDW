USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_SF_TRTC_OUTLOOK]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[PBB_DB_SF_TRTC_OUTLOOK](
			@ReportDate date)
RETURNS TABLE 
AS
RETURN 
(
WITH COL_NAMES
     AS (SELECT pbb_MarketSummary AS MarketSummary, 
                SUBSTRING(pbb_AccountMarket, 4, 255) AS AccountMarket, 
                SUBSTRING(pbb_AccountMarket, 1, 2) AS SortOrder
         FROM DimAccountCategory_pbb
         WHERE pbb_AccountMarket NOT LIKE ''
         UNION
         SELECT pbb_ExternalMarketAccountGroupMarketSummary, 
                pbb_ExternalMarketAccountGroupMarket AS AccountMarket, 
                pbb_ExternalMarketSort AS SortOrder
         FROM DimExternalMarket_pbb
         WHERE pbb_ExternalMarketAccountGroupMarket NOT LIKE ''),
     Data
     AS (SELECT [Date] AS ScheduledDate, 
                pbb_AccountMarket AS AccountMarket, 
                D.MarketSummary, 
                COUNT(DimCaseId) AS LessThan48_HRS, 
                '' AS MoreThan48_HRS,
                CASE
                    WHEN D.MarketSummary = '01-Total VA/TN'
                    THEN COUNT(DimCaseId)
                    ELSE 0
                END AS 'LessThan48_HRS_VATNCount', 
                '' AS MoreThan48_HRS_VATNCount
         FROM PBB_DB_TRUCK_ROLL_TROUBLE_CALL_OUTLOOK_DAILY_DETAIL(@ReportDate) d
              FULL OUTER JOIN COL_NAMES ON pbb_AccountMarket = COL_NAMES.AccountMarket
         WHERE 1 = 1
		 AND d.ReportData = 'LessThan'
         GROUP BY [Date], 
                  pbb_AccountMarket, 
                  D.MarketSummary, 
                  ActivityId, 
                  COL_NAMES.AccountMarket, 
                  COL_NAMES.MarketSummary, 
                  COL_NAMES.SortOrder
         UNION ALL
         SELECT [Date] AS ScheduledDate, 
                pbb_AccountMarket, 
                D.MarketSummary, 
                '' AS LessThan48_HRS, 
                COUNT(DimCaseId) AS MoreThan48_HRS, 
                '' AS LessThan48_HRS_VATNCount,
                CASE
                    WHEN D.MarketSummary = '01-Total VA/TN'
                    THEN COUNT(DimCaseId)
                    ELSE 0
                END AS 'MoreThan48_HRS_VATNCount'
         FROM PBB_DB_TRUCK_ROLL_TROUBLE_CALL_OUTLOOK_DAILY_DETAIL(@ReportDate) D
              FULL OUTER JOIN COL_NAMES ON pbb_AccountMarket = COL_NAMES.AccountMarket
         WHERE 1 = 1
		 and ReportData = 'MoreThan'
         GROUP BY [Date], 
                  pbb_AccountMarket, 
                  D.MarketSummary, 
                  ActivityId, 
                  COL_NAMES.AccountMarket, 
                  COL_NAMES.MarketSummary, 
                  COL_NAMES.SortOrder
         UNION ALL

         -- External Markets
         SELECT FactExternalDailyStatistics_pbb.pbb_DimDateId AS ScheduledDate, 
                DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket AS 'pbb_ExternalMarketName', 
                DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarketSummary, 
                FactExternalDailyStatistics_pbb.pbb_DailyStatisticsTRTCPending48Hours AS LessThan48_HRS, 
                FactExternalDailyStatistics_pbb.pbb_DailyStatisticsTRTCPendingGT48Hours AS MoreThan48_HRS,
                CASE
                    WHEN DimExternalMarket_pbb.pbb_externalMarketAccountGroupMarketSummary LIKE '%VATN%'
                    THEN FactExternalDailyStatistics_pbb.pbb_DailyStatisticsTRTCPending48Hours
                    ELSE 0
                END AS 'LessThan48_HRS_VATNCount',
                CASE
                    WHEN DimExternalMarket_pbb.pbb_externalMarketAccountGroupMarketSummary LIKE '%VATN%'
                    THEN FactExternalDailyStatistics_pbb.pbb_DailyStatisticsTRTCPendingGT48Hours
                    ELSE 0
                END AS 'MoreThan48_HRS_VATNCount'
         FROM FactExternalDailyStatistics_pbb
              JOIN DimExternalMarket_pbb ON FactExternalDailyStatistics_pbb.pbb_DimExternalMarketId = DimExternalMarket_pbb.pbb_DimExternalMarketId
              FULL OUTER JOIN COL_NAMES ON SUBSTRING(DimExternalMarket_pbb.pbb_ExternalMarketName, 4, 255) = COL_NAMES.AccountMarket
         WHERE CONVERT(DATE, FactExternalDailyStatistics_pbb.pbb_DimDateId) = DATEADD(day, -1, @ReportDate))
     SELECT Data.ScheduledDate, 
            COL_NAMES.AccountMarket, 
            COL_NAMES.MarketSummary, 
            COL_NAMES.SortOrder, 
            Data.LessThan48_HRS, 
            Data.MoreThan48_HRS, 
            Data.LessThan48_HRS_VATNCount, 
            Data.MoreThan48_HRS_VATNCount
     FROM COL_NAMES
          FULL OUTER JOIN Data ON COL_NAMES.AccountMarket = Data.AccountMarket
)
GO
