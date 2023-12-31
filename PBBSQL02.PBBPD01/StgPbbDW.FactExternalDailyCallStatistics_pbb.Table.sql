USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[FactExternalDailyCallStatistics_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[FactExternalDailyCallStatistics_pbb](
	[SourceId] [nvarchar](400) NOT NULL,
	[pbb_DimExternalMarketId] [int] NOT NULL,
	[pbb_DimMonthlyGoalsId] [int] NOT NULL,
	[pbb_DimDateId] [date] NOT NULL,
	[pbb_DailyStatisticsCalls] [int] NOT NULL,
	[pbb_DailyStatisticsAbandonedCalls] [int] NOT NULL,
	[pbb_DailyStatisticsAbanRate] [decimal](18, 0) NOT NULL,
	[pbb_DailyStatisticsAvgHTs] [decimal](18, 0) NOT NULL,
	[pbb_DailyStatisticsMdHTs] [decimal](18, 0) NOT NULL,
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
