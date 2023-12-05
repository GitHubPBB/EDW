USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimServiceLocation]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimServiceLocation](
	[DimServiceLocationId] [int] IDENTITY(1,1) NOT NULL,
	[LocationId] [int] NOT NULL,
	[ServiceLocationComment] [varchar](30) NOT NULL,
	[ServiceLocationDescription] [varchar](8000) NOT NULL,
	[Latitude] [varchar](11) NOT NULL,
	[Longitude] [varchar](11) NOT NULL,
	[CensusTract] [varchar](7) NOT NULL,
	[CensusBlock] [varchar](4) NOT NULL,
	[CensusStateCode] [varchar](2) NOT NULL,
	[CensusCountyCode] [varchar](3) NOT NULL,
	[ServiceLocationCity] [varchar](28) NOT NULL,
	[ServiceLocationCassCity] [varchar](28) NOT NULL,
	[ServiceLocationState] [varchar](50) NOT NULL,
	[ServiceLocationStateAbbreviation] [char](6) NOT NULL,
	[ServiceLocationCountry] [varchar](50) NOT NULL,
	[ServiceLocationCountryAbbreviation] [char](6) NOT NULL,
	[ServiceLocationMetroArea] [varchar](40) NOT NULL,
	[ServiceLocationTaxAreaCode] [varchar](7) NOT NULL,
	[ServiceLocationTaxArea] [varchar](40) NOT NULL,
	[ServiceLocationCountyJurisdiction] [varchar](40) NOT NULL,
	[ServiceLocationDistrictJurisdiction] [varchar](40) NOT NULL,
	[ServiceLocationZone] [varchar](40) NOT NULL,
	[ServiceLocationDefaultZone] [char](1) NOT NULL,
	[ServiceLocationRegion_WireCenter] [varchar](40) NOT NULL,
	[ServiceLocationHouseNumber] [varchar](10) NOT NULL,
	[ServiceLocationHouseSuffix] [char](4) NOT NULL,
	[ServiceLocationApartment] [varchar](75) NOT NULL,
	[ServiceLocationFloor] [char](4) NOT NULL,
	[ServiceLocationRoom] [varchar](30) NOT NULL,
	[ServiceLocationLocation] [varchar](60) NOT NULL,
	[ServiceLocationPostalCode] [char](11) NOT NULL,
	[ServiceLocationPostalCodePlus4] [char](4) NOT NULL,
	[ServiceLocationStreet] [varchar](40) NOT NULL,
	[ServiceLocationPreDirectional] [char](20) NOT NULL,
	[ServiceLocationStreetSuffix] [char](20) NOT NULL,
	[ServiceLocationPostDirectional] [char](20) NOT NULL,
	[ServiceLocationFullAddress] [nvarchar](300) NOT NULL,
	[ServiceLocationRegionCode] [nvarchar](10) NOT NULL,
	[ServiceLocationStatusReason] [nvarchar](256) NOT NULL,
	[ServiceLocationStatus] [nvarchar](256) NOT NULL,
	[ServiceLocationCreatedBy] [varchar](64) NOT NULL,
	[ServiceLocationCreatedOn] [smalldatetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DimServiceLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[LocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
