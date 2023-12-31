USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimGoal]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimGoal](
	[DimGoalId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [nvarchar](400) NOT NULL,
	[GoalName] [nvarchar](100) NOT NULL,
	[GoalOwner] [nvarchar](200) NOT NULL,
	[GoalMetric] [nvarchar](100) NOT NULL,
	[GoalManager] [nvarchar](200) NOT NULL,
	[GoalPeriodType] [nvarchar](50) NOT NULL,
	[GoalFiscalPeriod] [nvarchar](50) NOT NULL,
	[GoalFiscalYear] [int] NOT NULL,
	[GoalStartDate] [date] NULL,
	[GoalEndDate] [date] NULL,
	[GoalTarget] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimGoalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
