USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_PERIOD_DETAIL_EXTERNALMARKET]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PBB_DB_PERIOD_DETAIL_EXTERNALMARKET](
			 @StartDate date
			,@EndDate   date
											    )
RETURNS TABLE
AS
	RETURN
		  (	  
			 --External Markets
			 Select FactExternalDailyStatistics_pbb.pbb_DailyStatisticsResidentialAdds + FactExternalDailyStatistics_pbb.pbb_DailyStatisticsCommercialAdds As 'Install'
				  ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsResidentialDisconnects + FactExternalDailyStatistics_pbb.pbb_DailyStatisticsCommercialDisconnects As 'Disconnect'
				  ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsResidentialAdds As 'InstallResCount'
				  ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsCommercialAdds As 'InstallBusCount'
				  ,Case
					  When DimExternalMarket_pbb.pbb_externalMarketAccountGroupMarketSummary Like '%VATN%'
					  Then FactExternalDailyStatistics_pbb.pbb_DailyStatisticsResidentialAdds Else 0
				   End As 'InstallResVATNCount'
				  ,Case
					  When DimExternalMarket_pbb.pbb_externalMarketAccountGroupMarketSummary Like '%VATN%'
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
				  ,FactExternalDailyStatistics_pbb.pbb_DimDateId As 'CreatedOn_DimDateId'
				  ,FactExternalDailyStatistics_pbb.pbb_DimMonthlyGoalsId As pbb_DimMonthlyGoalsId
			 from FactExternalDailyStatistics_pbb
				 join DimExternalMarket_pbb on FactExternalDailyStatistics_pbb.pbb_DimExternalMarketId = DimExternalMarket_pbb.pbb_DimExternalMarketId
			 Where cast(FactExternalDailyStatistics_pbb.pbb_DimDateId as date) < @EndDate
				  and cast(FactExternalDailyStatistics_pbb.pbb_DimDateId as date) >= @StartDate
		  )
GO
