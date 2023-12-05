USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_tempnewaddressdetails]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_tempnewaddressdetails](
	[DimServiceLocationId] [int] NULL,
	[Omnia SrvItemLocationID] [int] NULL,
	[FM AddressID] [int] NULL,
	[ServiceLocationFullAddress] [nvarchar](300) NULL,
	[StreetAddress1] [varchar](119) NULL,
	[StreetAddress2] [varchar](80) NULL,
	[AddressNoPostal] [varchar](233) NULL,
	[House Number] [varchar](10) NULL,
	[House Suffix] [char](4) NULL,
	[PreDirectional] [char](20) NULL,
	[Street] [varchar](40) NULL,
	[Street Suffix] [char](20) NULL,
	[PostDirectional] [char](20) NULL,
	[Apartment] [varchar](75) NULL,
	[Floor] [char](4) NULL,
	[Room] [varchar](30) NULL,
	[City] [varchar](28) NULL,
	[State] [varchar](50) NULL,
	[State Abbreviation] [char](6) NULL,
	[Postal Code] [char](11) NULL,
	[Postal Code Plus 4] [char](4) NULL,
	[Country] [varchar](50) NULL,
	[Country Abbreviation] [char](6) NULL,
	[Full Address] [nvarchar](300) NULL,
	[Wirecenter Region] [varchar](40) NULL,
	[Service RegionCode] [nvarchar](10) NULL,
	[VetroCircuitID] [nvarchar](100) NULL,
	[NetworkAddress] [nvarchar](50) NULL,
	[Hostname] [varchar](302) NULL,
	[RackOrFiberRing] [varchar](100) NULL,
	[ShelfOrCabinet] [varchar](100) NULL,
	[CardOrTopOfRackSwitchNo] [varchar](100) NULL,
	[PONPortOrSwitchNo] [varchar](100) NULL,
	[PONNoOrPortNo] [varchar](100) NULL,
	[Latitude] [varchar](11) NULL,
	[Longitude] [varchar](11) NULL,
	[Tax Area] [varchar](40) NULL,
	[CensusTract] [varchar](7) NULL,
	[CensusBlock] [varchar](4) NULL,
	[CensusCountyCode] [varchar](3) NULL,
	[CensusStateCode] [varchar](2) NULL,
	[Location Zone] [varchar](8000) NULL,
	[PremiseType] [nvarchar](4000) NULL,
	[Marketable] [varchar](7) NOT NULL,
	[ExternalID] [nvarchar](250) NULL,
	[FundType] [nvarchar](50) NULL,
	[FundTypeID] [nvarchar](50) NULL,
	[LoadDate] [datetime] NULL,
	[NonServiceable Reason] [nvarchar](50) NULL,
	[Serviceable Date] [date] NULL,
	[LocationIsServicable] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Data] [nvarchar](50) NULL,
	[CATV] [nvarchar](50) NULL,
	[CATV Digital] [nvarchar](50) NULL,
	[Default Network Delivery] [nvarchar](50) NULL,
	[FixedWireless] [nvarchar](50) NULL,
	[Project Name] [nvarchar](100) NULL,
	[Cabinet] [nvarchar](100) NULL,
	[Account-Location Status] [nvarchar](105) NOT NULL,
	[Account-Service Activation Date] [date] NULL,
	[Account-Service Deactivation Date] [date] NULL,
	[ServiceLocationComment] [varchar](30) NULL,
	[ServiceLocationDescription] [varchar](8000) NULL,
	[ServiceLocationCountyJurisdiction] [varchar](40) NULL,
	[ServiceLocationDistrictJurisdiction] [varchar](40) NULL,
	[ServiceLocationLocation] [varchar](60) NULL,
	[ServiceLocationCreatedBy] [varchar](64) NULL,
	[CreatedOn] [smalldatetime] NOT NULL,
	[AccountCode] [nvarchar](20) NULL,
	[AccountGroupCode] [nvarchar](20) NULL,
	[AccountType] [nvarchar](100) NULL,
	[AccountTypeCode] [varchar](4) NULL,
	[AccountClass] [nvarchar](256) NULL,
	[AccountName] [nvarchar](168) NULL,
	[AccountEMailAddress] [nvarchar](100) NULL,
	[ACPEmail] [varchar](255) NULL,
	[ACPUserExists] [varchar](1) NULL,
	[AccountPhoneNumber] [nvarchar](50) NULL,
	[BillingAddressPhone] [nvarchar](50) NULL,
	[AccountActivationDate] [date] NULL,
	[AccountDeactivationDate] [date] NULL,
	[pbb_LocationAccountAmount] [money] NULL
) ON [PRIMARY]
GO
