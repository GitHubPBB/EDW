USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[DimMonthlyGoals_pbb]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[DimMonthlyGoals_pbb](
	[pbb_DimMonthlyGoalsId] [int] NOT NULL,
	[SourceId] [nvarchar](400) NOT NULL,
	[pbb_MarketSummary] [nvarchar](100) NOT NULL,
	[pbb_MonthlyGoalBeginningDate_DimDateID] [date] NULL,
	[pbb_MonthlyGoalEndDate_DimDateID] [date] NULL,
	[pbb_MonthlyGoalTargetAdd] [int] NOT NULL,
	[pbb_MonthlyGoalTargetDisconnect] [int] NOT NULL,
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaCurrentRecordIndicator] [varchar](1) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [AcqPbbDW].[DimMonthlyGoals_pbb] ADD  DEFAULT ('') FOR [pbb_MarketSummary]
GO
ALTER TABLE [AcqPbbDW].[DimMonthlyGoals_pbb] ADD  DEFAULT ((0)) FOR [pbb_MonthlyGoalTargetAdd]
GO
ALTER TABLE [AcqPbbDW].[DimMonthlyGoals_pbb] ADD  DEFAULT ((0)) FOR [pbb_MonthlyGoalTargetDisconnect]
GO
