USE [PBBPDW01]
GO
/****** Object:  Table [transient].[SalesOrderNotInDimSalesOrder]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[SalesOrderNotInDimSalesOrder](
	[AsOfDate] [date] NULL,
	[LoadDate] [datetime] NOT NULL,
	[fso_FactSalesOrderId] [int] NOT NULL,
	[fso_SalesOrderId] [nvarchar](400) NOT NULL,
	[fso_DimSalesOrderId] [int] NOT NULL,
	[fso_DimAccountId] [int] NOT NULL,
	[fso_DimAccountCategoryId] [int] NOT NULL,
	[fso_Partner_DimAccountId] [int] NOT NULL,
	[fso_CreatedBy_DimContactId] [int] NOT NULL,
	[fso_Partner_DimContactId] [int] NOT NULL,
	[fso_ModifiedBy_DimContactId] [int] NOT NULL,
	[fso_DimOpportunityId] [int] NOT NULL,
	[fso_DimQuoteId] [int] NOT NULL,
	[fso_Source_DimCampaignId] [int] NOT NULL,
	[fso_CreatedOn_DimDateId] [date] NOT NULL,
	[fso_ProvisioningDate_DimDateId] [date] NOT NULL,
	[fso_CommitmentDate_DimDateId] [date] NOT NULL,
	[fso_OrderClosed_DimDateId] [date] NOT NULL,
	[fso_SalesOrderTotalLineItemAmount] [money] NOT NULL,
	[fso_SalesOrderTotalTax] [money] NOT NULL,
	[fso_SalesOrderTotalAmount] [money] NOT NULL,
	[fso_SalesOrderTotalMRC] [money] NOT NULL,
	[fso_SalesOrderTotalNRC] [money] NOT NULL,
	[dso_DimSalesOrderId] [int] NOT NULL,
	[dso_SalesOrderId] [nvarchar](400) NOT NULL,
	[dso_SalesOrderNumber] [nvarchar](100) NOT NULL,
	[dso_SalesOrderName] [nvarchar](300) NOT NULL,
	[dso_SalesOrderFulfillmentStatus] [nvarchar](100) NOT NULL,
	[dso_SalesOrderChannel] [nvarchar](256) NOT NULL,
	[dso_SalesOrderSegment] [nvarchar](1000) NOT NULL,
	[dso_SalesOrderProvisioningDate] [datetime] NULL,
	[dso_SalesOrderCommitmentDate] [datetime] NULL,
	[dso_SalesOrderType] [nvarchar](256) NOT NULL,
	[dso_SalesOrderProject] [nvarchar](80) NOT NULL,
	[dso_SalesOrderProjectManager] [nvarchar](200) NOT NULL,
	[dso_SalesOrderOwner] [nvarchar](200) NOT NULL,
	[dso_SalesOrderStatusReason] [nvarchar](256) NOT NULL,
	[dso_SalesOrderStatus] [nvarchar](256) NOT NULL,
	[dso_SalesOrderPriorityCode] [nvarchar](256) NOT NULL,
	[dso_SalesOrderDisconnectReason] [nvarchar](256) NOT NULL,
	[dso_OrderHasServiceActivity] [nvarchar](50) NOT NULL,
	[dso_OrderWorkflowName] [nvarchar](256) NOT NULL,
	[fsoli_FactSalesOrderLineItemId] [int] NULL,
	[fsoli_OCComponent_ID] [int] NULL,
	[fsoli_DimSalesOrderLineItemId] [int] NULL,
	[fsoli_DimSalesOrderId] [int] NULL,
	[fsoli_DimOpportunityId] [int] NULL,
	[fsoli_DimCustomerItemId] [int] NULL,
	[fsoli_Parent_DimCustomerItemId] [int] NULL,
	[fsoli_DimAccountId] [int] NULL,
	[fsoli_DimAccountCategoryId] [int] NULL,
	[fsoli_DimServiceLocationId] [int] NULL,
	[fsoli_Old_DimServiceLocationId] [int] NULL,
	[fsoli_DimFMAddressId] [int] NULL,
	[fsoli_Old_DimFMAddressId] [int] NULL,
	[fsoli_DimCatalogItemId] [int] NULL,
	[fsoli_Parent_DimCatalogItemId] [int] NULL,
	[fsoli_CreatedOn_DimDateId] [date] NULL,
	[fsoli_InstallDate_DimDateId] [date] NULL,
	[fsoli_ProvisioningDate_DimDateId] [date] NULL,
	[fsoli_BillingEffectiveDate_DimDateId] [date] NULL,
	[fsoli_OrderClosed_DimDateId] [date] NULL,
	[fsoli_SalesOrderLineItemQuantity] [int] NULL,
	[fsoli_SalesOrderLineItemAmountPaid] [decimal](15, 2) NULL,
	[fsoli_SalesOrderLineItemOldQuantity] [int] NULL,
	[fsoli_SalesOrderLineItemOldPrice] [decimal](15, 7) NULL,
	[fsoli_SalesOrderLineItemDownPaymentAmount] [decimal](15, 2) NULL,
	[fsoli_SalesOrderLineItemPurchaseAmount] [decimal](15, 2) NULL,
	[fsoli_SalesOrderLineItemTotalCostOfLoan] [decimal](15, 2) NULL,
	[fsoli_SalesOrderLineItemTaxCollected] [decimal](15, 2) NULL,
	[fsoli_SalesOrderLineItemLoanAmount] [decimal](15, 2) NULL,
	[fsoli_SalesOrderLineItemManualDiscountAmount] [money] NULL,
	[fsoli_SalesOrderLineItemVolumeDiscountAmount] [money] NULL,
	[fsoli_SalesOrderLineItemPricePerUnit] [money] NULL,
	[fsoli_SalesOrderLineItemBaseAmount] [money] NULL,
	[fsoli_SalesOrderLineItemExtendedAmount] [money] NULL,
	[fsoli_SalesOrderLineItemTax] [money] NULL,
	[fsoli_SalesOrderLineItemPrice] [decimal](10, 2) NULL,
	[fsoli_DimCatalogPriceId] [int] NULL
) ON [PRIMARY]
GO
