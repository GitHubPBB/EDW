USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PBB_DashboardEmailList]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PBB_DashboardEmailList](
	[emailaddress] [varchar](100) NOT NULL,
	[preview] [bit] NULL,
	[enabled] [bit] NULL
) ON [PRIMARY]
GO
