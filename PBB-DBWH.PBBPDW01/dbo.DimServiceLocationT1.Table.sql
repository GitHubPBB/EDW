USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[DimServiceLocationT1]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimServiceLocationT1](
	[DimServiceLocationKey] [bigint] NOT NULL,
	[DimServiceLocationNaturalKey] [bigint] NOT NULL,
	[DimServiceLocationNaturalKeyFields] [varchar](20) NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[ServiceLocationFullAddress] [nvarchar](300) NOT NULL,
	[Latitude] [varchar](11) NOT NULL,
	[Longitude] [varchar](11) NOT NULL,
	[DimMarketKey] [int] NOT NULL,
	[DimProjectKey] [int] NOT NULL,
	[ProjectCode] [varchar](100) NULL,
	[CabinetName] [varchar](100) NULL,
	[DistributionCenter] [varchar](200) NULL,
	[IsMdu] [tinyint] NOT NULL,
	[IsBulk] [tinyint] NOT NULL,
	[VetroCircuitId] [varchar](100) NULL,
	[IsServiceable] [int] NOT NULL,
	[ServiceableDate] [date] NULL,
	[NonServiceableReason] [varchar](50) NULL,
	[IsDataServiceable] [int] NOT NULL,
	[IsPhoneServiceable] [int] NOT NULL,
	[EarliestAccountActivationDate] [date] NULL,
	[FiberTechnology] [varchar](50) NULL,
	[DefaultNetworkDelivery] [varchar](50) NULL,
	[FundType] [varchar](50) NULL,
	[FundId] [varchar](50) NULL,
	[IsMarketable] [int] NOT NULL,
	[PremiseType] [varchar](50) NULL,
	[CensusTract] [varchar](7) NOT NULL,
	[CensusBlock] [varchar](4) NOT NULL,
	[CensusStateCode] [varchar](2) NOT NULL,
	[CensusCountyCode] [varchar](3) NOT NULL,
	[ServiceLocationCity] [varchar](28) NOT NULL,
	[ServiceLocationCassCity] [varchar](28) NOT NULL,
	[ServiceLocationState] [varchar](50) NOT NULL,
	[ServiceLocationStateAbbreviation] [varchar](6) NOT NULL,
	[ServiceLocationCountry] [varchar](50) NOT NULL,
	[ServiceLocationCountryAbbreviation] [varchar](6) NOT NULL,
	[ServiceLocationMetroArea] [varchar](40) NOT NULL,
	[ServiceLocationTaxAreaCode] [varchar](7) NOT NULL,
	[ServiceLocationTaxArea] [varchar](40) NOT NULL,
	[ServiceLocationCountyJurisdiction] [varchar](40) NOT NULL,
	[ServiceLocationDistrictJurisdiction] [varchar](40) NOT NULL,
	[ServiceLocationZone] [varchar](40) NOT NULL,
	[ServiceLocationDefaultZone] [char](1) NOT NULL,
	[ServiceLocationRegion_WireCenter] [varchar](40) NOT NULL,
	[ServiceLocationHouseNumber] [varchar](10) NOT NULL,
	[ServiceLocationHouseSuffix] [varchar](4) NOT NULL,
	[ServiceLocationApartment] [varchar](75) NOT NULL,
	[ServiceLocationFloor] [varchar](4) NOT NULL,
	[ServiceLocationRoom] [varchar](30) NOT NULL,
	[ServiceLocationLocation] [varchar](60) NOT NULL,
	[ServiceLocationPostalCode] [varchar](11) NOT NULL,
	[ServiceLocationPostalCodePlus4] [varchar](4) NOT NULL,
	[ServiceLocationStreet] [varchar](40) NOT NULL,
	[ServiceLocationPreDirectional] [varchar](20) NOT NULL,
	[ServiceLocationStreetSuffix] [varchar](20) NOT NULL,
	[ServiceLocationPostDirectional] [varchar](20) NOT NULL,
	[ServiceLocationRegionCode] [varchar](10) NOT NULL,
	[ServiceLocationStatusReason] [varchar](256) NOT NULL,
	[ServiceLocationStatus] [varchar](256) NOT NULL,
	[ServiceLocationCreatedBy] [varchar](64) NOT NULL,
	[ServiceLocationCreatedOn] [smalldatetime] NULL,
	[ServiceLocationComment] [varchar](30) NOT NULL,
	[ServiceLocationDescription] [varchar](8000) NOT NULL,
	[MetaSourceSystemCode] [varchar](10) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaInsertDatetime] [datetime] NOT NULL,
	[MetaCurrRecInd] [char](1) NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaEtlProcessId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationFullAddress]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [Latitude]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [Longitude]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [CensusTract]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [CensusBlock]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [CensusStateCode]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [CensusCountyCode]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationCity]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationCassCity]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationState]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationStateAbbreviation]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationCountry]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationCountryAbbreviation]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationMetroArea]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationTaxAreaCode]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationTaxArea]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationCountyJurisdiction]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationDistrictJurisdiction]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationZone]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationDefaultZone]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationRegion_WireCenter]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationHouseNumber]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationHouseSuffix]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationApartment]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationFloor]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationRoom]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationLocation]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationPostalCode]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationPostalCodePlus4]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationStreet]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationPreDirectional]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationStreetSuffix]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationPostDirectional]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationRegionCode]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationStatusReason]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationStatus]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationCreatedBy]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationComment]
GO
ALTER TABLE [dbo].[DimServiceLocationT1] ADD  DEFAULT ('') FOR [ServiceLocationDescription]
GO
