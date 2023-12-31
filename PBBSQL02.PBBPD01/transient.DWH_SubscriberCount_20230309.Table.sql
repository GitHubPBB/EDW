USE [PBBPDW01]
GO
/****** Object:  Table [transient].[DWH_SubscriberCount_20230309]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[DWH_SubscriberCount_20230309](
	[AccountMarket] [nvarchar](100) NULL,
	[Sortvalue] [int] NULL,
	[BeginDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[AccountType] [nvarchar](100) NULL,
	[AccountGroup] [nvarchar](100) NULL,
	[BundleType] [varchar](50) NOT NULL,
	[PBB_BundleTypeStart] [nvarchar](100) NULL,
	[PBB_BundleTypeEnd] [nvarchar](100) NULL,
	[AccountLocation] [nvarchar](100) NOT NULL,
	[src_AccountLocation] [nvarchar](33) NOT NULL,
	[LocationId] [int] NULL,
	[AccountCode] [nvarchar](20) NULL,
	[AccountName] [nvarchar](168) NULL,
	[ServiceLocationFullAddress] [nvarchar](300) NULL,
	[DoesCustomerHaveOtherServices] [varchar](1) NULL,
	[TransitionBundleType] [varchar](8) NULL,
	[BeginCount] [int] NULL,
	[Install] [int] NULL,
	[Disconnect] [int] NULL,
	[Upgrade] [int] NULL,
	[Downgrade] [int] NULL,
	[Sidegrade] [int] NULL,
	[EndCount] [int] NULL,
	[exclude_case] [varchar](20) NULL
) ON [PRIMARY]
GO
