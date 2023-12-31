USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_DailyInstallCompare]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_DailyInstallCompare](
	[Install Date] [date] NULL,
	[Account Market] [nvarchar](4000) NULL,
	[SO Number] [nvarchar](100) NULL,
	[Order Name] [nvarchar](300) NULL,
	[FulFillment Status] [nvarchar](100) NULL,
	[Account Group Code] [nvarchar](256) NULL,
	[Account Group] [nvarchar](256) NULL,
	[Account Number] [nvarchar](20) NULL,
	[Account Name] [nvarchar](250) NULL,
	[Street Address] [nvarchar](4000) NULL,
	[City] [nvarchar](4000) NULL,
	[State] [nvarchar](4000) NULL,
	[Zip Code] [nvarchar](4000) NULL,
	[SOURL] [nvarchar](4000) NULL,
	[accountId] [uniqueidentifier] NULL,
	[AccountURL] [nvarchar](123) NULL
) ON [PRIMARY]
GO
