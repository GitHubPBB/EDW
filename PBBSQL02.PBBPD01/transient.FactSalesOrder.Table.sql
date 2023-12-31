USE [PBBPDW01]
GO
/****** Object:  Table [transient].[FactSalesOrder]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[FactSalesOrder](
	[FactSalesOrderId] [int] NULL,
	[SalesOrderId] [uniqueidentifier] NOT NULL,
	[DimSalesOrderId] [uniqueidentifier] NOT NULL,
	[DimAccountId] [uniqueidentifier] NULL,
	[DimAccountCategoryId] [nvarchar](203) NOT NULL,
	[Partner_DimAccountId] [uniqueidentifier] NULL,
	[CreatedBy_DimContactId] [uniqueidentifier] NULL,
	[Partner_DimContactId] [uniqueidentifier] NULL,
	[ModifiedBy_DimContactId] [uniqueidentifier] NULL,
	[DimOpportunityId] [uniqueidentifier] NULL,
	[DimQuoteId] [uniqueidentifier] NULL,
	[Source_DimCampaignId] [uniqueidentifier] NULL,
	[CreatedOn_DimDateId] [datetime] NULL,
	[ProvisioningDate_DimDateId] [datetime] NULL,
	[CommitmentDate_DimDateId] [datetime] NULL,
	[OrderClosed_DimDateId] [datetime] NULL,
	[SalesOrderTotalLineItemAmount] [money] NULL,
	[SalesOrderTotalTax] [money] NULL,
	[SalesOrderTotalAmount] [money] NULL,
	[SalesOrderTotalMRC] [money] NULL,
	[SalesOrderTotalNRC] [money] NULL
) ON [PRIMARY]
GO
