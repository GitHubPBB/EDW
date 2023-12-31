USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactSalesOrderItemAgent]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactSalesOrderItemAgent](
	[FactSalesOrderItemAgentId] [int] IDENTITY(1,1) NOT NULL,
	[OCComponentAgent_ID] [int] NOT NULL,
	[DimSalesOrderLineItemId] [int] NOT NULL,
	[DimAgentId] [int] NOT NULL,
	[DimSalesOrderId] [int] NOT NULL,
	[DimOpportunityId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[Parent_DimCustomerItemId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimCatalogItemId] [int] NOT NULL,
	[Parent_DimCatalogItemId] [int] NOT NULL,
	[CreatedOn_DimDateId] [date] NOT NULL,
	[InstallDate_DimDateId] [date] NOT NULL,
	[ProvisioningDate_DimDateId] [date] NOT NULL,
	[BillingEffectiveDate_DimDateId] [date] NOT NULL,
	[OrderClosed_DimDateId] [date] NOT NULL,
	[OrderItemAgentQuantity] [int] NOT NULL,
	[OrderItemAgentPrice] [decimal](10, 2) NOT NULL,
	[OrderItemAgentCommission] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactSalesOrderItemAgentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
