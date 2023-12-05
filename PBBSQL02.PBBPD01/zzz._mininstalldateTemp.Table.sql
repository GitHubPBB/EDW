USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_mininstalldateTemp]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_mininstalldateTemp](
	[DimAccountId] [int] NOT NULL,
	[DimServiceLocationID] [int] NOT NULL,
	[FirstServiceInstallDate] [date] NULL,
	[LastServiceDisconnectDate] [date] NULL
) ON [PRIMARY]
GO
