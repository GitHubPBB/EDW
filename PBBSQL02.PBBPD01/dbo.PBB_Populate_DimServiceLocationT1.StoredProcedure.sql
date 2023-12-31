USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_DimServiceLocationT1]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Todd Boyer
-- Create date: 2023-10-11
-- Description:	Load DimServiceLocationT1
-- Version:     1.0	Initial Version
--
-- =============================================
CREATE PROCEDURE [dbo].[PBB_Populate_DimServiceLocationT1]
	
AS
BEGIN


	DROP TABLE if exists #TempMDU;
		SELECT Distinct dsl.DimServiceLocationId
			 , dsl.LocationId
			 , dsl.ServiceLocationFullAddress
			 , dc.cus_DistributionCenterName
			 , ab.AccountNumber as MDUAccountCode
			 , case when csl.cus_Serviceable = '972050000' then 'Y' else 'N'  end ServiceableAddress
			 , case when ab.AccountNumber  is not null then 'Bulk' else 'MDU' end BulkMduCode
		  INTO #TempMDU
		  FROM Transient.cus_DistributionCenterBase         dc   
		  JOIN Transient.chr_servicelocation                csl  on dc.cus_distributioncenterId   = csl.cus_ServiceLocationsId
		  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation dsl  on dsl.locationid                = csl.chr_masterlocationid
		  LEFT JOIN Transient.AccountBase                   ab   ON ab.AccountId                  = dc.cus_BulkBillingAccount  
	;

	DROP TABLE if exists #TempCabinet;
 
				SELECT chr_masterlocationid AS LocationId 
					 , coalesce( cus_Cabinet, c.cus_name) AS CabinetName
					 , cast(ps.ServiceableDate as date) ServiceableDate
				  INTO #TempCabinet
				  FROM      PBBSQL01.[PBB_P_MSCRM].[dbo].[chr_servicelocationBase] slb with(NOLOCK) 
				  left join PBBSQL01.[PBB_P_MSCRM].[dbo].[cus_cabinetBase]  c with(NOLOCK) on c.cus_cabinetId = slb.cus_CabinetName
				  left join [OMNIA_EPBB_P_PBB_DW].[dbo].[PrjServiceability] ps on ps.ProjectName collate Latin1_General_CI_AI= cus_ProjectCode collate Latin1_General_CI_AI
				  where cus_cabinet is not null
					and cus_cabinet <>'Unknown'
	;

	DROP TABLE if exists #TempAccountGroupCode;
	select distinct  left(AccountGroupCode,3) AccountGroupCode,  pbb_ReportingMarket
	into #TempAccountGroupCode
	from OMNIA_EPBB_P_PBB_DW..DimAccountCategory dac 
	join omnia_epbb_p_pbb_dw..DimAccountCategory_pbb dacp on dacp.sourceid = dac.sourceid
	where AccountGroupCode <>'' and pbb_ReportingMarket <>''
	order by  1
	;
	 

	DECLARE @MaxKey bigint;
	SELECT @MaxKey = max(DimServiceLocationKey) FROM  pbbpdw01.[dbo].[DimServiceLocationT1] ;

	DROP TABLE if exists #TempServiceLocation;


	SELECT   
		 case when dslo.LocationId is not null then dslo.DimServiceLocationKey else row_number() over (partition by dslo.DimServiceLocationKey  order by dsl.DimServiceLocationId) +@MaxKey end DimServiceLocationKey 
		 --,dslo.DimServiceLocationKey DslOKey
		,dsl.DimServiceLocationId
		,dsl.LocationId
		,dsl.ServiceLocationFullAddress
		,dsl.Latitude
		,dsl.Longitude
		,dm.DimMarketKey
		,dp.DimProjectKey
		,d2.pbb_LocationProjectCode ProjectCode  
		,cab.CabinetName
		,mdu.cus_DistributionCenterName DistributionCenter
		,case when coalesce(mdu.BulkMduCode,'') = 'MDU'  then 1 else 0 end IsMDU
		,case when coalesce(mdu.BulkMduCode,'') = 'Bulk' then 1 else 0 end IsBulk
		,d2.pbb_LocationVetroCircuitId                                     VetroCircuitId 
		,case when d2.pbb_LocationIsServiceable  ='Yes' then 1 else 0 end  IsServiceable  
		,case when cast(left(d1.pbb_LocationServiceableDate, 11) as date) ='1900-01-01' then '99991231' else  cast(left(d1.pbb_LocationServiceableDate, 11) as date) end ServiceableDate  
		,d2.pbb_NonServiceableReason    NonServiceableReason  
		,case when left(d2.pbb_Data ,3)  = 'Yes' then 1 else 0 end IsDataServiceable  
		,case when left(d2.pbb_Phone ,3) = 'Yes' then 1 else 0 end IsPhoneServiceable  
		,d2.pbb_Fiber                   FiberTechnology  -- Active E / GPON
		,d2.pbb_DefaultNetworkDelivery  DefaultNetworkDelivery  
		,d2.pbb_FundType                FundType  
		,d2.pbb_FundTypeID              FundTypeId
		,case when left(d2.pbb_Marketable,3) = 'Yes' then 1 else 0 end    IsMarketable
		,d2.pbb_PremiseType             PremiseType

		,dsl.CensusTract
		,dsl.CensusBlock
		,dsl.CensusStateCode
		,dsl.CensusCountyCode
		,dsl.ServiceLocationCity
		,dsl.ServiceLocationCassCity
		,dsl.ServiceLocationState
		,dsl.ServiceLocationStateAbbreviation
		,dsl.ServiceLocationCountry
		,dsl.ServiceLocationCountryAbbreviation
		,dsl.ServiceLocationMetroArea
		,dsl.ServiceLocationTaxAreaCode
		,dsl.ServiceLocationTaxArea
		,dsl.ServiceLocationCountyJurisdiction
		,dsl.ServiceLocationDistrictJurisdiction
		,dsl.ServiceLocationZone
		,dsl.ServiceLocationDefaultZone
		,dsl.ServiceLocationRegion_WireCenter
		,dsl.ServiceLocationHouseNumber
		,dsl.ServiceLocationHouseSuffix
		,dsl.ServiceLocationApartment
		,dsl.ServiceLocationFloor
		,dsl.ServiceLocationRoom
		,dsl.ServiceLocationLocation
		,dsl.ServiceLocationPostalCode
		,dsl.ServiceLocationPostalCodePlus4
		,dsl.ServiceLocationStreet
		,dsl.ServiceLocationPreDirectional
		,dsl.ServiceLocationStreetSuffix
		,dsl.ServiceLocationPostDirectional
		,dsl.ServiceLocationRegionCode
		,dsl.ServiceLocationStatusReason
		,dsl.ServiceLocationStatus
		,dsl.ServiceLocationCreatedBy 
		,dsl.ServiceLocationCreatedOn
		,dsl.ServiceLocationComment
		,dsl.ServiceLocationDescription
		,case when dslo.LocationId is null then getdate() else dslo.MetaEffectiveStartDatetime end [MetaEffectiveStartDatetime]  
		,'99991231' [MetaEffectiveEndDatetime]  
		,case when dslo.LocationId is null then coalesce(dsl.ServiceLocationCreatedOn,getdate()) else dslo.MetaInsertDateTime end [MetaInsertDatetime]  
		,'Y' MetaCurrRecInd
		,'I' MetaOperationCode
		,0   MetaEtlProcessId
		,'CHR DW' MetaSourceSystemCode
	into #TempServiceLocation
	from      omnia_epbb_p_pbb_dw.dbo.DimServiceLocation       dsl
	left join omnia_epbb_p_pbb_dw.dbo.DimServiceLocation_pbb   d1  on dsl.LocationId             = d1.LocationId
	left join omnia_epbb_p_pbb_dw.dbo.DimServiceLocationV2_pbb d2  on dsl.DimServiceLocationId   = d2.DimServiceLocationId
	left join #TempMDU                                         mdu on mdu.DimServiceLocationId   = dsl.DimServiceLocationId
	left join #TempCabinet                                     cab on cab.LocationId             = dsl.LocationId
	left join #TempAccountGroupCode                            agc on agc.AccountGroupCode       = dsl.ServiceLocationZone
	left join pbbpdw01..DimMarketT1                            dm  on dm.ReportingMarketName     = agc.pbb_ReportingMarket
	left join pbbpdw01..DimProjectT1                           dp  on d2.pbb_LocationProjectCode = dp.ProjectCode collate database_default 
	left join  pbbpdw01.[dbo].DimServiceLocationT1             dslo on dslo.LocationId = dsl.LocationId
	where dsl.DimServiceLocationId <> 0  
	;
 


 

	truncate table pbbpdw01.[dbo].[DimServiceLocationT1] 

	insert into  pbbpdw01.[dbo].[DimServiceLocationT1] select * from  #TempServiceLocation ;


    -- select top 100 * from #TempServiceLocation order by 1 desc 


END
GO
