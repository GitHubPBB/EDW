USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimServiceLocationAccount_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimServiceLocationAccount_pbb](
	[pbb_DimServiceLocationAccountId] [int] NOT NULL,
	[pbb_ServiceLocationAccountId] [nvarchar](415) NOT NULL,
	[pbb_ServiceLocationAccountStatus] [nvarchar](105) NULL,
	[pbb_ServiceLocationAccountStatusRank] [int] NOT NULL,
	[pbb_LocationAccountBundleType] [varchar](32) NOT NULL,
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
