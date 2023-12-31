USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimACH]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimACH](
	[DimACHId] [int] IDENTITY(1,1) NOT NULL,
	[ACHId] [bigint] NOT NULL,
	[ACHRoutingNumber] [char](9) NOT NULL,
	[ACHAccountNumberLast4Digits] [char](10) NOT NULL,
	[ACHStatus] [nvarchar](10) NOT NULL,
	[ACHBankAccountClass] [nvarchar](10) NOT NULL,
	[ACHAmount] [money] NOT NULL,
	[ACHRun] [varchar](40) NOT NULL,
	[ACHRunDate] [smalldatetime] NULL,
	[ACHRunStatus] [nvarchar](10) NOT NULL,
	[ACHEffectiveDate] [smalldatetime] NULL,
	[ACHBankEffectiveDate] [smalldatetime] NULL,
	[ACHBankName] [varchar](40) NOT NULL,
	[ACHBankRoutingNumber] [char](9) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimACHId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
