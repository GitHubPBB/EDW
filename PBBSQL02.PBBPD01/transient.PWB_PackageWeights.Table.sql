USE [PBBPDW01]
GO
/****** Object:  Table [transient].[PWB_PackageWeights]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[PWB_PackageWeights](
	[ProductOffering] [varchar](80) NOT NULL,
	[PackageComponent] [varchar](40) NOT NULL,
	[PackageComponentCode] [char](7) NOT NULL,
	[OfferEndDate] [smalldatetime] NULL,
	[PriceList] [varchar](80) NOT NULL,
	[PricePlan] [varchar](80) NULL,
	[StandardRate] [numeric](15, 7) NOT NULL,
	[DisperseCharges] [bit] NOT NULL,
	[Componentcode] [char](7) NOT NULL,
	[component] [varchar](40) NOT NULL,
	[DisperseAmount] [numeric](15, 7) NULL,
	[DisperseWeight] [int] NOT NULL
) ON [PRIMARY]
GO
