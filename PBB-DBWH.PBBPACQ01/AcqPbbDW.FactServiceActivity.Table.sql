USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[FactServiceActivity]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[FactServiceActivity](
	[FactServiceActivityId] [int] NOT NULL,
	[ActivityId] [uniqueidentifier] NOT NULL,
	[DimServiceActivityId] [int] NOT NULL,
	[DimCaseId] [int] NOT NULL,
	[DimSalesOrderId] [int] NOT NULL,
	[DimOpportunityId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimLeadId] [int] NOT NULL,
	[DimQuoteId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
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
ALTER TABLE [AcqPbbDW].[FactServiceActivity] ADD  DEFAULT ((0)) FOR [DimServiceActivityId]
GO
ALTER TABLE [AcqPbbDW].[FactServiceActivity] ADD  DEFAULT ((0)) FOR [DimCaseId]
GO
ALTER TABLE [AcqPbbDW].[FactServiceActivity] ADD  DEFAULT ((0)) FOR [DimSalesOrderId]
GO
ALTER TABLE [AcqPbbDW].[FactServiceActivity] ADD  DEFAULT ((0)) FOR [DimOpportunityId]
GO
ALTER TABLE [AcqPbbDW].[FactServiceActivity] ADD  DEFAULT ((0)) FOR [DimAccountId]
GO
ALTER TABLE [AcqPbbDW].[FactServiceActivity] ADD  DEFAULT ((0)) FOR [DimAccountCategoryId]
GO
ALTER TABLE [AcqPbbDW].[FactServiceActivity] ADD  DEFAULT ((0)) FOR [DimLeadId]
GO
ALTER TABLE [AcqPbbDW].[FactServiceActivity] ADD  DEFAULT ((0)) FOR [DimQuoteId]
GO
ALTER TABLE [AcqPbbDW].[FactServiceActivity] ADD  DEFAULT ((0)) FOR [DimServiceLocationId]
GO
ALTER TABLE [AcqPbbDW].[FactServiceActivity] ADD  DEFAULT ((0)) FOR [DimFMAddressId]
GO
