USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_DAILY_DETAIL_EXTERNALMARKET]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[PBB_DB_DAILY_DETAIL_EXTERNALMARKET](
			@ReportDate date)
RETURNS TABLE 
AS
RETURN 
	    
--External Markets Disconnects 

	Select FactExternalDailyStatistics_pbb.pbb_DailyStatisticsResidentialAdds + FactExternalDailyStatistics_pbb.pbb_DailyStatisticsCommercialAdds As 'FactSalesOrderId'
		 ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsResidentialAdds As 'InstallResCount'
		 ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsCommercialAdds As 'InstallBusCount'
		 ,Case
			 When DimExternalMarket_pbb.pbb_externalMarketAccountGroupMarketSummary = '01-Total VA/TN'
			 Then FactExternalDailyStatistics_pbb.pbb_DailyStatisticsResidentialAdds Else 0
		  End As 'InstallResVATNCount'
		 ,Case
			 When DimExternalMarket_pbb.pbb_externalMarketAccountGroupMarketSummary = '01-Total VA/TN'
			 Then FactExternalDailyStatistics_pbb.pbb_DailyStatisticsCommercialAdds Else 0
		  End As 'InstallBusVATNCount'
		 ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsResidentialDisconnects As 'DisconnectResCount'
		 ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsCommercialDisconnects As 'DisconnectBusCount'
		 ,Case
			 When DimExternalMarket_pbb.pbb_externalMarketAccountGroupMarketSummary Like '%VATN%'
			 Then FactExternalDailyStatistics_pbb.pbb_DailyStatisticsResidentialDisconnects Else 0
		  End As 'DisconnectResVATNCount'
		 ,Case
			 When DimExternalMarket_pbb.pbb_externalMarketAccountGroupMarketSummary Like '%VATN%'
			 Then FactExternalDailyStatistics_pbb.pbb_DailyStatisticsCommercialDisconnects Else 0
		  End As 'DisconnectBusVATNCount'
		 ,'' As 'AccountGroup'
		 ,'' As 'AccountClass'
		 ,DimExternalMarket_pbb.pbb_ExternalMarketAccountGroupMarket As 'pbb_AccountMarket'
		 ,'' As 'VATN'
		 ,DimExternalMarket_pbb.pbb_externalMarketAccountGroupMarketSummary As 'VATNGroup'
		 ,'' As 'SalesOrderType'
		 ,'' As 'AccountType'
		 ,'' AS ServiceCallsCount
		 ,'' As 'ServiceCallsCountVATN'
		 ,'' As 'pbb_DailyStatisticsEOMBacklog'
		 ,'' As 'pbb_DailyStatisticsEOMBacklogVATN'
		 ,'' As 'pbb_DailyStatisticsSheduledBacklog'
		 ,'' As 'pbb_DailyStatisticsSheduledBacklogVATNCount'
		 ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsResidentialAdds As 'ExternalResidentialAdds'
		 ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsCommercialAdds As 'ExternalBusinessAdds'
		 ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsResidentialDisconnects As 'ExternalResidentialDisconnect'
		 ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsCommercialDisconnects As 'ExternalBusinessDisconnect'
		  ,FactExternalDailyStatistics_pbb.pbb_DimDateId As 'CreatedOn_DimDateId'
	from FactExternalDailyStatistics_pbb
		join DimExternalMarket_pbb on FactExternalDailyStatistics_pbb.pbb_DimExternalMarketId = DimExternalMarket_pbb.pbb_DimExternalMarketId
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
GO
