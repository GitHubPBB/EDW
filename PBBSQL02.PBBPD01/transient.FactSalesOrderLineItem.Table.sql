USE [PBBPDW01]
GO
/****** Object:  Table [transient].[FactSalesOrderLineItem]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[FactSalesOrderLineItem](
	[FactSalesOrderLineItemId] [int] NULL,
	[OCComponent_ID] [int] NOT NULL,
	[DimSalesOrderLineItemId] [int] NOT NULL,
	[DimSalesOrderId] [uniqueidentifier] NULL,
	[DimOpportunityId] [uniqueidentifier] NULL,
	[DimCustomerItemId] [int] NULL,
	[Parent_DimCustomerItemId] [int] NULL,
	[DimAccountId] [uniqueidentifier] NULL,
	[DimAccountCategoryId] [nvarchar](203) NOT NULL,
	[DimServiceLocationId] [int] NULL,
	[Old_DimServiceLocationId] [int] NULL,
	[DimFMAddressId] [int] NULL,
	[Old_DimFMAddressId] [int] NULL,
	[DimCatalogItemId] [int] NOT NULL,
	[Parent_DimCatalogItemId] [int] NOT NULL,
	[CreatedOn_DimDateId] [datetime] NULL,
	[InstallDate_DimDateId] [datetime] NULL,
	[ProvisioningDate_DimDateId] [datetime] NULL,
	[BillingEffectiveDate_DimDateId] [datetime] NULL,
	[OrderClosed_DimDateId] [datetime] NULL,
	[SalesOrderLineItemQuantity] [int] NOT NULL,
	[SalesOrderLineItemAmountPaid] [numeric](15, 2) NULL,
	[SalesOrderLineItemOldQuantity] [int] NULL,
	[SalesOrderLineItemOldPrice] [numeric](15, 7) NULL,
	[SalesOrderLineItemDownPaymentAmount] [numeric](15, 2) NOT NULL,
	[SalesOrderLineItemPurchaseAmount] [numeric](15, 2) NOT NULL,
	[SalesOrderLineItemTotalCostOfLoan] [numeric](15, 2) NOT NULL,
	[SalesOrderLineItemTaxCollected] [numeric](15, 2) NOT NULL,
	[SalesOrderLineItemLoanAmount] [numeric](15, 2) NOT NULL,
	[SalesOrderLineItemManualDiscountAmount] [money] NULL,
	[SalesOrderLineItemVolumeDiscountAmount] [money] NULL,
	[SalesOrderLineItemPricePerUnit] [money] NULL,
	[SalesOrderLineItemBaseAmount] [money] NULL,
	[SalesOrderLineItemExtendedAmount] [money] NULL,
	[SalesOrderLineItemTax] [money] NULL,
	[SalesOrderLineItemPrice] [numeric](10, 2) NULL,
	[DimCatalogPriceId] [int] NULL
) ON [PRIMARY]
GO
