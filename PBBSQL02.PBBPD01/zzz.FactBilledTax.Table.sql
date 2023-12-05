USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactBilledTax]    Script Date: 12/5/2023 4:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactBilledTax](
	[FactBilledTaxId] [int] IDENTITY(1,1) NOT NULL,
	[BRAccountTaxRowID] [nvarchar](400) NOT NULL,
	[DimBillingRunId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimBilledTaxId] [int] NOT NULL,
	[DimTaxId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimGLMapId] [int] NOT NULL,
	[BilledTaxAmount] [money] NOT NULL,
	[BilledTaxBase] [money] NOT NULL,
	[DimCatalogItemId] [int] NOT NULL,
	[DimCatalogOCCId] [int] NOT NULL,
	[DimBilledChargeId] [int] NOT NULL,
	[DimBilledUsageId] [int] NOT NULL,
	[DimCustomerOCCId] [int] NOT NULL,
	[Source_DimGLMapId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimBillingRunId] ASC,
	[FactBilledTaxId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [BillingRunPS]([DimBillingRunId])
) ON [BillingRunPS]([DimBillingRunId])
GO
