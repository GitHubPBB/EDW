USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[SDM_PROTO_stage_tb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[SDM_PROTO_stage_tb](
	[AsOfDate] [date] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[AccountCode] [nvarchar](20) NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[AccountTypeCode] [varchar](4) NULL,
	[AccountMarket] [nvarchar](100) NULL,
	[PBB_BundleType] [varchar](32) NOT NULL,
	[BulkTenantFlag] [varchar](1) NOT NULL,
	[Courtesy] [varchar](1) NULL,
	[InternalUse] [varchar](1) NULL,
	[MaxProductStatus] [varchar](1) NULL,
	[MRC] [money] NULL,
	[ServiceItem] [int] NULL
) ON [PRIMARY]
GO
