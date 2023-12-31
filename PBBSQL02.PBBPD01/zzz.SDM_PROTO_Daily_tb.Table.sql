USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[SDM_PROTO_Daily_tb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[SDM_PROTO_Daily_tb](
	[MetaEffectiveStartDate] [date] NOT NULL,
	[MetaEffectiveEndDate] [date] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[AccountCode] [nvarchar](20) NOT NULL,
	[LocationId] [int] NOT NULL,
	[AccountMarket] [nvarchar](100) NOT NULL,
	[AccountTypeCode] [nvarchar](4) NOT NULL,
	[BundleType] [nvarchar](50) NOT NULL,
	[PreviousBundleType] [nvarchar](50) NULL,
	[BundleTransitionType] [nvarchar](50) NULL,
	[BulkTenantFlag] [char](1) NOT NULL,
	[CourtesyFlag] [char](1) NOT NULL,
	[InternalUseFlag] [char](1) NOT NULL,
	[ProductState] [char](1) NULL,
	[PreviousProductState] [char](1) NULL,
	[SubscriberBeginCount] [int] NULL,
	[SubscriberGainCount] [int] NULL,
	[SubscriberLossCount] [int] NULL,
	[SubscriberMoveInCount] [int] NULL,
	[SubscriberMoveOutCount] [int] NULL,
	[SubscriberEndcount] [int] NULL,
	[StartStatusReason] [nvarchar](200) NULL,
	[EndStatusReason] [nvarchar](200) NULL,
	[StartOrderNumber] [nvarchar](100) NULL,
	[EndOrderNumber] [nvarchar](100) NULL,
	[ConnectReason] [nvarchar](200) NULL,
	[DisconnectReason] [nvarchar](200) NULL,
	[ExcludeReason] [nvarchar](200) NULL,
	[MRC] [money] NULL
) ON [PRIMARY]
GO
