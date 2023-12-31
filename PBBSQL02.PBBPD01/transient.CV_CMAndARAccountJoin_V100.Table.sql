USE [PBBPDW01]
GO
/****** Object:  Table [transient].[CV_CMAndARAccountJoin_V100]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[CV_CMAndARAccountJoin_V100](
	[ARAccountID] [int] NOT NULL,
	[ARAccountCode] [varchar](20) NOT NULL,
	[CMAccountID] [int] NOT NULL,
	[CMAccountCode] [char](13) NOT NULL,
	[AccountGroupCode] [char](6) NOT NULL,
	[AccountGroup] [varchar](40) NOT NULL
) ON [PRIMARY]
GO
