USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimServiceLocationItem_pbb]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimServiceLocationItem_pbb](
	[pbb_DimServiceLocationItemId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [nvarchar](400) NOT NULL,
	[pbb_DimAccountId] [nvarchar](400) NOT NULL,
	[pbb_DimServiceLocationId] [int] NOT NULL,
	[pbb_LocationItemStatus] [nvarchar](1) NOT NULL,
	[pbb_LocationAccountStatus] [nvarchar](1) NOT NULL,
	[pbb_LocationAccountOpenOrder] [nvarchar](10) NOT NULL,
	[pbb_LocationOpenOpportunity] [nvarchar](10) NOT NULL,
	[pbb_LocationOpenLeadType] [nvarchar](100) NOT NULL,
	[pbb_IsPhone] [int] NOT NULL,
	[pbb_IsData] [int] NOT NULL,
	[pbb_IsCable] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[pbb_DimServiceLocationItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
