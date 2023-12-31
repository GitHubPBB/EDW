USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactExternalDailyStatistics_pbb_old]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactExternalDailyStatistics_pbb_old](
	[pbb_FactExternalDailyStatisticsId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [nvarchar](400) NOT NULL,
	[pbb_DimExternalMarketId] [int] NOT NULL,
	[pbb_DimDateId] [date] NOT NULL,
	[pbb_DailyStatisticsResidentialAdds] [int] NOT NULL,
	[pbb_DailyStatisticsCommercialAdds] [int] NOT NULL,
	[pbb_DailyStatisticsResidentialDisconnects] [int] NOT NULL,
	[pbb_DailyStatisticsCommercialDisconnects] [int] NOT NULL,
	[pbb_DailyStatisticsSmarthome] [int] NOT NULL,
	[pbb_DailyStatisticsAbandonedCalls] [int] NOT NULL,
	[pbb_DailyStatisticsAvgHTs] [int] NOT NULL,
	[pbb_DailyStatisticsCalls] [int] NOT NULL,
	[pbb_DailyStatisticsMdHTs] [int] NOT NULL,
	[pbb_DailyStatisticsServiceCalls] [int] NOT NULL,
	[pbb_DailyStatisticsAbanRate] [int] NOT NULL,
	[pbb_DailyStatisticsEOMBacklog] [int] NOT NULL,
	[pbb_DailyStatisticsSheduledBacklog] [int] NOT NULL,
	[pbb_DailyStatisticsTRTCPending48Hours] [int] NOT NULL,
	[pbb_DailyStatisticsTRTCPendingGT48Hours] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[pbb_FactExternalDailyStatisticsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
