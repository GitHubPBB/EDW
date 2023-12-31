USE [PBBPDW01]
GO
/****** Object:  Table [transient].[PhnPhone]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[PhnPhone](
	[PhoneID] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[ModifyDate] [smalldatetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[PhoneSeriesID] [int] NULL,
	[StatusIndicator] [tinyint] NOT NULL,
	[Phone] [char](10) NOT NULL,
	[ItemID] [int] NULL,
	[PhoneStatus] [char](1) NOT NULL,
	[StatusDate] [smalldatetime] NOT NULL,
	[SwitchID] [int] NULL,
	[ESN] [varchar](21) NULL,
	[ExchangeCode] [char](7) NOT NULL
) ON [PRIMARY]
GO
