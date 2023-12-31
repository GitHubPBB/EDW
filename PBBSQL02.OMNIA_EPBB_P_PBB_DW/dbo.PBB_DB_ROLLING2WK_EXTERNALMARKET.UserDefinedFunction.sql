USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_ROLLING2WK_EXTERNALMARKET]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[PBB_DB_ROLLING2WK_EXTERNALMARKET](
			@ReportDate date)
RETURNS TABLE 
AS
RETURN 
(	    
--External Markets Disconnects 
-- DECLARE @ReportDate date = cast(getdate() as date);

		WITH DateList AS ( 
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
		)
		-- SELECT * from DateList
	Select 	   dl.AsOfDate
	   ,dl.DayNum
	   ,dl.DOW
	   ,dl.WeekNum
	   ,FactExternalDailyStatistics_pbb.pbb_DailyStatisticsResidentialAdds + FactExternalDailyStatistics_pbb.pbb_DailyStatisticsCommercialAdds As 'FactSalesOrderId'
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
	    JOIN DateList dl             ON dl.AsOfDate = cast(FactExternalDailyStatistics_pbb.pbb_DimDateId as date)
	Where 1=1
	)
GO
