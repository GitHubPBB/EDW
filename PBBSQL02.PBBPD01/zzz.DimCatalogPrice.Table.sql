USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimCatalogPrice]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimCatalogPrice](
	[DimCatalogPriceId] [int] IDENTITY(1,1) NOT NULL,
	[PriceID] [int] NOT NULL,
	[CatalogPriceDescription] [varchar](80) NOT NULL,
	[CatalogPricePrintDescription] [varchar](80) NOT NULL,
	[CatalogPriceOfferBeginDate] [smalldatetime] NULL,
	[CatalogPriceOfferEndDate] [smalldatetime] NULL,
	[CatalogPriceOfferRemarks] [varchar](8000) NOT NULL,
	[CatalogPriceClass] [nvarchar](50) NOT NULL,
	[CatalogPriceRoundingMethod] [nvarchar](50) NOT NULL,
	[CatalogPriceBillingMethod] [nvarchar](50) NOT NULL,
	[CatalogPriceFractionalizationMethod] [nvarchar](50) NOT NULL,
	[CatalogPriceWaiverMethod] [nvarchar](50) NOT NULL,
	[CatalogPriceBillingFrequency] [nvarchar](50) NOT NULL,
	[CatalogPriceWeight] [int] NOT NULL,
	[CatalogPricePrintMethod] [nvarchar](50) NOT NULL,
	[CatalogPriceIsDeniable] [nvarchar](50) NOT NULL,
	[CatalogPriceElementClass] [nvarchar](50) NOT NULL,
	[CatalogPriceIsRecurring] [nvarchar](50) NOT NULL,
	[PriceList] [varchar](80) NOT NULL,
	[PricePlan] [varchar](80) NOT NULL,
	[PriceIsAdjustable] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimCatalogPriceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[PriceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
