USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_GTCR_DAY_v3]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
--
-- 2022-09-21 Todd Boyer	version for testing only, delete when complete
--
--
 

CREATE FUNCTION [dbo].[PBB_DB_GTCR_DAY_v3](
			@ReportDate date)
RETURNS TABLE
AS
	RETURN(
	WITH 
	
	    COL_NAMES            -- Market Names for report
		AS (SELECT pbb_MarketSummary
				 , SUBSTRING(pbb_AccountMarket,4,255) AS AccountMarket
				 , SUBSTRING(pbb_AccountMarket,1,2) AS SortOrder
		      FROM DimAccountCategory_pbb
		     WHERE pbb_AccountMarket NOT LIKE ''
		    UNION
		    SELECT pbb_ExternalMarketAccountGroupMarketSummary
				 , pbb_ExternalMarketAccountGroupMarket AS AccountMarket
				 , pbb_ExternalMarketSort AS SortOrder
		      FROM DimExternalMarket_pbb
		     WHERE pbb_ExternalMarketAccountGroupMarket NOT LIKE ''
			),
		 -- DECLARE @ReportDate date = cast(getdate() as date);

		DateList AS ( 
				SELECT @ReportDate AsOfDate       , 14 DayNum, DATEPART(WEEKDAY, @ReportDate )                 DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-1  ,@ReportDate), 13 DayNum, DATEPART(WEEKDAY, DATEADD(d,-1  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-2  ,@ReportDate), 12 DayNum, DATEPART(WEEKDAY, DATEADD(d,-2  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-3  ,@ReportDate), 11 DayNum, DATEPART(WEEKDAY, DATEADD(d,-3  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-4  ,@ReportDate), 10 DayNum, DATEPART(WEEKDAY, DATEADD(d,-4  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-5  ,@ReportDate), 9  DayNum, DATEPART(WEEKDAY, DATEADD(d,-5  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-6  ,@ReportDate), 8  DayNum, DATEPART(WEEKDAY, DATEADD(d,-6  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-7  ,@ReportDate), 7  DayNum, DATEPART(WEEKDAY, DATEADD(d,-7  ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-8  ,@ReportDate), 6  DayNum, DATEPART(WEEKDAY, DATEADD(d,-8  ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-9  ,@ReportDate), 5  DayNum, DATEPART(WEEKDAY, DATEADD(d,-9  ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-10 ,@ReportDate), 4  DayNum, DATEPART(WEEKDAY, DATEADD(d,-10 ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-11 ,@ReportDate), 3  DayNum, DATEPART(WEEKDAY, DATEADD(d,-11 ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-12 ,@ReportDate), 2  DayNum, DATEPART(WEEKDAY, DATEADD(d,-12 ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-13 ,@ReportDate), 1  DayNum, DATEPART(WEEKDAY, DATEADD(d,-13 ,@ReportDate) ) DOW, 2 WeekNum   
		),

		Data
		AS (
-- Internal Install 
		Select Count(distinct DimSalesOrderId) As 'FactSalesOrderId'	
		     ,AsOfDate
			 ,DayNum
			 ,DOW
			 ,WeekNum
			 ,Case  When AccountType = 'Residential'
					Then Count(DimSalesOrderId) Else 0
			   End As 'InstallResCount'
			 ,''   as 'InstallResReconnectCount'
			 ,''   as 'InstallResReconnectExistingCount'
			 ,''   as 'InstallResReconnectNewCount'
			 ,Case  When AccountType = 'Business'
				    Then Count(DimSalesOrderId) Else 0
			   End As 'InstallBusCount'
			 ,''   as 'InstallBusReconnectCount'
			 ,''   as 'InstallBusReconnectExistingCount'
			 ,''   as 'InstallBusReconnectNewCount'
			 ,Case  When AccountType = 'Residential' And pbb_MarketSummary = '01-Total VA/TN'
				    Then Count(DimSalesOrderId) Else 0
			   End As 'InstallResVATNCount'
			 ,''   as 'InstallResVATNReconnectCount'
			 ,''   as 'InstallResVATNReconnectExistingCount'
			 ,''   as 'InstallResVATNReconnectNewCount'
			 ,Case
				 When AccountType = 'Business'
					 And pbb_MarketSummary = '01-Total VA/TN'
				 Then Count(DimSalesOrderId) Else 0
			   End As 'InstallBusVATNCount'
			 ,''   as 'InstallBusVATNReconnectCount'
			 ,''   as 'InstallBusVATNReconnectExistingCount'
			 ,''   as 'InstallBusVATNReconnectNewCount'
			 ,''   As 'DisconnectResCount'
			 ,''   As 'DisconnectBusCount'
			 ,''   As 'DisconnectResVATNCount'
			 ,''   As 'DisconnectBusVATNCount'
			 ,AccountGroup
			 ,AccountClass
			 ,pbb_AccountMarket
			 ,Count(pbb_MarketSummary) As 'VATN'
			 ,pbb_MarketSummary        As 'VATNGroup'
			 ,SalesOrderType
			 ,AccountType
			 ,'' As 'ServiceCallsCount'
			 ,'' As 'ServiceCallsCountVATN'
			 ,'' As 'pbb_DailyStatisticsEOMBacklog'
			 ,'' As 'pbb_DailyStatisticsEOMBacklogVATN'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklog'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklogVATNCount'
			 ,'' As 'ExternalResidentialAdds'
			 ,'' As 'ExternalBusinessAdds'
			 ,'' As 'ExternalResidentialDisconnect'
			 ,'' As 'ExternalBusinessDisconnect'
			 ,cast(0 as smallint)  AS MssSales
		 from [dbo].PBB_DB_ROLLING2WK_DETAIL(@ReportDate)
		 full outer join COL_NAMES cn on pbb_AccountMarket = cn.AccountMarket
		Where SalesOrderType        = 'Install'
		  And pbb_OrderActivityType = 'Install'
		Group By AccountGroup
			   , AccountClass
			   , pbb_AccountMarket
			   , SalesOrderType
			   , AccountType
			   , pbb_MarketSummary
		       , AsOfDate
			   , DayNum
			   , DOW
			   , WeekNum

		Union 
--Internal Reconnect
		 
		Select Count(distinct DimSalesOrderId) As 'FactSalesOrderId'
		     ,AsOfDate
			 ,DayNum
			 ,DOW
			 ,WeekNum
			 ,'' as 'InstallResCount'
			 ,Case
				 When AccountType = 'Residential'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'InstallResReconnectCount'
			 ,Case
				 When AccountType = 'Residential'
					 and SalesOrderClassification = 'Reconnect'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'InstallResReconnectExistingCount'
			 ,Case
				 When AccountType = 'Residential'
					 and SalesOrderClassification = 'New Connect'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'InstallResReconnectNewCount'
			 ,'' as 'InstallBusCount'
			 ,Case
				 When AccountType = 'Business'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'InstallBusReconnectCount'
			 ,Case
				 When AccountType = 'Business'
					 and SalesOrderClassification = 'Reconnect'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'InstallBusReconnectExistingCount'
			 ,Case
				 When AccountType = 'Business'
					 and SalesOrderClassification = 'New Connect'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'InstallBusReconnectNewCount'
			 ,'' as 'InstallResVATNCount'
			 ,Case
				 When AccountType = 'Residential'
					 And pbb_MarketSummary = '01-Total VA/TN'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'InstallResVATNReconnectCount'
			 ,Case
				 When AccountType = 'Residential'
					 and SalesOrderClassification = 'Reconnect'
					 And pbb_MarketSummary = '01-Total VA/TN'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'InstallResVATNReconnectExistingCount'
			 ,Case
				 When AccountType = 'Residential'
					 and SalesOrderClassification = 'New Connect'
					 And pbb_MarketSummary = '01-Total VA/TN'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'InstallResVATNReconnectNewCount'
			 ,'' as 'InstallBusVATNCount'
			 ,Case
				 When AccountType = 'Business'
					 And pbb_MarketSummary = '01-Total VA/TN'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'InstallBusVATNReconnectCount'
			 ,'' As 'InstallBusVATNReconnectExistingCount'
			 ,'' As 'InstallBusVATNReconnectNewCount'
			 ,'' As 'DisconnectResCount'
			 ,'' As 'DisconnectBusCount'
			 ,'' As 'DisconnectResVATNCount'
			 ,'' As 'DisconnectBusVATNCount'
			 ,AccountGroup
			 ,AccountClass
			 ,pbb_AccountMarket
			 ,Count(pbb_MarketSummary) As 'VATN'
			 ,pbb_MarketSummary As 'VATNGroup'
			 ,SalesOrderType
			 ,AccountType
			 ,'' As 'ServiceCallsCount'
			 ,'' As 'ServiceCallsCountVATN'
			 ,'' As 'pbb_DailyStatisticsEOMBacklog'
			 ,'' As 'pbb_DailyStatisticsEOMBacklogVATN'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklog'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklogVATNCount'
			 ,'' As 'ExternalResidentialAdds'
			 ,'' As 'ExternalBusinessAdds'
			 ,'' As 'ExternalResidentialDisconnect'
			 ,'' As 'ExternalBusinessDisconnect'
			 ,cast(0 as smallint)  AS MssSales
		 from [dbo].PBB_DB_ROLLING2WK_DETAIL(@ReportDate)
		 full outer join COL_NAMES cn on pbb_AccountMarket = cn.AccountMarket
		Where SalesOrderType        = 'Install'
		  And pbb_OrderActivityType = 'Install'
		  and SalesOrderClassification in
									  (
									   'Reconnect'
									  ,'New Connect'
									  )
		Group By AccountGroup
			   ,AccountClass
			   ,pbb_AccountMarket
			   ,SalesOrderType
			   ,AccountType
			   ,SalesOrderClassification
			   ,pbb_MarketSummary
		       ,AsOfDate
			   ,DayNum
			   ,DOW
			   ,WeekNum

		Union 
--Internal Disconnect

		Select Count(DimSalesOrderId) As 'FactSalesOrderId'
		     ,AsOfDate
			 ,DayNum
			 ,DOW
			 ,WeekNum
			 ,'' As 'InstallResCount'
			 ,'' as 'InstallResReconnectCount'
			 ,'' as 'InstallResReconnectExistingCount'
			 ,'' as 'InstallResReconnectNewCount'
			 ,'' As 'InstallBusCount'
			 ,'' as 'InstallBusReconnectCount'
			 ,'' as 'InstallBusReconnectExistingCount'
			 ,'' as 'InstallBusReconnectNewCount'
			 ,'' As 'InstallResVATNCount'
			 ,'' as 'InstallResVATNReconnectCount'
			 ,'' as 'InstallResVATNReconnectExistingCount'
			 ,'' as 'InstallResVATNReconnectNewCount'
			 ,'' As 'InstallBusVATNCount'
			 ,'' as 'InstallBusVATNReconnectCount'
			 ,'' as 'InstallBusVATNReconnectExistingCount'
			 ,'' as 'InstallBusVATNReconnectNewCount'
			 ,Case
				 When AccountType = 'Residential'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'DisconnectResCount'
			 ,Case
				 When AccountType = 'Business'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'DisconnectBusCount'
			 ,Case
				 When AccountType = 'Residential'
					 And pbb_MarketSummary = '01-Total VA/TN'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'DisconnectResVATNCount'
			 ,Case
				 When AccountType = 'Business'
					 And pbb_MarketSummary = '01-Total VA/TN'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'DisconnectBusVATNCount'
			 ,AccountGroup
			 ,AccountClass
			 ,pbb_AccountMarket
			 ,Count(pbb_MarketSummary) As 'VATN'
			 ,pbb_MarketSummary As 'VATNGroup'
			 ,SalesOrderType
			 ,AccountType
			 ,'' As 'ServiceCallsCount'
			 ,'' As 'ServiceCallsCountVATN'
			 ,'' As 'pbb_DailyStatisticsEOMBacklog'
			 ,'' As 'pbb_DailyStatisticsEOMBacklogVATN'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklog'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklogVATNCount'
			 ,'' As 'ExternalResidentialAdds'
			 ,'' As 'ExternalBusinessAdds'
			 ,'' As 'ExternalResidentialDisconnect'
			 ,'' As 'ExternalBusinessDisconnect'
			 ,cast(0 as smallint)  AS MssSales
		 from [dbo].PBB_DB_ROLLING2WK_DETAIL(@ReportDate)
		 full outer join COL_NAMES cn on pbb_AccountMarket = cn.AccountMarket
		Where SalesOrderType        = 'Disconnect'
		  And pbb_OrderActivityType = 'Disconnect'
		Group By AccountGroup
			   ,AccountClass
			   ,pbb_AccountMarket
			   ,SalesOrderType
			   ,AccountType
			   ,pbb_MarketSummary
		       ,AsOfDate
			   ,DayNum
			   ,DOW
			   ,WeekNum

		Union 
--External Markets Install 

		select FactSalesOrderId
		     ,AsOfDate
			 ,DayNum
			 ,DOW
			 ,WeekNum
			 ,InstallResCount
			 ,'' as 'InstallResReconnectCount'
			 ,'' as 'InstallResReconnectExistingCount'
			 ,'' as 'InstallResReconnectNewCount'
			 ,InstallBusCount
			 ,'' as 'InstallBusReconnectCount'
			 ,'' as 'InstallBusReconnectExistingCount'
			 ,'' as 'InstallBusReconnectNewCount'
			 ,InstallResVATNCount
			 ,'' as 'InstallResVATNReconnectCount'
			 ,'' as 'InstallResVATNReconnectExistingCount'
			 ,'' as 'InstallResVATNReconnectNewCount'
			 ,InstallBusVATNCount
			 ,'' as 'InstallBusVATNReconnectCount'
			 ,'' as 'InstallBusVATNReconnectExistingCount'
			 ,'' as 'InstallBusVATNReconnectNewCount'
			 ,DisconnectResCount
			 ,DisconnectBusCount
			 ,DisconnectResVATNCount
			 ,DisconnectBusVATNCount
			 ,AccountGroup
			 ,AccountClass
			 ,pbb_AccountMarket
			 ,VATN
			 ,VATNGroup
			 ,SalesOrderType
			 ,AccountType
			 ,ServiceCallsCount
			 ,ServiceCallsCountVATN
			 ,pbb_DailyStatisticsEOMBacklog
			 ,pbb_DailyStatisticsEOMBacklogVATN
			 ,pbb_DailyStatisticsSheduledBacklog
			 ,pbb_DailyStatisticsSheduledBacklogVATNCount
			 ,ExternalResidentialAdds
			 ,ExternalBusinessAdds
			 ,ExternalResidentialDisconnect
			 ,ExternalBusinessDisconnect
			 ,cast(0 as smallint)  AS MssSales
		from PBB_DB_ROLLING2WK_EXTERNALMARKET(@ReportDate)

		Union
--Internal Markets Service Calls
		Select '' As 'FactSalesOrderId'
		     ,AsOfDate
			 ,DayNum
			 ,DOW
			 ,WeekNum
			 ,'' As 'InstallResCount'
			 ,'' as 'InstallResReconnectCount'
			 ,'' as 'InstallResReconnectExistingCount'
			 ,'' as 'InstallResReconnectNewCount'
			 ,'' As 'InstallBusCount'
			 ,'' as 'InstallBusReconnectCount'
			 ,'' as 'InstallBusReconnectExistingCount'
			 ,'' as 'InstallBusReconnectNewCount'
			 ,'' As 'InstallResVATNCount'
			 ,'' as 'InstallResVATNReconnectCount'
			 ,'' as 'InstallResVATNReconnectExistingCount'
			 ,'' as 'InstallResVATNReconnectNewCount'
			 ,'' As 'InstallBusVATNCount'
			 ,'' as 'InstallBusVATNReconnectCount'
			 ,'' as 'InstallBusVATNReconnectExistingCount'
			 ,'' as 'InstallBusVATNReconnectNewCount'
			 ,'' As 'DisconnectResCount'
			 ,'' As 'DisconnectBusCount'
			 ,'' As 'DisconnectResVATNCount'
			 ,'' As 'DisconnectBusVATNCount'
			 ,[Account Group] As AccountGroup
			 ,Accountclass As 'AccountClass'
			 ,pbb_AccountMarket
			 ,Count(pbb_MarketSummary) As 'VATN'
			 ,pbb_MarketSummary As 'VATNGroup'
			 ,'' As 'SalesOrderType'
			 ,AccountType As 'AccountType'
			 ,Count(DimCaseId) AS ServiceCallsCount
			 ,Case
				 When pbb_MarketSummary = '01-Total VA/TN'
				 Then Count(DimCaseId) Else 0
			  End As 'ServiceCallsCountVATN'
			 ,'' As 'pbb_DailyStatisticsEOMBacklog'
			 ,'' As 'pbb_DailyStatisticsEOMBacklogVATN'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklog'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklogVATNCount'
			 ,'' As 'ExternalResidentialAdds'
			 ,'' As 'ExternalBusinessAdds'
			 ,'' As 'ExternalResidentialDisconnect'
			 ,'' As 'ExternalBusinessDisconnect'
			 ,cast(0 as smallint)  AS MssSales
		 from PBB_DB_SERVICE_CALLS_ROLLING2WK_REPORT(@ReportDate)
		 full outer join COL_NAMES cn on pbb_AccountMarket = cn.AccountMarket
		Where 1 = 1
		Group By [Account Group]
			   ,pbb_AccountMarket
			   ,pbb_MarketSummary
			   ,ActualEnd_DimDateId
			   ,Accountclass
			   ,AccountType   
			   ,AsOfDate
			   ,DayNum
			   ,DOW
			   ,WeekNum

		Union

--External Markets Service Call
		Select '' As 'FactSalesOrderId'
		     ,AsOfDate
			 ,DayNum
			 ,DOW
			 ,WeekNum
			 ,'' As 'InstallResCount'
			 ,'' as 'InstallResReconnectCount'
			 ,'' as 'InstallResReconnectExistingCount'
			 ,'' as 'InstallResReconnectNewCount'
			 ,'' As 'InstallBusCount'
			 ,'' as 'InstallBusReconnectCount'
			 ,'' as 'InstallBusReconnectExistingCount'
			 ,'' as 'InstallBusReconnectNewCount'
			 ,'' As 'InstallResVATNCount'
			 ,'' as 'InstallResVATNReconnectCount'
			 ,'' as 'InstallResVATNReconnectExistingCount'
			 ,'' as 'InstallResVATNReconnectNewCount'
			 ,'' As 'InstallBusVATNCount'
			 ,'' as 'InstallBusVATNReconnectCount'
			 ,'' as 'InstallBusVATNReconnectExistingCount'
			 ,'' as 'InstallBusVATNReconnectNewCount'
			 ,'' As 'DisconnectResCount'
			 ,'' As 'DisconnectBusCount'
			 ,'' As 'DisconnectResVATNCount'
			 ,'' As 'DisconnectBusVATNCount'
			 ,'' As 'AccountGroup'
			 ,'' As 'AccountClass'
			 ,DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket As 'pbb_AccountMarket'
			 ,'' As 'VATN'
			 ,DimExternalMarket_pbb.pbb_externalMarketAccountGroupMarketSummary As 'VATNGroup'
			 ,'' As 'SalesOrderType'
			 ,'' As 'AccountType'
			 ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsServiceCalls AS ServiceCallsCount
			 ,Case
				 When DimExternalMarket_pbb.pbb_externalMarketAccountGroupMarketSummary Like '%VATN%'
				 Then FactExternalDailyStatistics_pbb.pbb_DailyStatisticsServiceCalls Else 0
			  End As 'ServiceCallsCountVATN'
			 ,'' As 'pbb_DailyStatisticsEOMBacklog'
			 ,'' As 'pbb_DailyStatisticsEOMBacklogVATN'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklog'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklogVATNCount'
			 ,'' As 'ExternalResidentialAdds'
			 ,'' As 'ExternalBusinessAdds'
			 ,'' As 'ExternalResidentialDisconnect'
			 ,'' As 'ExternalBusinessDisconnect'
			 ,cast(0 as smallint)  AS MssSales
		from FactExternalDailyStatistics_pbb
			join DimExternalMarket_pbb   on FactExternalDailyStatistics_pbb.pbb_DimExternalMarketId = DimExternalMarket_pbb.pbb_DimExternalMarketId
			full outer join COL_NAMES cn on DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket = cn.AccountMarket
			join DateList             dl on dl.AsOfDate = (Convert(Date,FactExternalDailyStatistics_pbb.pbb_DimDateId) )
		Where 1=1
 
		Union

		 
--Internal  Backlog  Total Sched
		Select '' As 'FactSalesOrderId'
		     ,AsOfDate
			 ,DayNum
			 ,DOW
			 ,WeekNum
			 ,'' As 'InstallResCount'
			 ,'' as 'InstallResReconnectCount'
			 ,'' as 'InstallResReconnectExistingCount'
			 ,'' as 'InstallResReconnectNewCount'
			 ,'' As 'InstallBusCount'
			 ,'' as 'InstallBusReconnectCount'
			 ,'' as 'InstallBusReconnectExistingCount'
			 ,'' as 'InstallBusReconnectNewCount'
			 ,'' As 'InstallResVATNCount'
			 ,'' as 'InstallResVATNReconnectCount'
			 ,'' as 'InstallResVATNReconnectExistingCount'
			 ,'' as 'InstallResVATNReconnectNewCount'
			 ,'' As 'InstallBusVATNCount'
			 ,'' as 'InstallBusVATNReconnectCount'
			 ,'' as 'InstallBusVATNReconnectExistingCount'
			 ,'' as 'InstallBusVATNReconnectNewCount'
			 ,'' As 'DisconnectResCount'
			 ,'' As 'DisconnectBusCount'
			 ,'' As 'DisconnectResVATNCount'
			 ,'' As 'DisconnectBusVATNCount'
			 ,[Account Group] As AccountGroup
			 ,Accountclass As 'AccountClass'
			 ,[Account Market]
			 ,Count(pbb_MarketSummary) As 'VATN'
			 ,pbb_MarketSummary As 'VATNGroup'
			 ,'' As 'SalesOrderType'
			 ,AccountType As 'AccountType'
			 ,'' AS ServiceCallsCount
			 ,'' As 'ServiceCallsCountVATN'
			 ,'' As 'pbb_DailyStatisticsEOMBacklog'
			 ,'' As 'pbb_DailyStatisticsEOMBacklogVATN'
			 ,Count([SO Number]) As 'pbb_DailyStatisticsSheduledBacklog'
			 ,Case
				 When pbb_MarketSummary = '01-Total VA/TN'
				 Then Count([SO Number]) Else 0
			  End As 'pbb_DailyStatisticsSheduledBacklogVATNCount'
			 ,'' As 'ExternalResidentialAdds'
			 ,'' As 'ExternalBusinessAdds'
			 ,'' As 'ExternalResidentialDisconnect'
			 ,'' As 'ExternalBusinessDisconnect'
			 ,cast(0 as smallint)  AS MssSales
		from [dbo].[PBB_DB_BACKLOG_RUNNING2WK_TOTAL_v3](@ReportDate)
		full outer join COL_NAMES cn on [Account Market] = cn.AccountMarket
		Group By [Account Group]
			   ,[Account Market]
			   ,pbb_MarketSummary
			   ,Accountclass
			   ,AccountType
		       ,AsOfDate
			   ,DayNum
			   ,DOW
			   ,WeekNum
		Union All

--External Backlog Total Sch
		Select '' As 'FactSalesOrderId'
		     ,AsOfDate
			 ,DayNum
			 ,DOW
			 ,WeekNum
			 ,'' As 'InstallResCount'
			 ,'' as 'InstallResReconnectCount'
			 ,'' as 'InstallResReconnectExistingCount'
			 ,'' as 'InstallResReconnectNewCount'
			 ,'' As 'InstallBusCount'
			 ,'' as 'InstallBusReconnectCount'
			 ,'' as 'InstallBusReconnectExistingCount'
			 ,'' as 'InstallBusReconnectNewCount'
			 ,'' As 'InstallResVATNCount'
			 ,'' as 'InstallResVATNReconnectCount'
			 ,'' as 'InstallResVATNReconnectExistingCount'
			 ,'' as 'InstallResVATNReconnectNewCount'
			 ,'' As 'InstallBusVATNCount'
			 ,'' as 'InstallBusVATNReconnectCount'
			 ,'' as 'InstallBusVATNReconnectExistingCount'
			 ,'' as 'InstallBusVATNReconnectNewCount'
			 ,'' As 'DisconnectResCount'
			 ,'' As 'DisconnectBusCount'
			 ,'' As 'DisconnectResVATNCount'
			 ,'' As 'DisconnectBusVATNCount'
			 ,'' As 'AccountGroup'
			 ,'' As 'AccountClass'
			 ,DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket As 'pbb_AccountMarket'
			 ,'' AS 'VATN'
			 ,DimExternalMarket_pbb.pbb_externalMarketAccountGroupMarketSummary As 'VATNGroup'
			 ,'' As 'SalesOrderType'
			 ,'' As 'AccountType'
			 ,'' AS ServiceCallsCount
			 ,'' As 'ServiceCallsCount VATN'
			 ,'' As 'pbb_DailyStatisticsEOMBacklog'
			 ,'' As 'pbb_DailyStatisticsEOMBacklogVATN'
			 ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsSheduledBacklog As 'pbb_DailyStatisticsSheduledBacklog'
			 ,Case
				 When DimExternalMarket_pbb.pbb_externalMarketAccountGroupMarketSummary = '01-Total VA/TN'
				 Then FactExternalDailyStatistics_pbb.pbb_DailyStatisticsSheduledBacklog Else 0
			  End As 'pbb_DailyStatisticsSheduledBacklogVATNCount'
			 ,'' As 'ExternalResidentialAdds'
			 ,'' As 'ExternalBusinessAdds'
			 ,'' As 'ExternalResidentialDisconnect'
			 ,'' As 'ExternalBusinessDisconnect'
			 ,cast(0 as smallint)  AS MssSales
		from FactExternalDailyStatistics_pbb
			join DimExternalMarket_pbb on FactExternalDailyStatistics_pbb.pbb_DimExternalMarketId = DimExternalMarket_pbb.pbb_DimExternalMarketId
			full outer join COL_NAMES cn on DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket = cn.AccountMarket
			join DateList             dl on dl.AsOfDate  = cast(FactExternalDailyStatistics_pbb.pbb_DimDateId as date)
		Where 1=1

		UNION

--Mannually entered data
		Select '' As 'FactSalesOrderId'
		     ,AsOfDate
			 ,DayNum
			 ,DOW
			 ,WeekNum
			 ,'' As 'InstallResCount'
			 ,'' as 'InstallResReconnectCount'
			 ,'' as 'InstallResReconnectExistingCount'
			 ,'' as 'InstallResReconnectNewCount'
			 ,'' As 'InstallBusCount'
			 ,'' as 'InstallBusReconnectCount'
			 ,'' as 'InstallBusReconnectExistingCount'
			 ,'' as 'InstallBusReconnectNewCount'
			 ,'' As 'InstallResVATNCount'
			 ,'' as 'InstallResVATNReconnectCount'
			 ,'' as 'InstallResVATNReconnectExistingCount'
			 ,'' as 'InstallResVATNReconnectNewCount'
			 ,'' As 'InstallBusVATNCount'
			 ,'' as 'InstallBusVATNReconnectCount'
			 ,'' as 'InstallBusVATNReconnectExistingCount'
			 ,'' as 'InstallBusVATNReconnectNewCount'
			 ,'' As 'DisconnectResCount'
			 ,'' As 'DisconnectBusCount'
			 ,'' As 'DisconnectResVATNCount'
			 ,'' As 'DisconnectBusVATNCount'
			 ,'' As 'AccountGroup'
			 ,'' As 'AccountClass'
			 ,CASE WHEN Market ='AlaGa' THEN 'Central AL'
			       WHEN Market ='HAG' THEN 'Hagerstown'
			       WHEN Market ='Island' THEN 'South AL'
			       WHEN Market ='Michigan' THEN 'Michigan - FTTH'
			       WHEN Market ='N AL - S TN' THEN 'North AL - FTTH'
			       WHEN Market ='NY' THEN 'New York'
			       WHEN Market ='Ohio' THEN 'Ohio - FTTH'
			       WHEN Market ='VA/TN' THEN 'VA/TN'
			       WHEN Market ='W - Mich' THEN 'W Michigan - FTTH'
			       ELSE 'UNKNOWN' 
			   END As 'pbb_AccountMarket'
			 ,'' AS 'VATN'
			 ,'' As 'VATNGroup'
			 ,'' As 'SalesOrderType'
			 ,'' As 'AccountType'
			 ,'' AS ServiceCallsCount
			 ,'' As 'ServiceCallsCount VATN'
			 ,'' As 'pbb_DailyStatisticsEOMBacklog'
			 ,'' As 'pbb_DailyStatisticsEOMBacklogVATN'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklog'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklogVATNCount'
			 ,'' As 'ExternalResidentialAdds'
			 ,'' As 'ExternalBusinessAdds'
			 ,'' As 'ExternalResidentialDisconnect'
			 ,'' As 'ExternalBusinessDisconnect'
			 ,sum(coalesce(mss.value,0))  AS MssSales
		 from DateList dl 
         join [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_ManualSalesStats_history] mss  on dl.AsOfDate = cast(mss.[Date] as date)
		Where 1=1
		group by CASE WHEN Market ='AlaGa' THEN 'Central AL'
			       WHEN Market ='HAG' THEN 'Hagerstown'
			       WHEN Market ='Island' THEN 'South AL'
			       WHEN Market ='Michigan' THEN 'Michigan - FTTH'
			       WHEN Market ='N AL - S TN' THEN 'North AL - FTTH'
			       WHEN Market ='NY' THEN 'New York'
			       WHEN Market ='Ohio' THEN 'Ohio - FTTH'
			       WHEN Market ='VA/TN' THEN 'VA/TN'
			       WHEN Market ='W - Mich' THEN 'W Michigan - FTTH'
			       ELSE 'UNKNOWN' 
			   END 
		     ,AsOfDate
			 ,DayNum
			 ,DOW
			 ,WeekNum
		)
		SELECT cn.pbb_MarketSummary
		     ,CASE WHEN  DOW=1  THEN DateAdd(d,1,AsOfDate)
			       ELSE  Coalesce(AsOfDate,cast(@ReportDate as date)) 
			   END AsOfDate
			 ,CASE WHEN DOW=1 THEN DayNum+1 ELSE coalesce(DayNum,14)  END DayNum
			 ,DOW
			 ,WeekNum
			 ,cn.AccountMarket
			 ,cn.SortOrder
			 ,isnull(data.FactSalesOrderid,0) As FactSalesOrderid
			 ,IsNull(data.InstallResCount,0) As [Install Res Count]
			 ,isnull(data.InstallResReconnectCount,0) as [Reconnect Res Count]
			 ,isnull(data.InstallResReconnectExistingCount,0) as [Reconnect Res Existing Count]
			 ,isnull(data.InstallResReconnectNewCount,0) as [Reconnect Res New Count]
			 ,IsNull(data.InstallBusCount,0) As [Install Bus Count]
			 ,isnull(data.InstallBusReconnectCount,0) as [Reconnect Bus Count]
			 ,isnull(data.InstallBusReconnectExistingCount,0) as [Reconnect Bus Existing Count]
			 ,isnull(data.InstallBusReconnectNewCount,0) as [Reconnect Bus New Count]
			 ,IsNull(data.InstallResVATNCount,0) As [Install Res  VATN Count]
			 ,isnull(data.InstallResVATNReconnectCount,0) as [Reconnect Res  VATN Count]
			 ,isnull(data.InstallResVATNReconnectExistingCount,0) as [Reconnect Res  Existing VATN Count]
			 ,isnull(data.InstallResVATNReconnectNewCount,0) as [Reconnect Res  New VATN Count]
			 ,IsNull(data.InstallBusVATNCount,0) As [Install Bus VATN  Count]
			 ,IsNull(data.InstallBusVATNReconnectCount,0) As [Reconnect Bus VATN  Count]
			 ,IsNull(data.InstallBusVATNReconnectExistingCount,0) As [Reconnect Bus Existing VATN  Count]
			 ,IsNull(data.InstallBusVATNReconnectNewCount,0) As [Reconnect Bus New VATN  Count]
			 ,IsNull(data.DisconnectResCount,0) As [Disconnect Res Count]
			 ,IsNull(data.DisconnectBusCount,0) As [Disconnect Bus Count]
			 ,IsNull(data.DisconnectResVATNCount,0) As [Disconnect Res  VATN Count]
			 ,IsNull(data.DisconnectBusVATNCount,0) as [Disconnect Bus VATN  Count]
			 ,IsNull(data.AccountGroup,'') As [AccountGroup]
			 ,IsNull(data.AccountClass,'') As [AccountClass]
			 ,IsNull(data.pbb_AccountMarket,'') As [pbb_AccountMarket]
			 ,IsNull(data.VATN,0) AS [VATN]
			 ,IsNull(data.VATNGroup,0) As [VATN Group]
			 ,IsNull(data.SalesOrderType,'') As [SalesOrderType]
			 ,IsNull(data.AccountType,'') As [AccountType]
			 ,IsNull(data.ServiceCallsCount,0) As ServiceCallsCount
			 ,IsNull(data.ServiceCallsCountVATN,0) As [ServiceCallsCount VATN]
			 ,IsNull(data.pbb_DailyStatisticsEOMBacklog,0) As [pbb_DailyStatisticsEOMBacklog]
			 ,case when DOW =1 then 0 else IsNull(data.pbb_DailyStatisticsSheduledBacklog,0) end As [pbb_DailyStatisticsSheduledBacklog]
			 ,IsNull(data.pbb_DailyStatisticsSheduledBacklogVATNCount,0) As [pbb_DailyStatisticsSheduledBacklog VATN Count]
			 ,IsNull(data.ExternalResidentialAdds,0) As [External Residential Adds]
			 ,IsNull(data.ExternalBusinessAdds,0) As [External Business Adds]
			 ,IsNull(data.ExternalResidentialDisconnect,0) As [External Residential Disconnect]
			 ,IsNull(data.ExternalBusinessDisconnect,0) AS [External Business Disconnect]
			 ,IsNull(data.pbb_DailyStatisticsEOMBacklogVATN,0) As [pbb_DailyStatistics EOM Backlog VATN]
			 ,IsNull(data.MssSales,0) As MssSales
		 FROM COL_Names as cn
		 full outer join Data on cn.AccountMarket = data.pbb_AccountMarket
		Where cn.AccountMarket IS NOT NULL
		  AND not (DayNum = 14 and DOW=1)
		UNION
				SELECT '' pbb_MarketSummary
		     ,CASE WHEN  DOW=1  THEN DateAdd(d,1,AsOfDate)
			       ELSE  Coalesce(AsOfDate,cast(@ReportDate as date)) 
			   END AsOfDate
			 ,CASE WHEN DOW=1 THEN DayNum+1 ELSE coalesce(DayNum,14)  END DayNum
			 ,DOW
			 ,WeekNum
			 ,'Total Company' AccountMarket
			 ,0 SortOrder
			 ,0 As FactSalesOrderid
			 ,IsNull(data.InstallResCount,0) As [Install Res Count]
			 ,isnull(data.InstallResReconnectCount,0) as [Reconnect Res Count]
			 ,isnull(data.InstallResReconnectExistingCount,0) as [Reconnect Res Existing Count]
			 ,isnull(data.InstallResReconnectNewCount,0) as [Reconnect Res New Count]
			 ,IsNull(data.InstallBusCount,0) As [Install Bus Count]
			 ,isnull(data.InstallBusReconnectCount,0) as [Reconnect Bus Count]
			 ,isnull(data.InstallBusReconnectExistingCount,0) as [Reconnect Bus Existing Count]
			 ,isnull(data.InstallBusReconnectNewCount,0) as [Reconnect Bus New Count]
			 ,IsNull(data.InstallResVATNCount,0) As [Install Res  VATN Count]
			 ,isnull(data.InstallResVATNReconnectCount,0) as [Reconnect Res  VATN Count]
			 ,isnull(data.InstallResVATNReconnectExistingCount,0) as [Reconnect Res  Existing VATN Count]
			 ,isnull(data.InstallResVATNReconnectNewCount,0) as [Reconnect Res  New VATN Count]
			 ,IsNull(data.InstallBusVATNCount,0) As [Install Bus VATN  Count]
			 ,IsNull(data.InstallBusVATNReconnectCount,0) As [Reconnect Bus VATN  Count]
			 ,IsNull(data.InstallBusVATNReconnectExistingCount,0) As [Reconnect Bus Existing VATN  Count]
			 ,IsNull(data.InstallBusVATNReconnectNewCount,0) As [Reconnect Bus New VATN  Count]
			 ,IsNull(data.DisconnectResCount,0) As [Disconnect Res Count]
			 ,IsNull(data.DisconnectBusCount,0) As [Disconnect Bus Count]
			 ,IsNull(data.DisconnectResVATNCount,0) As [Disconnect Res  VATN Count]
			 ,IsNull(data.DisconnectBusVATNCount,0) as [Disconnect Bus VATN  Count]
			 ,IsNull(data.AccountGroup,'') As [AccountGroup]
			 ,IsNull(data.AccountClass,'') As [AccountClass]
			 ,IsNull(data.pbb_AccountMarket,'') As [pbb_AccountMarket]
			 ,IsNull(data.VATN,0) AS [VATN]
			 ,IsNull(data.VATNGroup,0) As [VATN Group]
			 ,IsNull(data.SalesOrderType,'') As [SalesOrderType]
			 ,IsNull(data.AccountType,'') As [AccountType]
			 ,IsNull(data.ServiceCallsCount,0) As ServiceCallsCount
			 ,IsNull(data.ServiceCallsCountVATN,0) As [ServiceCallsCount VATN]
			 ,IsNull(data.pbb_DailyStatisticsEOMBacklog,0) As [pbb_DailyStatisticsEOMBacklog]
			 ,case when DOW =1 then 0 else IsNull(data.pbb_DailyStatisticsSheduledBacklog,0) end As [pbb_DailyStatisticsSheduledBacklog]
			 ,IsNull(data.pbb_DailyStatisticsSheduledBacklogVATNCount,0) As [pbb_DailyStatisticsSheduledBacklog VATN Count]
			 ,IsNull(data.ExternalResidentialAdds,0) As [External Residential Adds]
			 ,IsNull(data.ExternalBusinessAdds,0) As [External Business Adds]
			 ,IsNull(data.ExternalResidentialDisconnect,0) As [External Residential Disconnect]
			 ,IsNull(data.ExternalBusinessDisconnect,0) AS [External Business Disconnect]
			 ,IsNull(data.pbb_DailyStatisticsEOMBacklogVATN,0) As [pbb_DailyStatistics EOM Backlog VATN]
			 ,IsNull(data.MssSales,0) As MssSales
		 FROM  Data 
		Where 1=1
		  AND not (DayNum = 14 and DOW=1)
		  AND data.pbb_AccountMarket IN (SELECT AccountMarket FROM COL_Names )
		)
GO
