USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[Stage_DTD_Orders]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stage_DTD_Orders](
	[AccountCode] [varchar](20) NULL,
	[DTD_Rep] [varchar](100) NULL
) ON [PRIMARY]
GO
