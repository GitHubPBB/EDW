USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[CHR_AccountLocationActivity]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[CHR_AccountLocationActivity](
	[AccountID] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[ConnectDate] [smalldatetime] NULL,
	[DisconnectDate] [smalldatetime] NULL,
	[RowIndex] [int] NOT NULL,
	[LoadDateTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
