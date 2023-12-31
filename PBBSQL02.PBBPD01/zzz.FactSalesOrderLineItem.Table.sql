USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactSalesOrderLineItem]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactSalesOrderLineItem](
	[FactSalesOrderLineItemId] [int] IDENTITY(1,1) NOT NULL,
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
PRIMARY KEY CLUSTERED 
(
	[FactSalesOrderLineItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
