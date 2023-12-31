USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_SF_DAY_ORIGINAL]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[PBB_DB_SF_DAY_ORIGINAL](
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
	AS (-- Internal Install 
	Select Count(DimSalesOrderId) As 'FactSalesOrderId'
		 ,Case
			 When AccountType = 'Residential'
			 Then Count(DimSalesOrderId) Else 0
		  End As 'InstallResCount'
		 ,Case
			 When AccountType = 'Business'
			 Then Count(DimSalesOrderId) Else 0
		  End As 'InstallBusCount'
		 ,Case
			 When AccountType = 'Residential'
				 And pbb_MarketSummary = '01-Total VA/TN'
			 Then Count(DimSalesOrderId) Else 0
		  End As 'InstallResVATNCount'
		 ,Case
			 When AccountType = 'Business'
				 And pbb_MarketSummary = '01-Total VA/TN'
			 Then Count(DimSalesOrderId) Else 0
		  End As 'InstallBusVATNCount'
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
	from [dbo].[PBB_DB_DAILY_DETAIL](@ReportDate)
		full outer join COL_NAMES cn on pbb_AccountMarket = cn.AccountMarket
	Where SalesOrderType = 'Install'
		 And pbb_OrderActivityType = 'Install'
	Group By AccountGroup
		   ,AccountClass
		   ,pbb_AccountMarket
		   ,SalesOrderType
		   ,AccountType
		   ,pbb_MarketSummary
	Union --Internal Disconnect
	Select Count(DimSalesOrderId) As 'FactSalesOrderId'
		 ,'' As 'InstallResCount'
		 ,'' As 'InstallBusCount'
		 ,'' As 'InstallResVATNCount'
		 ,'' As 'InstallBusVATNCount'
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
	from [dbo].[PBB_DB_DAILY_DETAIL](@ReportDate)
		full outer join COL_NAMES cn on pbb_AccountMarket = cn.AccountMarket
	Where SalesOrderType = 'Disconnect'
		 And pbb_OrderActivityType = 'Disconnect'
	Group By AccountGroup
		   ,AccountClass
		   ,pbb_AccountMarket
		   ,SalesOrderType
		   ,AccountType
		   ,pbb_MarketSummary
	Union --External Markets Install 
	select FactSalesOrderId
		 ,InstallResCount
		 ,InstallBusCount
		 ,InstallResVATNCount
		 ,InstallBusVATNCount
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
		 ,'' As 'InstallBusCount'
		 ,'' As 'InstallResVATNCount'
		 ,'' As 'InstallBusVATNCount'
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
	from PBB_DB_SERVICE_CALLS_DETAIL_REPORT (@ReportDate)
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
		 ,'' As 'InstallBusCount'
		 ,'' As 'InstallResVATNCount'
		 ,'' As 'InstallBusVATN Count'
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
		 ,'' As 'InstallBusCount'
		 ,'' As 'InstallResVATNCount'
		 ,'' As 'InstallBusVATNCount'
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
		 ,'' As 'InstallBusCount'
		 ,'' As 'InstallResVATNCount'
		 ,'' As 'InstallBusVATNCount'
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
		 ,'' As 'InstallBusCount'
		 ,'' As 'InstallResVATNCount'
		 ,'' As 'InstallBusVATNCount'
		 ,'' As 'DisconnectResCount'
		 ,'' As 'DisconnectBusCount'
		 ,'' As 'DisconnectResVATNCount'
		 ,'' As 'DisconnectBusVATNCount'
		 , [Account Group] As AccountGroup
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
	from [dbo].[PBB_DB_BACKLOG_TOTAL] (@ReportDate)
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
		 ,'' As 'InstallBusCount'
		 ,'' As 'InstallResVATNCount'
		 ,'' As 'InstallBusVATNCount'
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
		 ,IsNull(data.InstallBusCount,0) As [Install Bus Count]
		 ,IsNull(data.InstallResVATNCount,0) As [Install Res  VATN Count]
		 ,IsNull(data.InstallBusVATNCount,0) As [Install Bus VATN  Count]
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
	Where cn.AccountMarket IS NOT NULL
) 
GO
