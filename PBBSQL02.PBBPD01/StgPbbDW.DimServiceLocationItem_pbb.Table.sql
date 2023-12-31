USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimServiceLocationItem_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimServiceLocationItem_pbb](
	[pbb_DimServiceLocationItemId] [int] NOT NULL,
	[SourceId] [nvarchar](400) NOT NULL,
	[pbb_DimAccountId] [nvarchar](400) NOT NULL,
	[pbb_DimServiceLocationId] [int] NOT NULL,
	[pbb_LocationItemStatus] [nvarchar](1) NOT NULL,
	[pbb_LocationAccountStatus] [nvarchar](1) NOT NULL,
	[pbb_LocationAccountOpenOrder] [nvarchar](10) NOT NULL,
	[pbb_LocationOpenOpportunity] [nvarchar](10) NOT NULL,
	[pbb_LocationOpenLeadType] [nvarchar](100) NOT NULL,
	[pbb_IsPhone] [int] NOT NULL,
	[pbb_IsData] [int] NOT NULL,
	[pbb_IsCable] [int] NOT NULL,
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
ALTER TABLE [StgPbbDW].[DimServiceLocationItem_pbb] ADD  DEFAULT ((0)) FOR [pbb_DimAccountId]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocationItem_pbb] ADD  DEFAULT ((0)) FOR [pbb_DimServiceLocationId]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocationItem_pbb] ADD  DEFAULT ('') FOR [pbb_LocationItemStatus]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocationItem_pbb] ADD  DEFAULT ('') FOR [pbb_LocationAccountStatus]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocationItem_pbb] ADD  DEFAULT ('') FOR [pbb_LocationAccountOpenOrder]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocationItem_pbb] ADD  DEFAULT ('') FOR [pbb_LocationOpenOpportunity]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocationItem_pbb] ADD  DEFAULT ('') FOR [pbb_LocationOpenLeadType]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocationItem_pbb] ADD  DEFAULT ((-1)) FOR [pbb_IsPhone]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocationItem_pbb] ADD  DEFAULT ((-1)) FOR [pbb_IsData]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocationItem_pbb] ADD  DEFAULT ((-1)) FOR [pbb_IsCable]
GO
