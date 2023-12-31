USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimCampaign]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimCampaign](
	[DimCampaignId] [int] IDENTITY(1,1) NOT NULL,
	[CampaignId] [nvarchar](400) NOT NULL,
	[CampaignName] [nvarchar](128) NOT NULL,
	[CampaignType] [nvarchar](256) NOT NULL,
	[CampaignProposedEnd] [datetime] NULL,
	[CampaignProposedStart] [datetime] NULL,
	[CampaignPromotionCode] [nvarchar](128) NOT NULL,
	[CampaignStatusReason] [nvarchar](256) NOT NULL,
	[CampaignStatus] [nvarchar](256) NOT NULL,
	[CampaignIsTemplate] [nvarchar](256) NOT NULL,
	[CampaignActualStart] [datetime] NULL,
	[CampaignActualEnd] [datetime] NULL,
	[CampaignCode] [nvarchar](32) NOT NULL,
	[CampaignExpectedResponse] [int] NOT NULL,
	[CampaignOwner] [nvarchar](200) NOT NULL,
	[CampaignDescription] [nvarchar](max) NOT NULL,
	[CampaignOffer] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimCampaignId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CampaignId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
