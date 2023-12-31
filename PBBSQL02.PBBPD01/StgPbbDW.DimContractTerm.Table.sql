USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimContractTerm]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimContractTerm](
	[DimContractTermId] [int] NOT NULL,
	[SourceId] [nvarchar](400) NOT NULL,
	[ContractTermName] [nvarchar](100) NOT NULL,
	[ContractTermType] [nvarchar](50) NOT NULL,
	[ContractTermStatus] [nvarchar](50) NOT NULL,
	[ContractTermAutoRenew] [nvarchar](50) NOT NULL,
	[ContractName] [nvarchar](100) NOT NULL,
	[ContractOwner] [nvarchar](200) NOT NULL,
	[ContractDescription] [nvarchar](4000) NOT NULL,
	[ContractStatus] [nvarchar](50) NOT NULL,
	[ContractVersion] [nvarchar](100) NOT NULL,
	[ContractModifiedBy] [nvarchar](200) NOT NULL,
	[ContractModifiedOn] [datetime] NULL,
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
ALTER TABLE [StgPbbDW].[DimContractTerm] ADD  DEFAULT ('') FOR [ContractTermName]
GO
ALTER TABLE [StgPbbDW].[DimContractTerm] ADD  DEFAULT ('') FOR [ContractTermType]
GO
ALTER TABLE [StgPbbDW].[DimContractTerm] ADD  DEFAULT ('') FOR [ContractTermStatus]
GO
ALTER TABLE [StgPbbDW].[DimContractTerm] ADD  DEFAULT ('') FOR [ContractTermAutoRenew]
GO
ALTER TABLE [StgPbbDW].[DimContractTerm] ADD  DEFAULT ('') FOR [ContractName]
GO
ALTER TABLE [StgPbbDW].[DimContractTerm] ADD  DEFAULT ('') FOR [ContractOwner]
GO
ALTER TABLE [StgPbbDW].[DimContractTerm] ADD  DEFAULT ('') FOR [ContractDescription]
GO
ALTER TABLE [StgPbbDW].[DimContractTerm] ADD  DEFAULT ('') FOR [ContractStatus]
GO
ALTER TABLE [StgPbbDW].[DimContractTerm] ADD  DEFAULT ('') FOR [ContractVersion]
GO
ALTER TABLE [StgPbbDW].[DimContractTerm] ADD  DEFAULT ('') FOR [ContractModifiedBy]
GO
