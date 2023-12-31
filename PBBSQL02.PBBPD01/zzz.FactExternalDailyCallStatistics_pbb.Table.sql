USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactExternalDailyCallStatistics_pbb]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactExternalDailyCallStatistics_pbb](
	[SourceId] [nvarchar](400) NOT NULL,
	[pbb_DimExternalMarketId] [int] NOT NULL,
	[pbb_DimMonthlyGoalsId] [int] NOT NULL,
	[pbb_DimDateId] [date] NOT NULL,
	[pbb_DailyStatisticsCalls] [int] NOT NULL,
	[pbb_DailyStatisticsAbandonedCalls] [int] NOT NULL,
	[pbb_DailyStatisticsAbanRate] [decimal](18, 3) NOT NULL,
	[pbb_DailyStatisticsAvgHTs] [decimal](18, 3) NOT NULL,
	[pbb_DailyStatisticsMdHTs] [decimal](18, 3) NOT NULL,
 CONSTRAINT [PK_FactExternalDailyCallStatistics_pbb] PRIMARY KEY CLUSTERED 
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
