USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimCatalogItem_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimCatalogItem_pbb](
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
ALTER TABLE [StgPbbDW].[DimCatalogItem_pbb] ADD  DEFAULT ('') FOR [CatalogItemIsUsed]
GO
ALTER TABLE [StgPbbDW].[DimCatalogItem_pbb] ADD  DEFAULT ('') FOR [CatalogItemIsIgnored]
GO
ALTER TABLE [StgPbbDW].[DimCatalogItem_pbb] ADD  DEFAULT ('') FOR [CatalogItemIsCable]
GO
ALTER TABLE [StgPbbDW].[DimCatalogItem_pbb] ADD  DEFAULT ('') FOR [CatalogItemIsData]
GO
ALTER TABLE [StgPbbDW].[DimCatalogItem_pbb] ADD  DEFAULT ('') FOR [CatalogItemIsPhone]
GO
ALTER TABLE [StgPbbDW].[DimCatalogItem_pbb] ADD  DEFAULT ('') FOR [CatalogItemIsPointGuard]
GO
ALTER TABLE [StgPbbDW].[DimCatalogItem_pbb] ADD  DEFAULT ('') FOR [CatalogItemIsPromo]
GO
ALTER TABLE [StgPbbDW].[DimCatalogItem_pbb] ADD  DEFAULT ('') FOR [CatalogItemIsRF]
GO
ALTER TABLE [StgPbbDW].[DimCatalogItem_pbb] ADD  DEFAULT ('') FOR [CatalogItemIsSmartHome]
GO
ALTER TABLE [StgPbbDW].[DimCatalogItem_pbb] ADD  DEFAULT ('') FOR [CatalogItemIsUnlimitedLD]
GO
