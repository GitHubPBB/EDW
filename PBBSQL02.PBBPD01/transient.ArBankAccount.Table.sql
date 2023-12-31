USE [PBBPDW01]
GO
/****** Object:  Table [transient].[ArBankAccount]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[ArBankAccount](
	[BankAccountID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[BankID] [int] NOT NULL,
	[BankAccount] [char](17) NOT NULL,
	[BankAccountClassID] [tinyint] NOT NULL,
	[BankAccountACHStatus] [tinyint] NOT NULL,
	[ACHDistributionID] [int] NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[EndDate] [smalldatetime] NULL,
	[Remarks] [varchar](255) NOT NULL,
	[AddedViaWeb] [tinyint] NULL
) ON [PRIMARY]
GO
