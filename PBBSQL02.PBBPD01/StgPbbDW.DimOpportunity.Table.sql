USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimOpportunity]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimOpportunity](
	[DimOpportunityId] [int] NOT NULL,
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
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunityName]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunityCustomerName]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunityRevenue]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ((0)) FOR [OpportunityCloseProbability]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunityRatingCode]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunityChannel]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunitySegment]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunityOrderType]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunityPriorityCode]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunityProject]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunityProjectManager]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunitySalesEngineer]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunityStatusReason]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunityStatus]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunityOwner]
GO
ALTER TABLE [StgPbbDW].[DimOpportunity] ADD  DEFAULT ('') FOR [OpportunityPipelinePhase]
GO
