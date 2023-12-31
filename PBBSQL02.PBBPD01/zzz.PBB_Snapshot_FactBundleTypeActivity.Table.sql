USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PBB_Snapshot_FactBundleTypeActivity]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PBB_Snapshot_FactBundleTypeActivity](
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
 CONSTRAINT [PK_PBB_Snapshot_FactBundleTypeActivity] PRIMARY KEY CLUSTERED 
(
	[BeginDate] ASC,
	[EndDate] ASC,
	[DimServiceLocationId] ASC,
	[DimAccountId] ASC,
	[AccountLocation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
