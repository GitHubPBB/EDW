USE [PBBPDW01]
GO
/****** Object:  Table [transient].[ArAccountCard]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[ArAccountCard](
	[AccountCardID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[CardExpirationDate] [smalldatetime] NOT NULL,
	[CardSecurityInfo] [varchar](40) NOT NULL,
	[SecurityTypeID] [int] NULL,
	[RecurringDayOfMonth] [tinyint] NULL,
	[RecurringStartDate] [smalldatetime] NULL,
	[RecurringEndDate] [smalldatetime] NULL,
	[CardVendorID] [tinyint] NOT NULL,
	[NameOnCard] [varchar](50) NOT NULL,
	[Street] [varchar](20) NOT NULL,
	[PostalCode] [varchar](9) NOT NULL,
	[LastDateUsed] [smalldatetime] NULL,
	[CardNumber] [binary](33) NOT NULL,
	[AddedViaWeb] [tinyint] NULL
) ON [PRIMARY]
GO
