USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[FactProjectPenetration]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactProjectPenetration](
	[FactProjectPenetrationId] [int] NOT NULL,
	[DimProjectId] [smallint] NOT NULL,
	[DimMarketId] [smallint] NOT NULL,
	[DimDate] [date] NOT NULL,
	[ProjectAgeMonths] [smallint] NULL,
	[CompetitiveAddressCount] [smallint] NULL,
	[UnderservedAddressCount] [smallint] NULL,
	[ServiceableAddressCount] [smallint] NULL,
	[ActiveCompetitiveRESCount] [smallint] NULL,
	[ActiveCompetitiveBUSCount] [smallint] NULL,
	[ActiveCompetitiveCustomerCount] [smallint] NULL,
	[ActiveUnderServedRESCount] [smallint] NULL,
	[ActiveUnderServedBUSCount] [smallint] NULL,
	[ActiveUnderservedCustomerCount] [smallint] NULL,
	[ActiveTotalCustomerCount] [smallint] NULL,
	[CurrentMonthBilledAvgMRC] [decimal](12, 2) NULL,
	[CompetitivePenetration] [decimal](6, 2) NULL,
	[UnderservedPenetration] [decimal](6, 2) NULL,
	[TotalPenetration] [decimal](6, 2) NULL,
	[GrowthGoalCompetitiveColor] [varchar](10) NULL,
	[GrowthGoalUnderServedColor] [varchar](10) NULL,
	[GrowthGoalTotalColor] [varchar](10) NULL,
	[GrowthRampRedGoalPct] [decimal](6, 2) NULL,
	[GrowthRampGreenGoalPct] [decimal](6, 2) NULL,
	[ConnectCount] [smallint] NULL,
	[disconnectCount] [smallint] NULL,
	[GetToGreenCustomerCount] [smallint] NULL,
	[CustomerType] [varchar](20) NULL,
	[AccountType] [varchar](20) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactProjectPenetration] ADD  DEFAULT ('White') FOR [GrowthGoalCompetitiveColor]
GO
ALTER TABLE [dbo].[FactProjectPenetration] ADD  DEFAULT ('White') FOR [GrowthGoalUnderServedColor]
GO
ALTER TABLE [dbo].[FactProjectPenetration] ADD  DEFAULT ('White') FOR [GrowthGoalTotalColor]
GO
ALTER TABLE [dbo].[FactProjectPenetration] ADD  DEFAULT ((0)) FOR [GetToGreenCustomerCount]
GO
