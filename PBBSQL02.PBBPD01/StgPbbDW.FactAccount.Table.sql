USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[FactAccount]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[FactAccount](
	[FactAccountId] [int] NOT NULL,
	[AccountId] [uniqueidentifier] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[Parent_DimAccountId] [int] NOT NULL,
	[DimMembershipId] [int] NOT NULL,
	[BilledBalanceTotal] [money] NOT NULL,
	[BilledBalanceWriteOff] [money] NOT NULL,
	[BilledBalanceInterest] [money] NOT NULL,
	[BilledBalanceUnapplied] [money] NOT NULL,
	[BilledBalanceCurrent] [money] NOT NULL,
	[BilledBalanceThirty] [money] NOT NULL,
	[BilledBalanceSixty] [money] NOT NULL,
	[BilledBalanceNinety] [money] NOT NULL,
	[BilledBalanceOneTwenty] [money] NOT NULL,
	[BilledBalanceOneFifty] [money] NOT NULL,
	[BilledBalanceOneEighty] [money] NOT NULL,
	[AdjustmentsTotal] [money] NOT NULL,
	[AdjustmentsWriteOff] [money] NOT NULL,
	[AdjustmentsInterest] [money] NOT NULL,
	[AdjustmentsUnapplied] [money] NOT NULL,
	[AdjustmentsCurrent] [money] NOT NULL,
	[AdjustmentsThirty] [money] NOT NULL,
	[AdjustmentsSixty] [money] NOT NULL,
	[AdjustmentsNinety] [money] NOT NULL,
	[AdjustmentsOneTwenty] [money] NOT NULL,
	[AdjustmentsOneFifty] [money] NOT NULL,
	[AdjustmentsOneEighty] [money] NOT NULL,
	[OpenBalanceTotal] [money] NOT NULL,
	[OpenBalanceWriteOff] [money] NOT NULL,
	[OpenBalanceInterest] [money] NOT NULL,
	[OpenBalanceUnapplied] [money] NOT NULL,
	[OpenBalanceCurrent] [money] NOT NULL,
	[OpenBalanceThirty] [money] NOT NULL,
	[OpenBalanceSixty] [money] NOT NULL,
	[OpenBalanceNinety] [money] NOT NULL,
	[OpenBalanceOneTwenty] [money] NOT NULL,
	[OpenBalanceOneFifty] [money] NOT NULL,
	[OpenBalanceOneEighty] [money] NOT NULL,
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
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [DimAccountId]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [Parent_DimAccountId]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [DimMembershipId]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [BilledBalanceTotal]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [BilledBalanceWriteOff]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [BilledBalanceInterest]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [BilledBalanceUnapplied]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [BilledBalanceCurrent]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [BilledBalanceThirty]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [BilledBalanceSixty]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [BilledBalanceNinety]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [BilledBalanceOneTwenty]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [BilledBalanceOneFifty]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [BilledBalanceOneEighty]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [AdjustmentsTotal]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [AdjustmentsWriteOff]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [AdjustmentsInterest]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [AdjustmentsUnapplied]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [AdjustmentsCurrent]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [AdjustmentsThirty]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [AdjustmentsSixty]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [AdjustmentsNinety]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [AdjustmentsOneTwenty]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [AdjustmentsOneFifty]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [AdjustmentsOneEighty]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [OpenBalanceTotal]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [OpenBalanceWriteOff]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [OpenBalanceInterest]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [OpenBalanceUnapplied]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [OpenBalanceCurrent]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [OpenBalanceThirty]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [OpenBalanceSixty]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [OpenBalanceNinety]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [OpenBalanceOneTwenty]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [OpenBalanceOneFifty]
GO
ALTER TABLE [StgPbbDW].[FactAccount] ADD  DEFAULT ((0)) FOR [OpenBalanceOneEighty]
GO
