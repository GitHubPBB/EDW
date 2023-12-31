USE [PBBPDW01]
GO
/****** Object:  Table [transient].[CHR_SubscriberCount_DecMEFinal]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[CHR_SubscriberCount_DecMEFinal](
	[BeginDate] [date] NULL,
	[AccountNumber] [char](13) NOT NULL,
	[AccountID] [int] NOT NULL,
	[AccountStatusCode] [char](1) NOT NULL,
	[LocationID] [int] NOT NULL,
	[AccountMarket] [nvarchar](100) NULL,
	[AccountType] [nvarchar](100) NULL,
	[AccountGroup] [nvarchar](256) NULL,
	[BeginCount] [int] NULL,
	[InstallsCount] [int] NULL,
	[DisconnectsCount] [int] NULL,
	[LoadDateTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
