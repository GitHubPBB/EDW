USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[DimMarketT1]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimMarketT1](
	[DimMarketKey] [smallint] NOT NULL,
	[DimMarketNaturalKey] [varchar](50) NOT NULL,
	[DimMarketNaturalKeyFields] [varchar](100) NOT NULL,
	[AccountMarketName] [varchar](50) NOT NULL,
	[ReportingMarketName] [varchar](50) NOT NULL,
	[MarketSummaryName] [varchar](50) NULL,
	[IsInternalMarket] [char](1) NOT NULL,
	[IsExternalMarket] [char](1) NOT NULL,
	[AccountMarketSortKey] [smallint] NOT NULL,
	[MetaSourceSystemCode] [varchar](20) NOT NULL,
	[MetaInsertDatetime] [date] NOT NULL,
	[MetaUpdateDatetime] [date] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [smallint] NOT NULL
) ON [PRIMARY]
GO
