USE [PBBPDW01]
GO
/****** Object:  View [dbo].[DimAddressDetails]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[DimAddressDetails]
as
	with ASL
		as (SELECT pbb_servicelocationaccountminrank.DimServiceLocationId
				,pbb_servicelocationaccountminrank.pbb_ServiceLocationAccountStatus AS 'Account-Location Status'
				,pbb_servicelocationaccountminrank.LocationAccountActivationDate AS 'Account-Service Activation Date'
				,pbb_servicelocationaccountminrank.LocationAccountDeactivationDate AS 'Account-Service Deactivation Date'
				,DimAccount.AccountCode
				,dimaccount.AccountGroupCode
				,dimaccount.AccountType
				,dimaccount.AccountTypeCode
				,dimaccount.AccountClass
				,DimAccount.AccountName
				,DimAccount.AccountEMailAddress
				,dimaccount.ACPEmail
				,dimaccount.PortalUserExists ACPUserExists
				,DimAccount.AccountPhoneNumber
				,DimAccount.BillingAddressPhone
				,DimAccount.AccountActivationDate
				,DimAccount.AccountDeactivationDate
				,pbb_servicelocationaccountminrank.LocationAccountAmount
		    FROM pbb_servicelocationaccountminrank
			    LEFT JOIN
			    (
				   SELECT DISTINCT 
						dimaccount.DimAccountID
					    ,DimAccount.AccountCode
					    ,DimAccountCategory.AccountGroupCode
					    ,AccountType
					    ,AccountTypeCode
					    ,AccountClass
					    ,Dimaccount.AccountName
					    ,AccountEMailAddress
					    ,ACPEmail
					    ,PortalUserExists
					    ,AccountPhoneNumber
					    ,BillingAddressPhone
					    ,AccountActivationDate
					    ,AccountDeactivationDate
				   FROM pbb_FactCustomerAccount_fixed
					   LEFT JOIN DimAccount ON pbb_FactCustomerAccount_fixed.DimAccountId = DimAccount.DimAccountId
					   LEFT JOIN DimAccountCategory ON pbb_FactCustomerAccount_fixed.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryID
					   LEFT JOIN PBB_AdvCustPortalCustomerData acp ON dimaccount.accountcode = acp.accountcode
				   WHERE PBB_FactCustomerAccount_Fixed.EffectiveStartDate <= GETDATE()
					    AND PBB_FactCustomerAccount_Fixed.EffectiveEndDate > GETDATE()
					    and dimaccount.DimAccountID <> 0
			    ) dimaccount ON pbb_servicelocationaccountminrank.DimAccountID = dimaccount.dimaccountid)
		Select DimServiceLocation.DimServiceLocationId
			 ,DimServiceLocation.LocationID AS 'Omnia SrvItemLocationID'
			 ,DimFMAddress.ADDRESS_Id AS 'FM AddressID'
			 ,DimServiceLocation.ServiceLocationFullAddress
			 ,LTRIM(RTRIM(ISNULL(DimServiceLocation.ServiceLocationHouseNumber,''))) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationHouseSuffix,'')) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationPreDirectional,'')) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationStreet,'')) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationStreetSuffix,'')) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationPostDirectional,'')) StreetAddress1
			 ,case
				 when DimServiceLocation.ServiceLocationApartment = ''
				 then '' else ' APT' + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationApartment,'')) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationRoom,'')) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationFloor,''))
			  end StreetAddress2
			 ,LTRIM((RTRIM(ISNULL(DimServiceLocation.ServiceLocationHouseNumber,''))) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationHouseSuffix,'')) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationPreDirectional,'')) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationStreet,'')) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationStreetSuffix,'')) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationPostDirectional,'')) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationApartment,'')) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationRoom,'')) + RTRIM(' ' + ISNULL(DimServiceLocation.ServiceLocationFloor,''))) + RTRIM(', ' + DimServiceLocation.ServiceLocationCity) + RTRIM(', ' + DimServiceLocation.ServiceLocationStateAbbreviation) AddressNoPostal
			 ,DimServiceLocation.ServiceLocationHouseNumber AS 'House Number'
			 ,DimServiceLocation.ServiceLocationHouseSuffix AS 'House Suffix'
			 ,DimServiceLocation.ServiceLocationPreDirectional AS 'PreDirectional'
			 ,DimServiceLocation.ServiceLocationStreet AS 'Street'
			 ,DimServiceLocation.ServiceLocationStreetSuffix AS 'Street Suffix'
			 ,DimServiceLocation.ServiceLocationPostDirectional AS 'PostDirectional'
			 ,DimServiceLocation.ServiceLocationApartment AS 'Apartment'
			 ,DimServiceLocation.ServiceLocationFloor AS 'Floor'
			 ,DimServiceLocation.ServiceLocationRoom AS 'Room'
			 ,DimServiceLocation.ServiceLocationCity AS 'City'
			 ,DimServiceLocation.ServiceLocationState AS 'State'
			 ,DimServiceLocation.ServiceLocationStateAbbreviation AS 'State Abbreviation'
			 ,DimServiceLocation.ServiceLocationPostalCode AS 'Postal Code'
			 ,DimServiceLocation.ServiceLocationPostalCodePlus4 AS 'Postal Code Plus 4'
			 ,DimServiceLocation.ServiceLocationCountry AS 'Country'
			 ,DimServiceLocation.ServiceLocationCountryAbbreviation AS 'Country Abbreviation'
			 ,DimServiceLocation.ServiceLocationFullAddress AS 'Full Address'
			 ,DimServiceLocation.ServiceLocationRegion_WireCenter AS 'Wirecenter Region'
			 ,DimServiceLocation.ServiceLocationRegionCode AS 'Service RegionCode'
			 ,DimServiceLocation_pbb.pbb_LocationVetroCircuitID AS 'VetroCircuitID'
			 ,Net.NetworkAddress
			 ,Net.Hostname
			 ,net.RackOrFiberRing
			 ,net.ShelfOrCabinet
			 ,net.CardOrTopOfRackSwitchNo
			 ,net.PONPortOrSwitchNo
			 ,net.PONNoOrPortNo
			 ,DimServiceLocation.Latitude
			 ,DimServiceLocation.Longitude
			 ,DimServiceLocation.ServiceLocationTaxArea AS 'Tax Area'
			 ,DimServiceLocation.CensusTract
			 ,DimServiceLocation.CensusBlock
			 ,DimServiceLocation.CensusCountyCode
			 ,DimServiceLocation.CensusStateCode
			 ,case
				 when ServiceLocationRegion_WireCenter like 'BRI%'
				 then 'BRI'
				 when ServiceLocationRegion_WireCenter like 'CPC%'
				 then 'CPC'
				 when ServiceLocationRegion_WireCenter like 'DUF%'
				 then 'DUF'
				 when ServiceLocationRegion_WireCenter like 'HAG%'
				 then 'HAG'
				 when ServiceLocationRegion_WireCenter like 'NGA%'
				 then 'NGA'
				 when ServiceLocationRegion_WireCenter like 'SWG%'
				 then 'SWG'
				 when ServiceLocationRegion_WireCenter like 'BLD%'
				 then 'BLD'
				 when ServiceLocationRegion_WireCenter like 'TAL%'
				 then 'TAL'
				 when ServiceLocationRegion_WireCenter like 'MCH%'
				 then 'MCH'
				 when ServiceLocationRegion_WireCenter like 'OHI%'
				 then 'OHI'
				 when ServiceLocationRegion_WireCenter like 'OPL%'
				 then 'OPL'
				 when DimServiceLocation.ServiceLocationTaxArea = 'AL_AUBURN - LEE'
				 then 'OPL'
				 when ServiceLocationRegion_WireCenter like '%ALA-Rural%'
				 then 'Rural AL'
				 when ServiceLocationRegion_WireCenter like 'ISL%'
				 then 'ISL'
				 when DimServiceLocation.ServiceLocationCity like '%ORANGE%BEACH%'
					 and DimServiceLocation.ServiceLocationState like '%ALABAMA%'
				 then 'ISL'
				 when ServiceLocationRegion_WireCenter like 'NYK%'
				 then 'NYK'
				 when ServiceLocationRegion_WireCenter like 'OFFNET%'
				 then 'OFFNET'
				 when DimServiceLocation.ServiceLocationState = 'NORTH CAROLINA'
				 then 'OFFNET'
							 --when ServiceLocationRegion_WireCenter like 'Inactive%' then 'INACTIVE'
				 when ServiceLocationRegion_WireCenter in('Tennessee','Virginia','Fulton Co','INACTIVE')
					 and servicelocationzone <> ''
				 then replace(ServiceLocationZone,'BVU','BRI')
				 when DimServiceLocation.ServiceLocationTaxArea in('WASHINGTON COUNTY','BRISTOL, VIRGINIA')
				 then 'BRI'
				 when ServiceLocationZone <> ''
				 then ServiceLocationZone
				 when ServiceLocationStateAbbreviation = 'VA'
				 then 'BRI'
				 when ServiceLocationStateAbbreviation = 'MD'
				 then 'HAG' else 'Unknown'
			  end as [Location Zone]
			 ,pt.value as PremiseType
			 ,case
				 when cus_marketable = 1
				 then 'Yes'
				 when cus_marketable = 0
				 then 'No' else 'Unknown'
			  end as Marketable
			 ,sl.cus_ExternalID ExternalID
			 ,subsource.FundType
			 ,subsource.FundTypeId
			 ,DimServiceLocation_pbb.pbb_LoadDate AS 'LoadDate'
			 ,DimServiceLocation_pbb.pbb_NonServiceableReason AS 'NonServiceable Reason'
			 ,case
				 when DimServiceLocation_pbb.pbb_LocationIsServiceable = 'Yes'
				 then case
						when cast(DimServiceLocation_pbb.pbb_LocationServiceableDate as date) = '1900-01-01'
						then null else cast(DimServiceLocation_pbb.pbb_LocationServiceableDate as date)
					 end else null
			  end AS 'Serviceable Date'
			 ,case
				 when DimServiceLocation_pbb.pbb_LocationIsServiceable = ''
				 then 'No'
				 when DimServiceLocation_pbb.pbb_LocationIsServiceable = 'NA'
				 then 'No' else DimServiceLocation_pbb.pbb_LocationIsServiceable
			  end AS 'LocationIsServicable'
			 ,case
				 when DimServiceLocation_pbb.pbb_Phone = ''
				 then 'Unknown' else DimServiceLocation_pbb.pbb_Phone
			  end AS 'Phone'
			 ,case
				 when DimServiceLocation_pbb.pbb_Data = ''
				 then 'Unknown' else DimServiceLocation_pbb.pbb_Data
			  end AS 'Data'
			 ,case
				 when DimServiceLocation_pbb.pbb_CATV = ''
				 then 'Unknown' else DimServiceLocation_pbb.pbb_CATV
			  end AS 'CATV'
			 ,case
				 when DimServiceLocation_pbb.pbb_CATVDigital = ''
				 then 'Unknown' else DimServiceLocation_pbb.pbb_CATVDigital
			  end AS 'CATV Digital'
			 ,DimServiceLocation_pbb.pbb_DefaultNetworkDelivery AS 'Default Network Delivery'
			 ,DimServiceLocation_pbb.pbb_FixedWireless AS 'FixedWireless'
			 ,DimServiceLocation_pbb.pbb_LocationProjectCode AS 'Project Name'
			 ,sl.cus_cabinet as Cabinet
			 ,isnull(dc.cus_distributioncentername,'') as [MDUName]
			 ,isnull(ASL.[Account-Location Status],'Unknown') AS [Account-Location Status]
			 ,ASL.[Account-Service Activation Date]
			 ,ASL.[Account-Service Deactivation Date]
			 ,DimServiceLocation.ServiceLocationComment
			 ,DimServiceLocation.ServiceLocationDescription
			 ,DimServiceLocation.ServiceLocationCountyJurisdiction
			 ,DimServiceLocation.ServiceLocationDistrictJurisdiction
			 ,DimServiceLocation.ServiceLocationLocation
			 ,DimServiceLocation.ServiceLocationCreatedBy
			 ,isnull(DimServiceLocation.ServiceLocationCreatedOn,'1-1-2010') AS 'CreatedOn'
			 ,ASL.AccountCode
			 ,ASL.AccountGroupCode
			 ,ASL.AccountType
			 ,ASL.AccountTypeCode
			 ,ASL.AccountClass
			 ,ASL.AccountName
			 ,ASL.AccountEMailAddress
			 ,ASL.ACPEmail
			 ,ASL.ACPUserExists
			 ,ASL.AccountPhoneNumber
			 ,ASL.BillingAddressPhone
			 ,ASL.AccountActivationDate
			 ,ASL.AccountDeactivationDate
			 ,ASL.LocationAccountAmount
		From FactServiceLocation
			LEFT JOIN DimServiceLocation ON FactServiceLocation.DimServiceLocationId = DimServiceLocation.DimServiceLocationID
			LEFT JOIN DimServiceLocation_pbb ON DimServiceLocation.LocationId = DimServiceLocation_pbb.LocationId
			LEFT JOIN DimFMAddress ON FactServiceLocation.DimFMAddressId = DimFMAddress.DimFMAddressId
			left join PBB_AddressNetworkCircuitID NET on DimServiceLocation.LocationId = net.srvlocation_locationid
			left join pbbsql01.[PBB_P_MSCRM].dbo.chr_servicelocation sl on DimServiceLocation.locationid = sl.chr_masterlocationid
			left join [PBB_AddressSubsidySourceAggregate] subsource on subsource.cus_ServiceLocationId = sl.chr_servicelocationid
			left join pbbsql01.[PBB_P_MSCRM].[dbo].cus_distributioncenterBase dc with(NOLOCK) on dc.cus_distributioncenterId = sl.cus_ServiceLocationsId
			left join PBB_StringMapBaseJoin('chr_servicelocation','cus_premisetype') pt on sl.cus_premisetype = pt.JoinOnValue
			left join ASL on ASL.DimServiceLocationId = FactServiceLocation.DimServiceLocationId
		Where pbb_LocationProjectCode not in
									 (
									  'Duplicate - Do Not Use'
									 ,'PC-Duplicate - Do Not Use'
									 ,'PC-TEST/INTERNAL ONLY-EXCLUDED FROM SERVICEABLE PASSINGS'
									 )

GO
