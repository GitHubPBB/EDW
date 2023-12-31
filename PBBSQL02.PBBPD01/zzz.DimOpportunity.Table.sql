USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimOpportunity]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimOpportunity](
	[DimOpportunityId] [int] IDENTITY(1,1) NOT NULL,
	[OpportunityId] [nvarchar](400) NOT NULL,
	[OpportunityName] [nvarchar](300) NOT NULL,
	[OpportunityCustomerName] [nvarchar](4000) NOT NULL,
	[OpportunityRevenue] [nvarchar](256) NOT NULL,
	[OpportunityEstimatedCloseDate] [datetime] NULL,
	[OpportunityCloseProbability] [int] NOT NULL,
	[OpportunityRatingCode] [nvarchar](256) NOT NULL,
	[OpportunityChannel] [nvarchar](256) NOT NULL,
	[OpportunitySegment] [nvarchar](1000) NOT NULL,
	[OpportunityProvisioningDate] [datetime] NULL,
	[OpportunityOrderType] [nvarchar](256) NOT NULL,
	[OpportunityBillingDate] [datetime] NULL,
	[OpportunityPriorityCode] [nvarchar](256) NOT NULL,
	[OpportunityProject] [nvarchar](80) NOT NULL,
	[OpportunityProjectManager] [nvarchar](200) NOT NULL,
	[OpportunitySalesEngineer] [nvarchar](200) NOT NULL,
	[OpportunityStatusReason] [nvarchar](256) NOT NULL,
	[OpportunityStatus] [nvarchar](256) NOT NULL,
	[OpportunityOwner] [nvarchar](200) NOT NULL,
	[OpportunityPipelinePhase] [nvarchar](200) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimOpportunityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[OpportunityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
