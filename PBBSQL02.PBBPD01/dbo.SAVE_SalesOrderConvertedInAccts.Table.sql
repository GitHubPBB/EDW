USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[SAVE_SalesOrderConvertedInAccts]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAVE_SalesOrderConvertedInAccts](
	[AccountCode] [varchar](9) NULL,
	[IsExpired] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SAVE_SalesOrderConvertedInAccts] ADD  DEFAULT ((0)) FOR [IsExpired]
GO
