USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimMonthlyGoals_pbb]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimMonthlyGoals_pbb](
	[pbb_DimMonthlyGoalsId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [nvarchar](400) NOT NULL,
	[pbb_MarketSummary] [nvarchar](100) NOT NULL,
	[pbb_MonthlyGoalBeginningDate_DimDateID] [date] NULL,
	[pbb_MonthlyGoalEndDate_DimDateID] [date] NULL,
	[pbb_MonthlyGoalTargetAdd] [int] NOT NULL,
	[pbb_MonthlyGoalTargetDisconnect] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[pbb_DimMonthlyGoalsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
