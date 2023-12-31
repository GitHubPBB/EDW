USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[ABBSValley]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[ABBSValley](
	[FullStreetAddress] [varchar](8000) NULL,
	[HouseNumber] [varchar](10) NOT NULL,
	[HouseSuffix] [char](4) NOT NULL,
	[PreDirectional] [char](20) NOT NULL,
	[Street] [varchar](40) NOT NULL,
	[StreetSuffix] [char](20) NOT NULL,
	[PostDirectional] [char](20) NOT NULL,
	[Apartment] [varchar](75) NOT NULL,
	[Room] [varchar](30) NOT NULL,
	[Floor] [char](4) NOT NULL,
	[City] [varchar](28) NOT NULL,
	[State] [char](6) NOT NULL,
	[PostalCode] [char](11) NOT NULL,
	[PostalCodePlus4] [char](4) NOT NULL,
	[TaxAreaCode] [char](7) NULL,
	[WireCenter] [varchar](40) NULL,
	[countyjurisdictionid] [int] NULL,
	[districtjurisdictionid] [int] NULL,
	[Zone] [varchar](40) NOT NULL,
	[LocationComment] [varchar](30) NULL,
	[LocationDescription] [varchar](8000) NULL,
	[Latitude] [varchar](11) NOT NULL,
	[Longitude] [varchar](11) NOT NULL,
	[CensusBlock] [varchar](4) NOT NULL,
	[CensusTract] [varchar](7) NOT NULL,
	[CensusStateCode] [varchar](2) NOT NULL,
	[CensusCountyCode] [varchar](3) NOT NULL,
	[FundType] [nvarchar](50) NOT NULL,
	[FundTypeId] [nvarchar](50) NOT NULL,
	[VetroCircuitId] [nvarchar](100) NOT NULL,
	[Cabinet] [nvarchar](100) NOT NULL,
	[NetworkDeliveryMethod] [nvarchar](50) NULL,
	[Fiber] [varchar](1) NOT NULL,
	[OriginalProjectName] [varchar](1) NOT NULL,
	[OriginalServiceable] [varchar](1) NOT NULL,
	[LocationId] [int] NULL
) ON [PRIMARY]
GO
