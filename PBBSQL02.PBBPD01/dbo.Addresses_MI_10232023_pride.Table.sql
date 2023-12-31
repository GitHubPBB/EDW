USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[Addresses_MI_10232023_pride]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Addresses_MI_10232023_pride](
	[UseLocationID] [varchar](150) NULL,
	[CreatedOn] [varchar](150) NULL,
	[FullStreetAddress] [varchar](150) NULL,
	[HouseNumber] [varchar](150) NULL,
	[HouseSuffix] [varchar](150) NULL,
	[PreDirectional] [varchar](150) NULL,
	[Street] [varchar](150) NULL,
	[StreetSuffix] [varchar](150) NULL,
	[PostDirectional] [varchar](150) NULL,
	[Apartment] [varchar](150) NULL,
	[Room] [varchar](150) NULL,
	[Floor] [varchar](150) NULL,
	[City] [varchar](150) NULL,
	[State] [varchar](150) NULL,
	[PostalCode] [varchar](150) NULL,
	[PostalCodePlus4] [varchar](150) NULL,
	[PremiseType] [varchar](150) NULL,
	[MDUName] [varchar](150) NULL,
	[Marketable] [varchar](150) NULL,
	[LocationComment] [varchar](150) NULL,
	[ProjectCodeOld] [varchar](150) NULL,
	[Cabinet] [varchar](150) NULL,
	[CabinetOld] [varchar](150) NULL,
	[TaxAreaCode] [varchar](150) NULL,
	[Zone] [varchar](150) NULL,
	[Region] [varchar](150) NULL,
	[Latitude] [varchar](150) NULL,
	[Longitude] [varchar](150) NULL,
	[Rooftop] [varchar](150) NULL,
	[CensusStateCode] [varchar](150) NULL,
	[CensusCountyCode] [varchar](150) NULL,
	[CensusTract] [varchar](150) NULL,
	[CensusBlock] [varchar](150) NULL,
	[Serviceable] [varchar](150) NULL,
	[Data] [varchar](150) NULL,
	[CATV] [varchar](150) NULL,
	[CATVDigital] [varchar](150) NULL,
	[Phone] [varchar](150) NULL,
	[FixedWireless] [varchar](150) NULL,
	[NonServiceableReason] [varchar](150) NULL,
	[Fiber] [varchar](150) NULL,
	[DefaultNetworkDelivery] [varchar](150) NULL,
	[FundType] [varchar](150) NULL,
	[FundTypeId] [varchar](150) NULL,
	[ExternalID] [varchar](150) NULL,
	[VetroCircuitID] [varchar](150) NULL,
	[LoadDate] [varchar](150) NULL
) ON [PRIMARY]
GO
