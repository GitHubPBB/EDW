USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[TempAcctItems]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[TempAcctItems](
	[AccountCode] [char](13) NOT NULL,
	[LocationId] [int] NOT NULL,
	[ItemId] [int] NULL,
	[ItemLevel] [varchar](1) NOT NULL,
	[L2_DisplayName] [varchar](255) NULL,
	[L3_DisplayName] [varchar](255) NULL
) ON [PRIMARY]
GO
