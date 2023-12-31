USE [PBBPDW01]
GO
/****** Object:  Table [transient].[PrdComponentClass]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[PrdComponentClass](
	[ComponentClassID] [int] NOT NULL,
	[Version] [smallint] NOT NULL,
	[ModifyDate] [smalldatetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[ComponentClass] [varchar](40) NOT NULL,
	[ComponentClassStatus] [char](1) NOT NULL,
	[ServiceIndicator] [tinyint] NULL,
	[IsService] [tinyint] NULL
) ON [PRIMARY]
GO
