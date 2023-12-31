USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_PBB_AccountDetailsTemp]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_PBB_AccountDetailsTemp](
	[AccountType] [nvarchar](100) NOT NULL,
	[AccountGroup] [nvarchar](256) NOT NULL,
	[CurrentAccountStatus] [nvarchar](256) NOT NULL,
	[AccountNumber] [nvarchar](20) NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[AccountName] [nvarchar](168) NULL,
	[Email] [nvarchar](100) NULL,
	[Telephone1] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Phone2] [nvarchar](50) NULL,
	[Phone3] [nvarchar](50) NULL,
	[CPNIPassword] [nvarchar](4000) NOT NULL,
	[CPNIEmail] [nvarchar](100) NULL,
	[PortalUserExists] [varchar](1) NOT NULL,
	[PortalEmail] [varchar](255) NULL,
	[PrintGroup] [nvarchar](40) NOT NULL,
	[Ebill_Flag] [varchar](1) NOT NULL,
	[BillCycle] [varchar](40) NOT NULL,
	[ActivationDate] [datetime] NULL,
	[DeactivationDate] [datetime] NULL,
	[Last Payment Date] [smalldatetime] NULL,
	[Payment Amount] [money] NULL,
	[Open Balance_As of Previous Day] [money] NULL,
	[Recurring Payment Method] [nvarchar](max) NOT NULL,
	[ActiveServices] [varchar](1) NOT NULL,
	[LegacySystemAccountID] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
