USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactSalesOrder]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactSalesOrder](
	[FactSalesOrderId] [int] IDENTITY(1,1) NOT NULL,
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
PRIMARY KEY CLUSTERED 
(
	[FactSalesOrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
