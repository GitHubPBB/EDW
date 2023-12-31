USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[FactSalesOrderLineItem]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[FactSalesOrderLineItem](
	[FactSalesOrderLineItemId] [int] NOT NULL,
	[OCComponent_ID] [int] NOT NULL,
	[DimSalesOrderLineItemId] [int] NOT NULL,
	[DimSalesOrderId] [int] NOT NULL,
	[DimOpportunityId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[Parent_DimCustomerItemId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[Old_DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[Old_DimFMAddressId] [int] NOT NULL,
	[DimCatalogItemId] [int] NOT NULL,
	[Parent_DimCatalogItemId] [int] NOT NULL,
	[CreatedOn_DimDateId] [date] NOT NULL,
	[InstallDate_DimDateId] [date] NOT NULL,
	[ProvisioningDate_DimDateId] [date] NOT NULL,
	[BillingEffectiveDate_DimDateId] [date] NOT NULL,
	[OrderClosed_DimDateId] [date] NOT NULL,
	[SalesOrderLineItemQuantity] [int] NOT NULL,
	[SalesOrderLineItemAmountPaid] [decimal](15, 2) NOT NULL,
	[SalesOrderLineItemOldQuantity] [int] NOT NULL,
	[SalesOrderLineItemOldPrice] [decimal](15, 7) NOT NULL,
	[SalesOrderLineItemDownPaymentAmount] [decimal](15, 2) NOT NULL,
	[SalesOrderLineItemPurchaseAmount] [decimal](15, 2) NOT NULL,
	[SalesOrderLineItemTotalCostOfLoan] [decimal](15, 2) NOT NULL,
	[SalesOrderLineItemTaxCollected] [decimal](15, 2) NOT NULL,
	[SalesOrderLineItemLoanAmount] [decimal](15, 2) NOT NULL,
	[SalesOrderLineItemManualDiscountAmount] [money] NOT NULL,
	[SalesOrderLineItemVolumeDiscountAmount] [money] NOT NULL,
	[SalesOrderLineItemPricePerUnit] [money] NOT NULL,
	[SalesOrderLineItemBaseAmount] [money] NOT NULL,
	[SalesOrderLineItemExtendedAmount] [money] NOT NULL,
	[SalesOrderLineItemTax] [money] NOT NULL,
	[SalesOrderLineItemPrice] [decimal](10, 2) NOT NULL,
	[DimCatalogPriceId] [int] NOT NULL,
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
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [DimSalesOrderLineItemId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [DimSalesOrderId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [DimOpportunityId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [DimCustomerItemId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [Parent_DimCustomerItemId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [DimAccountId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [DimAccountCategoryId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [DimServiceLocationId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [Old_DimServiceLocationId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [DimFMAddressId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [Old_DimFMAddressId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [DimCatalogItemId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [Parent_DimCatalogItemId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ('1900-01-01') FOR [CreatedOn_DimDateId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ('1900-01-01') FOR [InstallDate_DimDateId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ('1900-01-01') FOR [ProvisioningDate_DimDateId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ('1900-01-01') FOR [BillingEffectiveDate_DimDateId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ('1900-01-01') FOR [OrderClosed_DimDateId]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemQuantity]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemAmountPaid]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemOldQuantity]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemOldPrice]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemDownPaymentAmount]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemPurchaseAmount]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemTotalCostOfLoan]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemTaxCollected]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemLoanAmount]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemManualDiscountAmount]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemVolumeDiscountAmount]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemPricePerUnit]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemBaseAmount]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemExtendedAmount]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemTax]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [SalesOrderLineItemPrice]
GO
ALTER TABLE [StgPbbDW].[FactSalesOrderLineItem] ADD  DEFAULT ((0)) FOR [DimCatalogPriceId]
GO
