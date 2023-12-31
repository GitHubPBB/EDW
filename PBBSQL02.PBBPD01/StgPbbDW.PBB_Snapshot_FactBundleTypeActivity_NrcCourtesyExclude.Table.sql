USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[PBB_Snapshot_FactBundleTypeActivity_NrcCourtesyExclude]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[PBB_Snapshot_FactBundleTypeActivity_NrcCourtesyExclude](
	[BeginDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[AccountLocation] [nvarchar](100) NOT NULL,
	[PBB_BundleTypeStart] [nvarchar](100) NULL,
	[Begin_Other] [nvarchar](100) NULL,
	[PBB_BundleTypeEnd] [nvarchar](100) NULL,
	[End_Other] [nvarchar](100) NULL,
	[BeginCount] [int] NULL,
	[EndCount] [int] NULL,
	[Install] [int] NULL,
	[Disconnect] [int] NULL,
	[Upgrade] [int] NULL,
	[Downgrade] [int] NULL,
	[Sidegrade] [int] NULL,
	[AccountGroup] [nvarchar](100) NULL,
	[AccountType] [nvarchar](100) NULL,
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
