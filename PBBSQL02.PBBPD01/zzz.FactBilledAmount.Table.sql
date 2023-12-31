USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactBilledAmount]    Script Date: 12/5/2023 4:43:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactBilledAmount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BilledAmountID] [nvarchar](400) NOT NULL,
	[DimBillingRunId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[DimCustomerLineItemId] [int] NOT NULL,
	[DimCustomerPriceId] [int] NOT NULL,
	[DimCustomerOCCId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimGLMapId] [int] NOT NULL,
	[DimCatalogLineItemId] [int] NOT NULL,
	[DimCatalogPriceId] [int] NOT NULL,
	[DimCatalogOCCId] [int] NOT NULL,
	[DimCatalogTaxId] [int] NOT NULL,
	[BilledBeginDate_DimDateId] [date] NOT NULL,
	[BilledEndDate_DimDateId] [date] NOT NULL,
	[BilledAmount] [decimal](15, 7) NOT NULL,
	[BilledDiscountAmount] [decimal](15, 7) NOT NULL,
	[BilledQuantity] [int] NOT NULL
) ON [PRIMARY]
GO
