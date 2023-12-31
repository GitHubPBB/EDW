USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[SubscriberReportSnapshots_PoonamOG]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[SubscriberReportSnapshots_PoonamOG](
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[LoadDateTime] [datetime] NOT NULL,
	[AccountMarket] [varchar](100) NULL,
	[Market] [varchar](3) NULL,
	[AccountType] [varchar](100) NULL,
	[AccountGroup] [varchar](100) NULL,
	[AccountNumber] [varchar](13) NOT NULL,
	[AccountName] [varchar](100) NULL,
	[LocationID] [int] NOT NULL,
	[FullLocation] [varchar](500) NOT NULL,
	[ConnectDate] [datetime] NOT NULL,
	[InstallDate] [datetime] NULL,
	[DisconnectDate] [datetime] NULL,
	[BeginCount] [int] NOT NULL,
	[InstallCount] [int] NOT NULL,
	[DisconnectCount] [int] NOT NULL,
	[EndCount] [int] NULL,
	[AccountLocation] [varchar](26) NULL,
	[ExceptionComment] [varchar](256) NULL,
	[ExceptionPresent] [int] NOT NULL
) ON [PRIMARY]
GO
