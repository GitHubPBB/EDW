USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[DimAccountCategory]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[DimAccountCategory](
	[DimAccountCategoryId] [int] NOT NULL,
	[SourceId] [nvarchar](200) NOT NULL,
	[AccountClassCode] [nvarchar](20) NOT NULL,
	[AccountClass] [nvarchar](256) NOT NULL,
	[AccountGroupCode] [nvarchar](20) NOT NULL,
	[AccountGroup] [nvarchar](256) NOT NULL,
	[AccountTypeCode] [varchar](4) NOT NULL,
	[AccountType] [nvarchar](100) NOT NULL,
	[CustomerServiceRegionCode] [nvarchar](20) NOT NULL,
	[CustomerServiceRegion] [nvarchar](256) NOT NULL,
	[CycleNumber] [int] NOT NULL,
	[CycleDescription] [varchar](40) NOT NULL,
	[CycleDay] [char](2) NOT NULL,
	[AccountSegment] [nvarchar](1000) NOT NULL,
	[AccountTaxExemption] [nvarchar](256) NOT NULL,
	[MetaRowKey] [varchar](100) NOT NULL,
	[MetaRowKeyFields] [varchar](100) NOT NULL,
	[MetaRowHash] [varbinary](2000) NOT NULL,
	[MetaSourceSystemCode] [varchar](50) NOT NULL,
	[MetaInsertDatetime] [datetime] NOT NULL,
	[MetaUpdateDatetime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaCurrentRecordIndicator] [char](1) NOT NULL
) ON [PRIMARY]
GO
