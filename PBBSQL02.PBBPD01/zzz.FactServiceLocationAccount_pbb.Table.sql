USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactServiceLocationAccount_pbb]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactServiceLocationAccount_pbb](
	[SourceId] [varchar](27) NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[Account_DimAgentId] [int] NOT NULL,
	[DimMembershipId] [int] NOT NULL,
	[pbb_ServiceLocationAccountId] [nvarchar](400) NOT NULL,
	[pbb_LocationAccountActivation_DimDateId] [date] NULL,
	[pbb_LocationAccountDeactivation_DimDateId] [date] NULL,
	[pbb_LocationAccountAmount] [money] NULL
) ON [PRIMARY]
GO
