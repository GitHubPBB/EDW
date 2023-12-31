USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimSalesOrderLineItem]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimSalesOrderLineItem](
	[DimSalesOrderLineItemId] [int] NOT NULL,
	[OCComponent_ID] [int] NOT NULL,
	[SalesOrderLineItemName] [nvarchar](max) NOT NULL,
	[SalesOrderLineItemIsFractionalWaived] [bit] NOT NULL,
	[SalesOrderLineItemIsChargeWaived] [bit] NOT NULL,
	[SalesOrderLineItemIsCommisionable] [bit] NOT NULL,
	[SalesOrderLineItemIsService] [bit] NOT NULL,
	[SalesOrderLineItemServiceIdentifier] [nvarchar](max) NOT NULL,
	[SalesOrderLineItemInstallDate] [datetime] NULL,
	[SalesOrderLineItemProvisioningDate] [datetime] NULL,
	[SalesOrderLineItemBillingEffectiveDate] [datetime] NULL,
	[SalesOrderLineItemActivity] [varchar](max) NOT NULL,
	[SalesOrderLineItemMinQty] [int] NOT NULL,
	[SalesOrderLineItemMaxQty] [int] NOT NULL,
	[SalesOrderLineItemPaymentStatus] [tinyint] NOT NULL,
	[SalesOrderLineItemPaidThruDate] [datetime] NULL,
	[SalesOrderLineItemAPR] [decimal](18, 0) NOT NULL,
	[SalesOrderLineItemBillingMethod] [char](1) NOT NULL,
	[SalesOrderLineItemPrepaidPeriods] [int] NOT NULL,
	[SalesOrderLineItemCollectionMethod] [char](1) NOT NULL,
	[SalesOrderLineItemAgents] [nvarchar](1000) NOT NULL,
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ('') FOR [SalesOrderLineItemName]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemIsFractionalWaived]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemIsChargeWaived]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemIsCommisionable]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemIsService]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ('') FOR [SalesOrderLineItemServiceIdentifier]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ('') FOR [SalesOrderLineItemActivity]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemMinQty]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemMaxQty]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemPaymentStatus]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemAPR]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ('') FOR [SalesOrderLineItemBillingMethod]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemPrepaidPeriods]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ('') FOR [SalesOrderLineItemCollectionMethod]
GO
ALTER TABLE [StgPbbDW].[DimSalesOrderLineItem] ADD  DEFAULT ('') FOR [SalesOrderLineItemAgents]
GO
