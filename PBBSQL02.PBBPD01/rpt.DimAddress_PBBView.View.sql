USE [PBBPDW01]
GO
/****** Object:  View [rpt].[DimAddress_PBBView]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--DROP VIEW [rpt].[DimAddress]

CREATE VIEW [rpt].[DimAddress_PBBView] 
 AS SELECT DISTINCT 
	 DimServiceLocationId
	,[Omnia SrvItemLocationID] LocationID
	,[FM AddressID] AS FMAddressID
	,ServiceLocationFullAddress FullAddress
	,StreetAddress1
	,StreetAddress2
	,[House Number] HouseNumber
	,[House Suffix] HouseSuffix
	,PreDirectional
	,Street
	,[Street Suffix] StreetSuffix
	,PostDirectional
	,Apartment
	,Floor
	,Room
	,City
	,STATE
	,[State Abbreviation] StateCode
	,[Postal Code] PostalCode
	,[Postal Code Plus 4] PostalCodePlus4
	,Country
	,[Country Abbreviation] CountryCode
	,[Wirecenter Region] SalesRegion
	,Latitude
	,Longitude
	,[Tax Area] TaxArea
	,CensusTract
	,CensusBlock
	,CensusCountyCode
	,CensusStateCode
	,[Location Zone] LocationZone
	,PremiseType
	,Marketable
	,ExternalID
	,FundType SubsidySource
	,FundTypeId SubsidySourceID
	,LoadDate
	,[NonServiceable Reason] NonServiceableReason
	,[Serviceable Date] ServiceableDate
	,LocationIsServicable
	,Phone
	,Data
	,CATV
	,CATV Digital
	,[Default Network Delivery] DefaultNetworkDelivery
	,FixedWireless
	,[Project Name] ProjectName
	,MDUName DistributionCenter
	,Cabinet
	,VetroCircuitID
	,NetworkAddress
	,Hostname NetworkAddressHostname
	,RackOrFiberRing NetworkAddressRackOrFiberRing
	,ShelfOrCabinet NetworkAddressShelfOrCabinet
	,CardOrTopOfRackSwitchNo NetworkAddressCardOrTopOfRackSwitchNo
	,PONPortOrSwitchNo NetworkAddressPONPortOrSwitchNo
	,PONNoOrPortNo NetworkAddressPONNoOrPortNo
	,ServiceLocationCreatedBy
	,CreatedOn
FROM [dbo].[dimaddressdetails_pbb]
;

 
GO
