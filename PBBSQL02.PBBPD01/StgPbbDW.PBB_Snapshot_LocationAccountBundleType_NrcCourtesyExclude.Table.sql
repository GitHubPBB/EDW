USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[PBB_Snapshot_LocationAccountBundleType_NrcCourtesyExclude]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[PBB_Snapshot_LocationAccountBundleType_NrcCourtesyExclude](
	[SnapshotDate] [date] NOT NULL,
	[PeriodEndDate] [date] NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[ServiceLocationFullAddress] [nvarchar](300) NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[AccountCode] [nvarchar](20) NOT NULL,
	[AccountName] [nvarchar](168) NOT NULL,
	[AccountType] [nvarchar](100) NULL,
	[AccountGroup] [nvarchar](100) NULL,
	[PBB_BundleType] [varchar](32) NOT NULL,
	[DoesCustomerHaveOtherServices] [varchar](1) NOT NULL,
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
