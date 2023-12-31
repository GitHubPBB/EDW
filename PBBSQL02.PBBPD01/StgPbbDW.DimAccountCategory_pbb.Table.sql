USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimAccountCategory_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimAccountCategory_pbb](
	[pbb_DimAccountCategoryId] [int] NOT NULL,
	[SourceId] [nvarchar](400) NOT NULL,
	[pbb_AccountMarket] [nvarchar](100) NOT NULL,
	[pbb_MarketSummary] [nvarchar](100) NOT NULL,
	[pbb_ReportingMarket] [nvarchar](100) NOT NULL,
	[MetaRowKey] [varchar](100) NOT NULL,
	[MetaRowKeyFields] [varchar](100) NOT NULL,
	[MetaRowHash] [varbinary](2000) NOT NULL,
	[MetaSourceSystemCode] [varchar](50) NOT NULL,
	[MetaInsertDatetime] [datetime] NOT NULL,
	[MetaUpdateDatetime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
