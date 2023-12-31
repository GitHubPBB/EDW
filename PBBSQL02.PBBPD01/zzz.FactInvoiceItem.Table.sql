USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactInvoiceItem]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactInvoiceItem](
	[FactInvoiceItemId] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceItemID] [int] NOT NULL,
	[InvoiceItemOriginalBalance] [money] NOT NULL,
	[InvoiceItemCurrentBalance] [money] NOT NULL,
	[DimArItemId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL
) ON [PRIMARY]
GO
