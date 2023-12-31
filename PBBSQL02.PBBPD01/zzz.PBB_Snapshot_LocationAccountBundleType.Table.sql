USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PBB_Snapshot_LocationAccountBundleType]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PBB_Snapshot_LocationAccountBundleType](
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
 CONSTRAINT [PK_PBB_Snapshot_LocationAccountBundleType] PRIMARY KEY CLUSTERED 
(
	[SnapshotDate] ASC,
	[DimServiceLocationId] ASC,
	[DimAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
