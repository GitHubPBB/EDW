USE [PBBPDW01]
GO
/****** Object:  Table [transient].[NetUserName]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[NetUserName](
	[UserNameID] [int] NOT NULL,
	[Version] [smallint] NOT NULL,
	[ModifyDate] [smalldatetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[UserName] [varchar](80) NOT NULL,
	[DomainID] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[UserNamePassword] [varchar](40) NULL,
	[StartDate] [smalldatetime] NULL,
	[IgnorePasswordRequirements] [bit] NOT NULL
) ON [PRIMARY]
GO
