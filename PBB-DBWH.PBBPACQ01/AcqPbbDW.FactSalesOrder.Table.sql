USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[FactSalesOrder]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[FactSalesOrder](
	[FactSalesOrderId] [int] NOT NULL,
	[SalesOrderId] [nvarchar](400) NOT NULL,
	[DimSalesOrderId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[Partner_DimAccountId] [int] NOT NULL,
	[CreatedBy_DimContactId] [int] NOT NULL,
	[Partner_DimContactId] [int] NOT NULL,
	[ModifiedBy_DimContactId] [int] NOT NULL,
	[DimOpportunityId] [int] NOT NULL,
	[DimQuoteId] [int] NOT NULL,
	[Source_DimCampaignId] [int] NOT NULL,
	[CreatedOn_DimDateId] [date] NOT NULL,
	[ProvisioningDate_DimDateId] [date] NOT NULL,
	[CommitmentDate_DimDateId] [date] NOT NULL,
	[OrderClosed_DimDateId] [date] NOT NULL,
	[SalesOrderTotalLineItemAmount] [money] NOT NULL,
	[SalesOrderTotalTax] [money] NOT NULL,
	[SalesOrderTotalAmount] [money] NOT NULL,
	[SalesOrderTotalMRC] [money] NOT NULL,
	[SalesOrderTotalNRC] [money] NOT NULL,
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
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [DimSalesOrderId]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [DimAccountId]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [DimAccountCategoryId]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [Partner_DimAccountId]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [CreatedBy_DimContactId]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [Partner_DimContactId]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [ModifiedBy_DimContactId]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [DimOpportunityId]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [DimQuoteId]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [Source_DimCampaignId]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ('1900-01-01') FOR [CreatedOn_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ('1900-01-01') FOR [ProvisioningDate_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ('1900-01-01') FOR [CommitmentDate_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ('1900-01-01') FOR [OrderClosed_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [SalesOrderTotalLineItemAmount]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [SalesOrderTotalTax]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [SalesOrderTotalAmount]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [SalesOrderTotalMRC]
GO
ALTER TABLE [AcqPbbDW].[FactSalesOrder] ADD  DEFAULT ((0)) FOR [SalesOrderTotalNRC]
GO
