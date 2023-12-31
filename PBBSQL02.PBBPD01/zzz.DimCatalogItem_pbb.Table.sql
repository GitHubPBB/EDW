USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimCatalogItem_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimCatalogItem_pbb](
	[DimCatalogItemId] [int] NOT NULL,
	[CatalogItemIsUsed] [nvarchar](3) NOT NULL,
	[CatalogItemIsIgnored] [nvarchar](3) NOT NULL,
	[CatalogItemIsCable] [nvarchar](3) NOT NULL,
	[CatalogItemIsData] [nvarchar](3) NOT NULL,
	[CatalogItemIsPhone] [nvarchar](3) NOT NULL,
	[CatalogItemIsPointGuard] [nvarchar](3) NOT NULL,
	[CatalogItemIsPromo] [nvarchar](3) NOT NULL,
	[CatalogItemIsRF] [nvarchar](3) NOT NULL,
	[CatalogItemIsSmartHome] [nvarchar](3) NOT NULL,
	[CatalogItemIsSmartHomePod] [nvarchar](3) NOT NULL,
	[CatalogItemIsSmartHomePromo] [nvarchar](3) NOT NULL,
	[CatalogItemIsUnlimitedLD] [nvarchar](3) NOT NULL,
 CONSTRAINT [PK_DimCatalogItem_pbb] PRIMARY KEY CLUSTERED 
(
	[DimCatalogItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
