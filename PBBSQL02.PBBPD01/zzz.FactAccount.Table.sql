USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactAccount]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactAccount](
	[FactAccountId] [int] IDENTITY(1,1) NOT NULL,
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
PRIMARY KEY CLUSTERED 
(
	[FactAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
