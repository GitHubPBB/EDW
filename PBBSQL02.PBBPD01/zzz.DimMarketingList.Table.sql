USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimMarketingList]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimMarketingList](
	[DimMarketingListId] [int] IDENTITY(1,1) NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[MarketingListMemberCount] [int] NOT NULL,
	[MarketingListName] [nvarchar](128) NOT NULL,
	[MarketingListLastUsedOn] [datetime] NULL,
	[MarketingListStatus] [nvarchar](256) NOT NULL,
	[MarketingListStatusReason] [nvarchar](256) NOT NULL,
	[MarketingListPurpose] [nvarchar](512) NOT NULL,
	[MarketingListCost] [money] NOT NULL,
	[MarketingListMemberType] [int] NOT NULL,
	[MarketingListTargetedAt] [nvarchar](256) NOT NULL,
	[MarketingListType] [nvarchar](256) NOT NULL,
	[MarketingListSource] [nvarchar](128) NOT NULL,
	[MarketingListOwner] [nvarchar](200) NOT NULL,
	[MarketingListDescription] [nvarchar](max) NOT NULL,
	[MarketingListLocked] [nvarchar](256) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimMarketingListId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ListId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
