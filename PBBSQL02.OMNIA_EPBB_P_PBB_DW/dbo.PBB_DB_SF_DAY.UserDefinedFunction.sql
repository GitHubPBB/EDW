USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_SF_DAY]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
select * from [dbo].[PBB_DB_SF_DAY]('10/13/2023')
*/

CREATE FUNCTION [dbo].[PBB_DB_SF_DAY](
			@ReportDate date)
RETURNS TABLE
AS
	RETURN(
	WITH COL_NAMES
		AS (SELECT distinct 
				 pbb_MarketSummary
				,SUBSTRING(pbb_AccountMarket,4,255) AS AccountMarket
				,max(SUBSTRING(pbb_AccountMarket,1,2)) AS SortOrder
		    FROM DimAccountCategory_pbb
		    WHERE pbb_AccountMarket NOT LIKE ''
		    group by pbb_MarketSummary
				  ,SUBSTRING(pbb_AccountMarket,4,255)
		    UNION
		    SELECT pbb_ExternalMarketAccountGroupMarketSummary
				,pbb_ExternalMarketAccountGroupMarket AS AccountMarket
				,pbb_ExternalMarketSort AS SortOrder
		    FROM DimExternalMarket_pbb
		    WHERE pbb_ExternalMarketAccountGroupMarket NOT LIKE ''),
		Data
		AS (-- Internal Install 
		Select Count(distinct DimSalesOrderId) As 'FactSalesOrderId'
			 ,Case
				 When AccountType = 'Residential'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'InstallResCount'
			 ,'' as 'InstallResReconnectCount'
			 ,'' as 'InstallResReconnectExistingCount'
			 ,'' as 'InstallResReconnectNewCount'
			 ,Case
				 When AccountType = 'Business'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'InstallBusCount'
			 ,'' as 'InstallBusReconnectCount'
			 ,'' as 'InstallBusReconnectExistingCount'
			 ,'' as 'InstallBusReconnectNewCount'
			 ,Case
				 When AccountType = 'Residential'
					 And pbb_MarketSummary = '01-Total VA/TN'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'InstallResVATNCount'
			 ,'' as 'InstallResVATNReconnectCount'
			 ,'' as 'InstallResVATNReconnectExistingCount'
			 ,'' as 'InstallResVATNReconnectNewCount'
			 ,Case
				 When AccountType = 'Business'
					 And pbb_MarketSummary = '01-Total VA/TN'
				 Then Count(DimSalesOrderId) Else 0
			  End As 'InstallBusVATNCount'
			 ,'' as 'InstallBusVATNReconnectCount'
			 ,'' as 'InstallBusVATNReconnectExistingCount'
			 ,'' as 'InstallBusVATNReconnectNewCount'
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
		from [dbo].[PBB_DB_DAILY_DETAIL_V2](@ReportDate)
			full outer join COL_NAMES cn on pbb_AccountMarket = cn.AccountMarket
		Where SalesOrderType = 'Install'
			 And pbb_OrderActivityType = 'Install'
		Group By AccountGroup
			   ,AccountClass
			   ,pbb_AccountMarket
			   ,SalesOrderType
			   ,AccountType
			   ,pbb_MarketSummary
		Union --Internal Reconnect
		Select Count(distinct DimSalesOrderId) As 'FactSalesOrderId'
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
		from [dbo].[PBB_DB_DAILY_DETAIL_V2](@ReportDate)
			full outer join COL_NAMES cn on pbb_AccountMarket = cn.AccountMarket
		Where SalesOrderType = 'Install'
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
		Union --Internal Disconnect
		Select Count(DimSalesOrderId) As 'FactSalesOrderId'
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
		from [dbo].[PBB_DB_DAILY_DETAIL_V2](@ReportDate)
			full outer join COL_NAMES cn on pbb_AccountMarket = cn.AccountMarket
		Where SalesOrderType = 'Disconnect'
			 And pbb_OrderActivityType = 'Disconnect'
		Group By AccountGroup
			   ,AccountClass
			   ,pbb_AccountMarket
			   ,SalesOrderType
			   ,AccountType
			   ,pbb_MarketSummary
		Union all--External Markets Install 
		select FactSalesOrderId
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
		from PBB_DB_DAILY_DETAIL_EXTERNALMARKET(@ReportDate)
		Union
		--Internal Markets Service Calls
		Select '' As 'FactSalesOrderId'
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
		from PBB_DB_SERVICE_CALLS_DETAIL_REPORT(@ReportDate)
			full outer join COL_NAMES cn on pbb_AccountMarket = cn.AccountMarket
		Where 1 = 1
		Group By [Account Group]
			   ,pbb_AccountMarket
			   ,pbb_MarketSummary
			   ,ActualEnd_DimDateId
			   ,Accountclass
			   ,AccountType
		Union
		--External Markets Service Call
		Select '' As 'FactSalesOrderId'
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
		from FactExternalDailyStatistics_pbb
			join DimExternalMarket_pbb on FactExternalDailyStatistics_pbb.pbb_DimExternalMarketId = DimExternalMarket_pbb.pbb_DimExternalMarketId
			full outer join COL_NAMES cn on DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket = cn.AccountMarket
		Where(Convert(Date,FactExternalDailyStatistics_pbb.pbb_DimDateId) = COnvert(Date,
																	 Case
																		When Datepart(DW,@ReportDate) = 2
																		Then DATEadd(DD,-3,@ReportDate) Else DATEadd(DD,-1,@ReportDate)
																	 End)
			 Or Convert(Date,FactExternalDailyStatistics_pbb.pbb_DimDateId) = COnvert(Date,
																	    Case
																		   When Datepart(DW,@ReportDate) = 2
																		   Then DATEadd(DD,-2,@ReportDate) Else DATEadd(DD,-1,@ReportDate)
																	    End)
			 Or Convert(Date,FactExternalDailyStatistics_pbb.pbb_DimDateId) = COnvert(Date,
																	    Case
																		   When Datepart(DW,@ReportDate) = 2
																		   Then DATEadd(DD,-1,@ReportDate) Else DATEadd(DD,-1,@ReportDate)
																	    End))
		Union
		--Internal  Backlog  EOM
		Select '' As 'FactSalesOrderId'
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
			 ,Count(Distinct ActivityId) As 'pbb_DailyStatisticsEOMBacklog'
			 ,Case
				 When pbb_MarketSummary = '01-Total VA/TN'
				 Then Count(Distinct ActivityId) Else 0
			  End As 'pbb_DailyStatisticsEOMBacklogVATN'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklog'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklogVATNCount'
			 ,'' As 'ExternalResidentialAdds'
			 ,'' As 'ExternalBusinessAdds'
			 ,'' As 'ExternalResidentialDisconnect'
			 ,'' As 'ExternalBusinessDisconnect'
		From [dbo].[PBB_DB_BACKLOG_MONTH](@ReportDate)
			full outer join COL_NAMES cn on [Account Market] = cn.AccountMarket
		Group By [Account Group]
			   ,[Account Market]
			   ,pbb_MarketSummary
			   ,Accountclass
			   ,AccountType
		Union
		--External Backlog EOM
		Select '' As 'FactSalesOrderId'
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
			 ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsEOMBacklog As 'pbb_DailyStatisticsEOMBacklog'
			 ,Case
				 When DimExternalMarket_pbb.pbb_externalMarketAccountGroupMarketSummary = '01-Total VA/TN'
				 Then FactExternalDailyStatistics_pbb.pbb_DailyStatisticsEOMBacklog Else 0
			  End As 'pbb_DailyStatisticsEOMBacklogVATN'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklog'
			 ,'' As 'pbb_DailyStatisticsSheduledBacklogVATNCount'
			 ,'' As 'ExternalResidentialAdds'
			 ,'' As 'ExternalBusinessAdds'
			 ,'' As 'ExternalResidentialDisconnect'
			 ,'' As 'ExternalBusinessDisconnect'
		from FactExternalDailyStatistics_pbb
			join DimExternalMarket_pbb on FactExternalDailyStatistics_pbb.pbb_DimExternalMarketId = DimExternalMarket_pbb.pbb_DimExternalMarketId
			full outer join COL_NAMES cn on DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket = cn.AccountMarket
		Where(Convert(Date,FactExternalDailyStatistics_pbb.pbb_DimDateId) = COnvert(Date,
																	 Case
																		When Datepart(DW,@ReportDate) = 2
																		Then DATEadd(DD,-3,@ReportDate) Else DATEadd(DD,-1,@ReportDate)
																	 End)
			 Or Convert(Date,FactExternalDailyStatistics_pbb.pbb_DimDateId) = COnvert(Date,
																	    Case
																		   When Datepart(DW,@ReportDate) = 2
																		   Then DATEadd(DD,-2,@ReportDate) Else DATEadd(DD,-1,@ReportDate)
																	    End)
			 Or Convert(Date,FactExternalDailyStatistics_pbb.pbb_DimDateId) = COnvert(Date,
																	    Case
																		   When Datepart(DW,@ReportDate) = 2
																		   Then DATEadd(DD,-1,@ReportDate) Else DATEadd(DD,-1,@ReportDate)
																	    End))
		--Where (Year(FactExternalDailyStatistics_pbb.pbb_DimDateId) = Year( @ReportDate) And Month(FactExternalDailyStatistics_pbb.pbb_DimDateId) = Month( @ReportDate)) 
		Union 
		--Internal  Backlog  Total Sch
		Select '' As 'FactSalesOrderId'
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
		from [dbo].[PBB_DB_BACKLOG_TOTAL](@ReportDate)
			full outer join COL_NAMES cn on [Account Market] = cn.AccountMarket
		Group By [Account Group]
			   ,[Account Market]
			   ,pbb_MarketSummary
			   ,Accountclass
			   ,AccountType
		Union All
		--External Backlog Total Sch
		Select '' As 'FactSalesOrderId'
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
		from FactExternalDailyStatistics_pbb
			join DimExternalMarket_pbb on FactExternalDailyStatistics_pbb.pbb_DimExternalMarketId = DimExternalMarket_pbb.pbb_DimExternalMarketId
			full outer join COL_NAMES cn on DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket = cn.AccountMarket
		Where(Convert(Date,FactExternalDailyStatistics_pbb.pbb_DimDateId) = COnvert(Date,
																	 Case
																		When Datepart(DW,@ReportDate) = 2
																		Then DATEadd(DD,-3,@ReportDate) Else DATEadd(DD,-1,@ReportDate)
																	 End)
			 Or Convert(Date,FactExternalDailyStatistics_pbb.pbb_DimDateId) = COnvert(Date,
																	    Case
																		   When Datepart(DW,@ReportDate) = 2
																		   Then DATEadd(DD,-2,@ReportDate) Else DATEadd(DD,-1,@ReportDate)
																	    End)
			 Or Convert(Date,FactExternalDailyStatistics_pbb.pbb_DimDateId) = COnvert(Date,
																	    Case
																		   When Datepart(DW,@ReportDate) = 2
																		   Then DATEadd(DD,-1,@ReportDate) Else DATEadd(DD,-1,@ReportDate)
																	    End)))
		SELECT cn.pbb_MarketSummary
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
			 ,IsNull(data.pbb_DailyStatisticsSheduledBacklog,0) As [pbb_DailyStatisticsSheduledBacklog]
			 ,IsNull(data.pbb_DailyStatisticsSheduledBacklogVATNCount,0) As [pbb_DailyStatisticsSheduledBacklog VATN Count]
			 ,IsNull(data.ExternalResidentialAdds,0) As [External Residential Adds]
			 ,IsNull(data.ExternalBusinessAdds,0) As [External Business Adds]
			 ,IsNull(data.ExternalResidentialDisconnect,0) As [External Residential Disconnect]
			 ,IsNull(data.ExternalBusinessDisconnect,0) AS [External Business Disconnect]
			 ,IsNull(data.pbb_DailyStatisticsEOMBacklogVATN,0) As [pbb_DailyStatistics EOM Backlog VATN]
		FROM COL_Names as cn
			full outer join Data on cn.AccountMarket = data.pbb_AccountMarket
		Where cn.AccountMarket IS NOT NULL)
GO
