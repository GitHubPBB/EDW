USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_ExistingAddressSpreadsheetSource]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[PBB_ExistingAddressSpreadsheetSource]
as
	select cmsl.LocationId as [UseLocationID]
		 ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(isnull(ServiceLocationHouseNumber,''))) + ' ' + RTRIM(LTRIM(isnull(ServiceLocationHouseSuffix,''))) + ' ' + RTRIM(LTRIM(isnull(ServiceLocationPreDirectional,''))) + ' ' + isnull(ServiceLocationStreet,'') + ' ' + RTRIM(LTRIM(isnull(ServiceLocationStreetSuffix,''))) + ' ' + RTRIM(LTRIM(isnull(ServiceLocationPostDirectional,''))) + ' ' + case
																																																																																											when ServiceLocationApartment is not null
																																																																																												and LEN(ServiceLocationApartment) > 0
																																																																																											then COALESCE('APT ' + ServiceLocationApartment,'') else ''
																																																																																										 end + ' ' + COALESCE(ServiceLocationRoom,''),'  ',' '),'  ',' '),'  ',' '))) AS FullStreetAddress
		 ,[ServiceLocationHouseNumber] as HouseNumber
		 ,[ServiceLocationHouseSuffix] as HouseSuffix
		 ,[ServiceLocationPreDirectional] as PreDirectional
		 ,[ServiceLocationStreet] as Street
		 ,[ServiceLocationStreetSuffix] as StreetSuffix
		 ,[ServiceLocationPostDirectional] as PostDirectional
		 ,[ServiceLocationApartment] as Apartment
		 ,[ServiceLocationRoom] as Room
		 ,[ServiceLocationFloor] as Floor
		 ,[ServiceLocationCity] as City
		 ,[ServiceLocationStateAbbreviation] as [State]
		 ,[ServiceLocationPostalCode] as PostalCode
		 ,[ServiceLocationPostalCodePlus4] as PostalCodePlus4
		 ,tta.TaxAreaCode as TaxAreaCode
		 ,chrr.chr_name as Region
		 ,pwc.WireCenter as WireCenter
		 ,cmsl.countyjurisdictionid as countyjurisdictionid
		 ,cmsl.districtjurisdictionid as districtjurisdictionid
		 ,ServiceLocationZone as Zone
		 ,_sl.pbb_LocationProjectCode as LocationComment
		 ,ad.ServiceLocationDescription as LocationDescription
		 ,isnull(chrsl.cus_Cabinet,'') as Cabinet
		 ,isnull(chrsl.cus_ProjectCode,'') as ProjectCode
		  --,isnull(chrsl.cus_Fiber, '') as Fiber
		 ,sl.Latitude
		 ,sl.Longitude
		 ,sl.CensusBlock
		 ,sl.CensusTract
		 ,sl.CensusStateCode
		 ,sl.CensusCountyCode
		 ,_sl.pbb_FundType as FundType
		 ,_sl.pbb_FundTypeID as FundTypeId
		 ,_sl.pbb_LocationVetroCircuitID as VetroCircuitId
		 ,_sl.pbb_Fiber as Fiber
		 ,_sl.pbb_DefaultNetworkDelivery as [NetworkDeliveryMethod]
		 ,case
			 when _sl.pbb_LocationIsServiceable = 'Yes'
			 then 1 else 0
		  end as Serviceable
		 ,case
			 when _sl.pbb_Data = 'Yes'
			 then 1 else 0
		  end as [Data]
		 ,case
			 when _sl.pbb_CATV = 'Yes'
			 then 1 else 0
		  end as [CATV]
		 ,case
			 when _sl.pbb_CATVDigital = 'Yes'
			 then 1 else 0
		  end as [CATVDigital]
		 ,case
			 when _sl.pbb_Phone = 'Yes'
			 then 1 else 0
		  end as [Phone]
		 ,case
			 when _sl.pbb_FixedWireless = 'Yes'
			 then 1 else 0
		  end as [FixedWireless]
		 ,'' as OriginalProjectName
		 ,'' as OriginalServiceable
	from [OMNIA_EPBB_P_PBB_DW].[dbo].[DimServiceLocation] sl
		inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimServiceLocation_pbb] _sl on _sl.LocationId = sl.LocationId
		left join [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].[SrvLocation] cmsl on cmsl.LocationId = sl.LocationId
		left join [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].[TaxTaxArea] tta on tta.TaxAreaID = cmsl.TaxAreaID
		left join [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].[PrdWireCenter] pwc on pwc.WireCenterID = cmsl.WireCenterID
		left join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAddressDetails_pbb] ad on ad.[Omnia SrvItemLocationID] = sl.LocationId
		left join [PBBSQL01].[PBB_P_MSCRM].[dbo].chr_servicelocation chrsl on convert(int,chrsl.chr_masterlocationid) = sl.LocationID
		left join [PBBSQL01].[PBB_P_MSCRM].[dbo].chr_CommonRegion chrr on chrsl.chr_RegionId = chrr.chr_CommonRegionId
	where [ServiceLocationHouseNumber] <> ''

GO
