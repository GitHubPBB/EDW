USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[CHR_SubscriberReportSnapshots_test20230213]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[CHR_SubscriberReportSnapshots_test20230213](
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
	[EndCount]  AS (([BeginCount]+[InstallCount])+[DisconnectCount]),
	[AccountLocation]  AS (([AccountNumber]+'|')+CONVERT([varchar](12),[LocationID])),
	[ExceptionComment] [varchar](256) NULL,
	[ExceptionPresent]  AS (case when isnull([ExceptionComment],'')='' then (0) else (1) end),
 CONSTRAINT [PK_CHR_SubscriberReportSnapshots_test] PRIMARY KEY NONCLUSTERED 
(
	[StartDate] ASC,
	[EndDate] ASC,
	[AccountNumber] ASC,
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
