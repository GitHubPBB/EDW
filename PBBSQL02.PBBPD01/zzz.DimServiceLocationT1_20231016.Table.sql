USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimServiceLocationT1_20231016]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimServiceLocationT1_20231016](
	[DimServiceLocationKey] [bigint] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[ServiceLocationFullAddress] [nvarchar](300) NOT NULL,
	[Latitude] [varchar](11) NOT NULL,
	[Longitude] [varchar](11) NOT NULL,
	[DimMarketKey] [int] NULL,
	[DimProjectKey] [int] NULL,
	[ProjectCode] [varchar](100) NULL,
	[CabinetName] [varchar](100) NULL,
	[DistributionCenter] [varchar](200) NULL,
	[IsMdu] [int] NULL,
	[IsBulk] [int] NULL,
	[VetroCircuitId] [varchar](100) NULL,
	[IsServiceable] [int] NULL,
	[ServiceableDate] [date] NULL,
	[NonServiceableReason] [varchar](50) NULL,
	[IsDataServiceable] [int] NULL,
	[IsPhoneServiceable] [int] NULL,
	[FiberTechnology] [varchar](50) NULL,
	[DefaultNetworkDelivery] [varchar](50) NULL,
	[FundType] [varchar](50) NULL,
	[FundId] [varchar](50) NULL,
	[IsMarketable] [int] NULL,
	[PremiseType] [varchar](50) NULL,
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
	[ServiceLocationRegionCode] [nvarchar](10) NOT NULL,
	[ServiceLocationStatusReason] [nvarchar](256) NOT NULL,
	[ServiceLocationStatus] [nvarchar](256) NOT NULL,
	[ServiceLocationCreatedBy] [varchar](64) NOT NULL,
	[ServiceLocationCreatedOn] [smalldatetime] NULL,
	[ServiceLocationComment] [varchar](30) NOT NULL,
	[ServiceLocationDescription] [varchar](8000) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaInsertDatetime] [datetime] NOT NULL,
	[MetaCurrRecInd] [char](1) NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaEtlProcessId] [int] NOT NULL,
	[MetaSourceSystemCode] [varchar](10) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationFullAddress]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [Latitude]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [Longitude]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [CensusTract]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [CensusBlock]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [CensusStateCode]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [CensusCountyCode]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationCity]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationCassCity]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationState]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationStateAbbreviation]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationCountry]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationCountryAbbreviation]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationMetroArea]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationTaxAreaCode]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationTaxArea]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationCountyJurisdiction]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationDistrictJurisdiction]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationZone]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationDefaultZone]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationRegion_WireCenter]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationHouseNumber]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationHouseSuffix]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationApartment]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationFloor]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationRoom]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationLocation]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationPostalCode]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationPostalCodePlus4]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationStreet]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationPreDirectional]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationStreetSuffix]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationPostDirectional]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationRegionCode]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationStatusReason]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationStatus]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationCreatedBy]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationComment]
GO
ALTER TABLE [zzz].[DimServiceLocationT1_20231016] ADD  DEFAULT ('') FOR [ServiceLocationDescription]
GO
