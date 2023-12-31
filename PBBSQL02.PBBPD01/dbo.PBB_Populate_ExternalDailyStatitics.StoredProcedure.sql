USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_ExternalDailyStatitics]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE procedure [dbo].[PBB_Populate_ExternalDailyStatitics]
as
    begin

	   set nocount on;

	   truncate table [OMNIA_EPBB_P_PBB_DW].[dbo].[FactExternalDailyStatistics_pbb];
	   truncate table [OMNIA_EPBB_P_PBB_DW].[dbo].[FactExternalDailyCallStatistics_pbb];

	   insert into [OMNIA_EPBB_P_PBB_DW].[dbo].[FactExternalDailyStatistics_pbb]
			select [cus_externaldailystatisticsId] as [SourceId]
				 ,mb.[pbb_DimExternalMarketId] as [pbb_DimExternalMarketId]
				 ,mg.[pbb_DimMonthlyGoalsId]
				 ,[cus_Date] as [pbb_DimDateId]
				 ,[cus_ResidentialAdds] as [pbb_DailyStatisticsResidentialAdds]
				 ,[cus_CommercialAdds] as [pbb_DailyStatisticsCommercialAdds]
				 ,[cus_ResidentialDisconnects] as [pbb_DailyStatisticsResidentialDisconnects]
				 ,[cus_CommercialDisconnects] as [pbb_DailyStatisticsCommercialDisconnects]
				 ,[cus_SmartHome] as [pbb_DailyStatisticsSmarthome]
				 ,[cus_ServiceCalls] as [pbb_DailyStatisticsServiceCalls]
				 ,[cus_InstallBacklogThroughOEM] as [pbb_DailyStatisticsEOMBacklog]
				 ,[cus_InstallBacklogTotalScheduled] as [pbb_DailyStatisticsSheduledBacklog]
				 ,[cus_TRTCPending48Hours] as [pbb_DailyStatisticsTRTCPending48Hours]
				 ,[cus_TRTCPendinggt48Hours] as [pbb_DailyStatisticsTRTCPendingGT48Hours]
				  --,[cus_CompletedTRTC] as [pbb_DailyStatisticsCompletedTRTC]
				 ,[cus_ServiceCalls] as [pbb_DailyStatisticsCompletedTRTC]
			from [PBBSQL01].[PBB_P_MSCRM].[dbo].[cus_externaldailystatisticsBase] edsb
				left join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimExternalMarket_pbb] mb on mb.SourceId = edsb.cus_Market
				left join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimMonthlyGoals_pbb] mg on mg.[pbb_MarketSummary] = mb.[pbb_ExternalMarketName]
																	 and convert(date,edsb.cus_Date) >= mg.[pbb_MonthlyGoalBeginningDate_DimDateID]
																	 and convert(date,edsb.cus_Date) <= mg.[pbb_MonthlyGoalEndDate_DimDateID];

	   declare @dailyStats     int
			,@dailyCallStats int

	   insert into [OMNIA_EPBB_P_PBB_DW].[dbo].[FactExternalDailyCallStatistics_pbb]
			select [cus_externalmarketstatsId] as [SourceId]
				 ,mb.[pbb_DimExternalMarketId] as [pbb_DimExternalMarketId]
				 ,''
				 ,[cus_Date] as [pbb_DimDateId]
				 ,isnull([cus_Calls],0) as [pbb_DailyStatisticsCalls]
				 ,isnull([cus_AbandonedCalls],0) as [pbb_DailyStatisticsAbandonedCalls]
				 ,isnull([cus_AbanRate],0) as [pbb_DailyStatisticsAbanRate]
				 ,isnull([cus_AvgHTs2],0) as [pbb_DailyStatisticsAvgHTs]
				 ,isnull([cus_MdHTs2],0) as [pbb_DailyStatisticsMdHTs]
			from [PBBSQL01].[PBB_P_MSCRM].[dbo].[cus_externalmarketstatsBase] edsb
				left join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimExternalMarket_pbb] mb on mb.SourceId = edsb.cus_Market
			order by pbb_DimDateId;

	   select @dailyStats = count(*)
	   from [OMNIA_EPBB_P_PBB_DW].[dbo].[FactExternalDailyStatistics_pbb];

	   select @dailyCallStats = count(*)
	   from [PBBSQL01].[PBB_P_MSCRM].[dbo].[cus_externalmarketstatsBase];

	   select 'External Market data loaded' as [Result]
		    ,@dailyStats as [DailyStats]
		    ,@dailyCallStats as [DailyCallStats];
    end
GO
