USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[TempAcctItems]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TempAcctItems](
	[AccountCode] [char](13) NOT NULL,
	[LocationId] [int] NOT NULL,
	[ItemId] [int] NULL,
	[ItemLevel] [varchar](1) NOT NULL,
	[L2_DisplayName] [varchar](255) NULL,
	[L3_DisplayName] [varchar](255) NULL
) ON [PRIMARY]
GO
