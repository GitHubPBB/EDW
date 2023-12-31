USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactExternalDailyStatistics_pbb]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactExternalDailyStatistics_pbb](
	[SourceId] [uniqueidentifier] NOT NULL,
	[pbb_DimExternalMarketId] [int] NULL,
	[pbb_DimMonthlyGoalsId] [int] NULL,
	[pbb_DimDateId] [datetime] NULL,
	[pbb_DailyStatisticsResidentialAdds] [int] NULL,
	[pbb_DailyStatisticsCommercialAdds] [int] NULL,
	[pbb_DailyStatisticsResidentialDisconnects] [int] NULL,
	[pbb_DailyStatisticsCommercialDisconnects] [int] NULL,
	[pbb_DailyStatisticsSmarthome] [int] NULL,
	[pbb_DailyStatisticsServiceCalls] [int] NULL,
	[pbb_DailyStatisticsEOMBacklog] [int] NULL,
	[pbb_DailyStatisticsSheduledBacklog] [int] NULL,
	[pbb_DailyStatisticsTRTCPending48Hours] [int] NULL,
	[pbb_DailyStatisticsTRTCPendingGT48Hours] [int] NULL,
	[pbb_DailyStatisticsCompletedTRTC] [int] NULL,
 CONSTRAINT [PK_FactExternalDailyStatistics_pbb] PRIMARY KEY CLUSTERED 
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
