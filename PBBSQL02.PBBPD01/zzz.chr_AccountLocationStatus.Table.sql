USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[chr_AccountLocationStatus]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[chr_AccountLocationStatus](
	[AccountNumber] [char](12) NULL,
	[LocationID] [int] NULL,
	[FullLocation] [varchar](500) NULL,
	[LocationStatus] [varchar](1) NULL,
	[ActivationDate] [smalldatetime] NULL,
	[DeactivationDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
