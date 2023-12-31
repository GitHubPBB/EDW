USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_SF_SH_DAILY]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE FUNCTION [dbo].[PBB_DB_SF_SH_DAILY](
			@ReportDate date)
RETURNS TABLE 
AS
RETURN 
(


WITH COL_NAMES AS
(
SELECT pbb_MarketSummary,
       SUBSTRING(pbb_AccountMarket,4,255) AS AccountMarket,
       SUBSTRING(pbb_AccountMarket,1,2) AS SortOrder
FROM DimAccountCategory_pbb
WHERE pbb_AccountMarket NOT LIKE ''
UNION
SELECT pbb_ExternalMarketAccountGroupMarketSummary,
       pbb_ExternalMarketAccountGroupMarket AS AccountMarket,
       pbb_ExternalMarketSort AS SortOrder
FROM DimExternalMarket_pbb
WHERE pbb_ExternalMarketAccountGroupMarket NOT LIKE ''
)

,Data AS
(
Select 
      OrderReviewDate,
      Count(Distinct SalesOrderId) AS 'Install_Change',
      D.pbb_AccountMarket, 
      D.pbb_MarketSummary As 'VATN'
From [dbo].[PBB_DB_SMART_HOME_DAILY_DETAILED] (@ReportDate) D
FULL Outer Join COL_NAMES on pbb_AccountMarket = COL_NAMES.AccountMarket 
Group By D.pbb_AccountMarket, D.pbb_MarketSummary, OrderReviewDate

Union all

--External Markets
Select 
FactExternalDailyStatistics_pbb.pbb_DimDateId AS pbb_SalesOrderReviewDate,
pbb_DailyStatisticsSmarthome AS 'Install_Change',
DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket As 'pbb_AccountMarket',
'' As 'VATN'
From FactExternalDailyStatistics_pbb
join DimExternalMarket_pbb  on FactExternalDailyStatistics_pbb.pbb_DimExternalMarketId = DimExternalMarket_pbb.pbb_DimExternalMarketId
FULL Outer Join COL_NAMES on DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket = COL_NAMES.AccountMarket 
Where ((Convert(Date, FactExternalDailyStatistics_pbb.pbb_DimDateId) = COnvert (Date, Case When Datepart(DW, @ReportDate)= 2 Then  DATEadd(DD, -3,  @ReportDate) Else  DATEadd(DD, -1,  @ReportDate) End)) 
      Or Convert(Date, FactExternalDailyStatistics_pbb.pbb_DimDateId) = COnvert (Date, Case When Datepart(DW, @ReportDate)=   2 Then  DATEadd(DD, -2,  @ReportDate) Else DATEadd(DD, -1,  @ReportDate) End) 
      Or Convert(Date, FactExternalDailyStatistics_pbb.pbb_DimDateId) = COnvert (Date, Case When Datepart(DW, @ReportDate)=   2 Then  DATEadd(DD, -1,  @ReportDate) Else DATEadd(DD, -1,  @ReportDate) End)) 
	)

SELECT 
Data.OrderReviewDate,
COL_Names.AccountMarket,
COL_Names.pbb_MarketSummary,
COL_Names.SortOrder,
Data.Install_Change
FROM COL_Names
Full Outer Join Data on COL_Names.AccountMarket = data.pbb_AccountMarket
Where COL_Names.AccountMarket is not null 

)
GO
