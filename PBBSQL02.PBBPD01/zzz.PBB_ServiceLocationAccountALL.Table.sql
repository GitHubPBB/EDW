USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PBB_ServiceLocationAccountALL]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PBB_ServiceLocationAccountALL](
	[DimServiceLocationId] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimAccountID] [int] NULL,
	[CRMAccountID] [nvarchar](100) NULL,
	[AccountStatus] [nvarchar](40) NULL,
	[LocationAccountActivationDate] [smalldatetime] NULL,
	[LocationAccountDeactivationDate] [smalldatetime] NULL,
	[LocationAccountAmount] [numeric](38, 7) NULL,
	[LocationAccountItemStatuses] [nvarchar](max) NULL,
	[OpenInstallOrder] [varchar](1) NULL,
	[NonInstallOrder] [varchar](1) NULL,
	[OpenInstallOpportunity] [varchar](1) NULL,
	[NonInstallOpportunity] [varchar](1) NULL,
	[OpenInstallLead] [varchar](1) NULL,
	[NonInstallLead] [varchar](1) NULL,
	[LeadType] [nvarchar](4000) NULL,
	[pbb_ServiceLocationAccountStatus] [nvarchar](4000) NULL,
	[pbb_ServiceLocationAccountRank] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
