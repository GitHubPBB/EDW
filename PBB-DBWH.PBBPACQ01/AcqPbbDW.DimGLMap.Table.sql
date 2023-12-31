USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[DimGLMap]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[DimGLMap](
	[DimGLMapId] [int] NOT NULL,
	[SourceId] [varchar](20) NOT NULL,
	[GLMapType] [varchar](20) NOT NULL,
	[ReceivableGLAccount] [varchar](40) NOT NULL,
	[ReceivableGLAccountNumber] [varchar](30) NOT NULL,
	[ReceivableGLSubAccountNumber] [varchar](15) NOT NULL,
	[ReceivableGLCompanyCode] [char](10) NOT NULL,
	[ReceivableGLCompany] [varchar](40) NOT NULL,
	[RevenueGLAccount] [varchar](40) NOT NULL,
	[RevenueGLAccountNumber] [varchar](30) NOT NULL,
	[RevenueGLSubAccountNumber] [varchar](15) NOT NULL,
	[RevenueGLCompanyCode] [char](10) NOT NULL,
	[RevenueGLCompany] [varchar](40) NOT NULL,
	[SCD_EffectiveDate] [datetime] NULL,
	[SCD_ExpirationDate] [datetime] NULL,
	[SCD_IsCurrentRow] [bit] NOT NULL,
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
ALTER TABLE [AcqPbbDW].[DimGLMap] ADD  DEFAULT ('') FOR [GLMapType]
GO
ALTER TABLE [AcqPbbDW].[DimGLMap] ADD  DEFAULT ('') FOR [ReceivableGLAccount]
GO
ALTER TABLE [AcqPbbDW].[DimGLMap] ADD  DEFAULT ('') FOR [ReceivableGLAccountNumber]
GO
ALTER TABLE [AcqPbbDW].[DimGLMap] ADD  DEFAULT ('') FOR [ReceivableGLSubAccountNumber]
GO
ALTER TABLE [AcqPbbDW].[DimGLMap] ADD  DEFAULT ('') FOR [ReceivableGLCompanyCode]
GO
ALTER TABLE [AcqPbbDW].[DimGLMap] ADD  DEFAULT ('') FOR [ReceivableGLCompany]
GO
ALTER TABLE [AcqPbbDW].[DimGLMap] ADD  DEFAULT ('') FOR [RevenueGLAccount]
GO
ALTER TABLE [AcqPbbDW].[DimGLMap] ADD  DEFAULT ('') FOR [RevenueGLAccountNumber]
GO
ALTER TABLE [AcqPbbDW].[DimGLMap] ADD  DEFAULT ('') FOR [RevenueGLSubAccountNumber]
GO
ALTER TABLE [AcqPbbDW].[DimGLMap] ADD  DEFAULT ('') FOR [RevenueGLCompanyCode]
GO
ALTER TABLE [AcqPbbDW].[DimGLMap] ADD  DEFAULT ('') FOR [RevenueGLCompany]
GO
ALTER TABLE [AcqPbbDW].[DimGLMap] ADD  DEFAULT ((0)) FOR [SCD_IsCurrentRow]
GO
