USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[FactExternalDailyStatistics_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[FactExternalDailyStatistics_pbb](
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
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
