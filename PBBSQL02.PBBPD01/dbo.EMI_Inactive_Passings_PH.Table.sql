USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[EMI_Inactive_Passings_PH]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMI_Inactive_Passings_PH](
	[LocationZone] [varchar](150) NULL,
	[ProjectName] [varchar](150) NULL,
	[Cabinet] [varchar](150) NULL,
	[WirecenterRegion] [varchar](150) NULL,
	[StreetAddress1] [varchar](150) NULL,
	[StreetAddress2] [varchar](150) NULL,
	[City] [varchar](150) NULL,
	[State] [varchar](150) NULL,
	[Postal_Code] [varchar](150) NULL,
	[PremiseType] [varchar](150) NULL,
	[Marketable] [varchar](150) NULL,
	[LocationIsServicable] [varchar](150) NULL
) ON [PRIMARY]
GO
