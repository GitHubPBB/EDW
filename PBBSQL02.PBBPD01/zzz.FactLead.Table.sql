USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactLead]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactLead](
	[FactLeadId] [int] IDENTITY(1,1) NOT NULL,
	[LeadId] [uniqueidentifier] NOT NULL,
	[CreatedOn_DimDateId] [date] NOT NULL,
	[DimLeadId] [int] NOT NULL,
	[DimCampaignId] [int] NOT NULL,
	[DimOpportunityId] [int] NOT NULL,
	[Partner_DimAccountId] [int] NOT NULL,
	[Partner_DimAccountCategoryId] [int] NOT NULL,
	[Partner_DimContactId] [int] NOT NULL,
	[CreatedBy_DimContactId] [int] NOT NULL,
	[ModifiedBy_DimContactId] [int] NOT NULL,
	[EstimatedClose_DimDateId] [date] NOT NULL,
	[LeadEstimatedValue] [float] NOT NULL,
	[LeadAnnualRevenue] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactLeadId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
