USE [PBBPDW01]
GO
/****** Object:  Table [transient].[SubscriberCount_AccountLocation_Analysis_20230701]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[SubscriberCount_AccountLocation_Analysis_20230701](
	[src] [varchar](4) NULL,
	[AccountLocation] [nvarchar](33) NULL,
	[BeginCount] [int] NULL,
	[InstallCount] [int] NULL,
	[DisconnectCount] [int] NULL,
	[EndCount] [int] NULL,
	[Prd_src] [varchar](4) NULL,
	[Prd_AccountLocation] [nvarchar](33) NULL,
	[Prd_BeginCount] [int] NULL,
	[Prd_InstallCount] [int] NULL,
	[Prd_DisconnectCount] [int] NULL,
	[Prd_EndCount] [int] NULL,
	[MatchCase] [varchar](31) NULL,
	[updatedate] [datetime] NOT NULL,
	[AnalysisFindings] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
