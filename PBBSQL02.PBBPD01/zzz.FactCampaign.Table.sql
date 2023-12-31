USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactCampaign]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactCampaign](
	[FactCampaignId] [int] IDENTITY(1,1) NOT NULL,
	[CampaignId] [uniqueidentifier] NOT NULL,
	[DimCampaignId] [int] NOT NULL,
	[ProposedEnd_DimDateId] [date] NOT NULL,
	[ProposedStart_DimDateId] [date] NOT NULL,
	[ActualStart_DimDateId] [date] NOT NULL,
	[ActualEnd_DimDateId] [date] NOT NULL,
	[CampaignBudgetAllocated] [money] NOT NULL,
	[CampaignMiscellaneousCost] [money] NOT NULL,
	[CampaignTotalCost] [money] NOT NULL,
	[CampaignEstimatedRevenue] [money] NOT NULL,
	[CampaignTotalCostOfActivities] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactCampaignId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
