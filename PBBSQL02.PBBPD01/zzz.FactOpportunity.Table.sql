USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactOpportunity]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactOpportunity](
	[FactOpportunityId] [int] IDENTITY(1,1) NOT NULL,
	[OpportunityId] [uniqueidentifier] NOT NULL,
	[DimOpportunityId] [int] NOT NULL,
	[Partner_DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[Partner_CreatedBy_DimContactId] [int] NOT NULL,
	[Partner_DimContactId] [int] NOT NULL,
	[Partner_ModifiedBy_DimContactId] [int] NOT NULL,
	[Originating_DimLeadId] [int] NOT NULL,
	[DimCampaignId] [int] NOT NULL,
	[OpportunityTotalTax] [money] NOT NULL,
	[OpportunityTotalLineItemAmount] [money] NOT NULL,
	[OpportunityTotalAmount] [money] NOT NULL,
	[OpportunityEstimatedRevenue] [money] NOT NULL,
	[OpportunityTotalMRC] [money] NOT NULL,
	[OpportunityTotalNRC] [money] NOT NULL,
	[OpportunityActualValue] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactOpportunityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
