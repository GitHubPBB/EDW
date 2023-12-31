USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimCatalogPrice]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimCatalogPrice](
	[DimCatalogPriceId] [int] NOT NULL,
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
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [CatalogPriceDescription]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [CatalogPricePrintDescription]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [CatalogPriceOfferRemarks]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [CatalogPriceClass]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [CatalogPriceRoundingMethod]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [CatalogPriceBillingMethod]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [CatalogPriceFractionalizationMethod]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [CatalogPriceWaiverMethod]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [CatalogPriceBillingFrequency]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ((0)) FOR [CatalogPriceWeight]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [CatalogPricePrintMethod]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [CatalogPriceIsDeniable]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [CatalogPriceElementClass]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [CatalogPriceIsRecurring]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [PriceList]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [PricePlan]
GO
ALTER TABLE [StgPbbDW].[DimCatalogPrice] ADD  DEFAULT ('') FOR [PriceIsAdjustable]
GO
