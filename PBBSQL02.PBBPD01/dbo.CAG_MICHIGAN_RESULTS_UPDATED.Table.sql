USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[CAG_MICHIGAN_RESULTS_UPDATED]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CAG_MICHIGAN_RESULTS_UPDATED](
	[Street-In] [nvarchar](255) NULL,
	[City-In] [nvarchar](255) NULL,
	[State-In] [nvarchar](255) NULL,
	[ZipCode-In] [nvarchar](255) NULL,
	[Address Line 1] [nvarchar](255) NULL,
	[Address Line 2] [nvarchar](255) NULL,
	[Success] [nvarchar](255) NULL,
	[Vacant] [nvarchar](255) NULL,
	[HouseNumber] [nvarchar](255) NULL,
	[PreDirectional] [nvarchar](255) NULL,
	[Street] [nvarchar](255) NULL,
	[StreetSuffix] [nvarchar](255) NULL,
	[PostDirectional] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[PostalCode] [nvarchar](255) NULL,
	[PostalCodePlus4] [nvarchar](255) NULL,
	[SecondaryDesignator] [nvarchar](255) NULL,
	[SecondaryNumber] [nvarchar](255) NULL,
	[ExtraDesignator] [nvarchar](255) NULL,
	[ExtraNumber] [nvarchar](255) NULL,
	[PremiseType] [nvarchar](255) NULL,
	[Latitude] [nvarchar](255) NULL,
	[Longitude] [nvarchar](255) NULL,
	[Precision] [nvarchar](255) NULL,
	[MatchCode] [nvarchar](255) NULL,
	[Footnotes] [nvarchar](255) NULL,
	[StudyAreaCode] [nvarchar](255) NULL,
	[Latitude2] [nvarchar](255) NULL,
	[Longitude2] [nvarchar](255) NULL,
	[DateofDeployment] [nvarchar](255) NULL,
	[Download_Upload_Speed_Tier] [nvarchar](255) NULL,
	[NumberofUnits] [nvarchar](255) NULL,
	[CarrerLocationId] [nvarchar](255) NULL,
	[Technology] [nvarchar](255) NULL,
	[Other_Tech] [nvarchar](255) NULL,
	[Latency] [nvarchar](255) NULL
) ON [PRIMARY]
GO
