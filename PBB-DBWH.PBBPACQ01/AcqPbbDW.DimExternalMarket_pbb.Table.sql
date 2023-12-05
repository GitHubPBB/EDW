USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[DimExternalMarket_pbb]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[DimExternalMarket_pbb](
	[pbb_DimExternalMarketId] [int] NOT NULL,
	[SourceId] [uniqueidentifier] NOT NULL,
	[pbb_ExternalMarketName] [nvarchar](200) NOT NULL,
	[pbb_ExternalMarketDescription] [nvarchar](100) NOT NULL,
	[pbb_ExternalMarketAccountGroupMarket] [nvarchar](100) NOT NULL,
	[pbb_ExternalMarketAccountGroupMarketSummary] [nvarchar](100) NOT NULL,
	[pbb_ExternalMarketSort] [int] NOT NULL,
	[pbb_ExternalMarketCallStats] [nvarchar](50) NOT NULL,
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaCurrentRecordIndicator] [varchar](1) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [AcqPbbDW].[DimExternalMarket_pbb] ADD  DEFAULT ('') FOR [pbb_ExternalMarketName]
GO
ALTER TABLE [AcqPbbDW].[DimExternalMarket_pbb] ADD  DEFAULT ('') FOR [pbb_ExternalMarketDescription]
GO
ALTER TABLE [AcqPbbDW].[DimExternalMarket_pbb] ADD  DEFAULT ('') FOR [pbb_ExternalMarketAccountGroupMarket]
GO
ALTER TABLE [AcqPbbDW].[DimExternalMarket_pbb] ADD  DEFAULT ('') FOR [pbb_ExternalMarketAccountGroupMarketSummary]
GO
ALTER TABLE [AcqPbbDW].[DimExternalMarket_pbb] ADD  DEFAULT ((0)) FOR [pbb_ExternalMarketSort]
GO
ALTER TABLE [AcqPbbDW].[DimExternalMarket_pbb] ADD  DEFAULT ('') FOR [pbb_ExternalMarketCallStats]
GO
