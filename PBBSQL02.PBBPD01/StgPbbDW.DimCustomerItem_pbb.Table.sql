USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimCustomerItem_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimCustomerItem_pbb](
	[pbb_DimCustomerItemId] [int] NOT NULL,
	[ItemId] [nvarchar](400) NOT NULL,
	[pbb_ItemOpenOrderFulfillmentStatus] [nvarchar](100) NOT NULL,
	[pbb_DimGLMapId] [nvarchar](400) NOT NULL,
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
ALTER TABLE [StgPbbDW].[DimCustomerItem_pbb] ADD  DEFAULT ('') FOR [pbb_ItemOpenOrderFulfillmentStatus]
GO
ALTER TABLE [StgPbbDW].[DimCustomerItem_pbb] ADD  DEFAULT ((0)) FOR [pbb_DimGLMapId]
GO
