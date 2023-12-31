USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[Populate_DimServiceLocationT1]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Populate_DimServiceLocationT1]
	
AS

-- ====================================================================  
-- Description:	T1 load procedure for ServiceLocationT1 table
--
-- Input:     void
--
-- Change histrory: 
-- Name			Author		Date		Version		Description 
-- Comment      Vinit/Todd  10/27/2023   01.00       Initial version
--              Todd        11/15/2023   01.01       Added Natural Key Columns
--              Sunil       12/04/2023   01.02       Added fix for duplicates
-- ====================================================================

BEGIN
-----------------------------------------------------------------------------------------------------------------------------------------------
-- Start Logging
-----------------------------------------------------------------------------------------------------------------------------------------------

	DECLARE @Version				  VARCHAR(10) = 'v1.01';
	DECLARE @LogParentID              numeric(18,0)
	DECLARE @ProcessDate			  DATE;
	DECLARE @RC						  int
	DECLARE @EtlName				  varchar(50)        
	DECLARE @V_LoadDttm				  varchar(40)             = GETDATE()
	DECLARE @ProcGUID				  varchar(50)
	DECLARE @ExecutionGUID			  varchar(50)
	DECLARE @MachineName			  varchar(50)             = HOST_NAME()
	DECLARE @UserName				  varchar(50)             = SUSER_NAME()
	DECLARE @ExecutionStep			  varchar(1000)
	DECLARE @ExecutionMsg			  varchar(MAX)          
	DECLARE @LogID					  numeric(18,0)           = @LogParentID 
	DECLARE @V_Table                  varchar(MAX)
	DECLARE @V_TargetSchema           varchar(MAX)
	DECLARE @V_ExecutionGroup         varchar(MAX)
	DECLARE @V_CurrentTimestamp		  datetime				  = GETDATE()

	DECLARE @MaxKey bigint;

	SET NOCOUNT ON;
	SET XACT_ABORT ON;

BEGIN TRY
SELECT @LogParentID = COALESCE(MAX(LogParentID)+1,100000) FROM PBBPDW01.info.ExecutionLog
SET @V_ExecutionGroup = 'Load into T1 Table'
SET @V_TargetSchema = 'dbo'
SET @V_Table = 'DimServiceLocationT1'
SET @ExecutionMsg = 'Starting Process'
SET @EtlName = concat(@V_TargetSchema, '.', @V_Table);	
SET @ExecutionStep = concat(@EtlName,'|' , 'Step01');

	EXECUTE @RC = info.ExecutionLogStart
	   @LogParentID
	  ,@V_ExecutionGroup
	  ,@V_TargetSchema
	  ,@V_Table
	  ,@V_LoadDttm
	  ,@ProcGUID 
	  ,@ExecutionGUID 
	  ,@MachineName 
	  ,@UserName 
	  ,NULL
	  ,@ExecutionMsg 
	  ,@LogID OUTPUT;

---------------------------------------------------------
-- Step 1 - Recreating and inserting data into #TempMDU
---------------------------------------------------------


	SET @ExecutionMsg = 'Drop and Recreate Temporary Table #TempMDU'

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;

	DROP TABLE if exists #TempMDU;
		SELECT Distinct dsl.DimServiceLocationId
			 , dsl.LocationId
			 , dsl.ServiceLocationFullAddress
			 , dc.cus_DistributionCenterName
			 , ab.AccountNumber as MDUAccountCode
			 , case when csl.cus_Serviceable = '972050000' then 1 else 0  end ServiceableAddress
			 , case when ab.AccountNumber  is not null then 'Bulk' else 'MDU' end BulkMduCode
		  INTO #TempMDU
		  FROM [PBBPACQ01].[ACQPbbMSCRM].cus_DistributionCenterBase         dc   
		  JOIN [PBBPACQ01].[ACQPbbMSCRM].chr_servicelocation                csl  on dc.cus_distributioncenterId   = csl.cus_ServiceLocationsId
		                                                                         AND csl.MetaCurrentRecordIndicator = '1'
																				 AND csl.MetaOperationCode <> 'D'
		  JOIN [PBBPACQ01].AcqPbbDW.DimServiceLocation                      dsl  on dsl.locationid                = csl.chr_masterlocationid 
																				 AND dsl.MetaCurrentRecordIndicator = '1' 
		                                                                         AND dsl.MetaOperationCode <> 'D' --[PBBACQ01]
		  LEFT JOIN [PBBPACQ01].[ACQPbbMSCRM].AccountBase                   ab   ON ab.AccountId                  = dc.cus_BulkBillingAccount  
		                                                                         AND ab.MetaCurrentRecordIndicator = '1'
																				 AND ab.MetaOperationCode <> 'D'
		  WHERE dc.MetaCurrentRecordIndicator = '1'
				AND dc.MetaOperationCode <> 'D'
	;
	
	

-------------------------------------------------------------
-- Step 2 - Recreating and inserting data into #TempCabinet
--------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step02');
	SET @ExecutionMsg = 'Drop and Recreate Temporary Table #TempCabinet';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;


	DROP TABLE if exists #TempCabinet;

					SELECT slb.chr_masterlocationid collate DATABASE_DEFAULT AS LocationId 
                     , coalesce( slb.cus_Cabinet collate DATABASE_DEFAULT, c.cus_name collate DATABASE_DEFAULT) AS CabinetName
                     , cast(ps.ServiceableDate as date) ServiceableDate
                  INTO #TempCabinet
                  FROM [PBBPACQ01].[AcqPBBMSCRM].[chr_servicelocationBase]                slb with(NOLOCK) 
                  left join [PBBSQL01.PBBO360.INT].[PBB_P_MSCRM].[dbo].[cus_cabinetBase]  c with(NOLOCK) on c.cus_cabinetId = slb.cus_CabinetName
				                                                                             
                  left join [PBBPACQ01].[AcqPbbDW].[PrjServiceability]                    ps on ps.ProjectName collate DATABASE_DEFAULT= slb.cus_ProjectCode collate DATABASE_DEFAULT
                                                                                             AND ps.MetaCurrentRecordIndicator = '1' AND ps.MetaOperationCode <> 'D' -- add and condition
                  where cus_cabinet is not null
                    and cus_cabinet <>'Unknown'
                    and slb.MetaCurrentRecordIndicator = '1'
                    and slb.MetaOperationCode <> 'D'

	;
	

---------------------------------------------------------------------
-- Step 3 - Recreating and inserting data into #TempAccountGroupCode
---------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step03');
	SET @ExecutionMsg = 'Drop and Recreate Temporary Table #TempAccountGroupCode';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;


	
	DROP TABLE if exists #TempAccountGroupCode;
	select distinct  left(AccountGroupCode,3) AccountGroupCode,  pbb_ReportingMarket
	  into #TempAccountGroupCode
	  from [PBBPACQ01].[AcqPbbDW].DimAccountCategory dac 
	  join [PBBPACQ01].[AcqPbbDW].DimAccountCategory_pbb dacp on dacp.sourceid = dac.sourceid and dacp.MetaCurrentRecordIndicator = '1' and dacp.MetaOperationCode <> 'D'
	 where AccountGroupCode <>'' and pbb_ReportingMarket <>''
	   and dac.MetaCurrentRecordIndicator = '1' 
	   and dac.MetaOperationCode <> 'D'
	 order by  1
	;
	 
	  


----------------------------------------------------------------------
-- Step 4 - Recreating and inserting data into #TempServiceLocation
----------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step04');
	SET @ExecutionMsg = 'Drop and Recreate Temporary Table #TempServiceLocation, pulling data from DimServiceLocation_pbb T0 table as well as DimMarket and DimProject T1 tables';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	      ,@ExecutionMsg;

			-- DECLARE @MaxKey bigint;
	SELECT @MaxKey = coalesce(max(DimServiceLocationKey),0) FROM  [dbo].[DimServiceLocationT1] ;

	DROP TABLE if exists #TempServiceLocation;


	SELECT   
		 case when dslo.LocationId is not null then dslo.DimServiceLocationId else row_number() over (partition by dslo.DimServiceLocationId  order by dsl.DimServiceLocationId) +@MaxKey end DimServiceLocationKey 
		 --,dslo.DimServiceLocationKey DslOKey
		,dsl.LocationId DimServiceLocationNaturalKey
		,'LocationId' DimServiceLocationNaturalKeyFields
		,dsl.DimServiceLocationId
		,dsl.LocationId
		,dsl.ServiceLocationFullAddress
		,dsl.Latitude
		,dsl.Longitude
		,coalesce(dm.DimMarketKey,0) DimMarketKey
		,coalesce(dp.DimProjectKey,0) DimProjectKey
		,d2.pbb_LocationProjectCode ProjectCode  
		,cab.CabinetName
		,mdu.cus_DistributionCenterName DistributionCenter
		,case when coalesce(mdu.BulkMduCode,'') = 'MDU'  then 1 else 0 end IsMDU
		,case when coalesce(mdu.BulkMduCode,'') = 'Bulk' then 1 else 0 end IsBulk
		,d2.pbb_LocationVetroCircuitId                                     VetroCircuitId 
		,case when d2.pbb_LocationIsServiceable  ='Yes' then 1 else 0 end  IsServiceable  
		,case when dp.DimProjectKey is not null then dp.ProjectServiceableDate
		      when cast(left(d1.pbb_LocationServiceableDate, 11) as date) ='1900-01-01' then '99991231' 
		      else coalesce(cast(left(d1.pbb_LocationServiceableDate, 11) as date),'99991231') 
		  end ServiceableDate  
		,d2.pbb_NonServiceableReason    NonServiceableReason  
		,case when left(d2.pbb_Data ,3)  = 'Yes' then 1 else 0 end IsDataServiceable  
		,case when left(d2.pbb_Phone ,3) = 'Yes' then 1 else 0 end IsPhoneServiceable  
		,cast('99991231' as date) EarliestAccountActivationDate
		,d2.pbb_Fiber                   FiberTechnology  -- Active E / GPON
		,d2.pbb_DefaultNetworkDelivery  DefaultNetworkDelivery  
		,d2.pbb_FundType                FundType  
		,d2.pbb_FundTypeID              FundId
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
		, 1 MetaCurrRecInd
		,'I' MetaOperationCode
		,0   MetaEtlProcessId
		,'CHR DW' MetaSourceSystemCode
	into #TempServiceLocation
	from      [PBBPACQ01].[AcqPbbDW].DimServiceLocation                   dsl
	left join [PBBPACQ01].[AcqPbbDW].DimServiceLocation_pbb               d1    on dsl.LocationId             = d1.LocationId and d1.MetaCurrentRecordIndicator = '1' and d1.MetaOperationCode <> 'D'
	left join [PBBSQL02].omnia_epbb_p_pbb_dw.dbo.DimServiceLocationV2_pbb d2    on dsl.DimServiceLocationId   = d2.DimServiceLocationId
	left join #TempMDU                                                    mdu   on mdu.DimServiceLocationId   = dsl.DimServiceLocationId
	left join #TempCabinet                                                cab   on cab.LocationId             = dsl.LocationId
	left join #TempAccountGroupCode                                       agc   on agc.AccountGroupCode       = dsl.ServiceLocationZone
	left join [dbo].DimMarketT1                                           dm    on dm.ReportingMarketName     = agc.pbb_ReportingMarket
	left join [dbo].DimProjectT1                                          dp    on d2.pbb_LocationProjectCode = dp.ProjectCode collate database_default 
	left join [dbo].DimServiceLocationT1                                  dslo  on dslo.LocationId = dsl.LocationId and dslo.MetaCurrRecInd = 1
	where dsl.DimServiceLocationId <> 0 
	and dsl.MetaCurrentRecordIndicator = '1'
	and dsl.MetaOperationCode <> 'D'
	;

			-- select * from #TempServiceLocation



------------------------------------------------------------------------------------
-- Step 5 -  Recreating and inserting data into #TempLocationFirstActivation
------------------------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step05');
	SET @ExecutionMsg = 'Drop and Recreate Temporary Table #TempLocationFirstActivation, pulling data from DimServiceLocation and FactCustomerItem';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	      ,@ExecutionMsg;


		  
	DROP TABLE if exists #TempLocationFirstActivation;
	SELECT * INTO #TempLocationFirstActivation
      FROM (
			  select dsl.LocationId, min(Activation_DimDateId) minAccountActivationDt
				from PBBPACQ01.AcqPbbDW.FactCustomerItem fci
				join PBBPACQ01.AcqPbbDW.DimServiceLocation dsl on dsl.DimServiceLocationid = fci.dimservicelocationid and dsl.MetaCurrentRecordIndicator = 1
				join #TempServiceLocation dsl1 on dsl1.LocationId = dsl.LocationId -- and dsl1.ServiceableDate ='99991231'
				where fci.MetaCurrentRecordIndicator = 1
				group by dsl.LocationId
	       ) x
	;

	UPDATE sa
	   set EarliestAccountActivationDate = case when lfa.minAccountActivationDt < sa.EarliestAccountActivationDate then lfa.minAccountActivationDt
	                                            else sa.EarliestAccountActivationDate
											end
	  FROM #TempServiceLocation         sa
	  JOIN #TempLocationFirstActivation lfa on  lfa.LocationId = sa.LocationId
	                                        and lfa.minAccountActivationDt < sa.EarliestAccountActivationDate
	;

	UPDATE sa
	   set ServiceableDate           = case when lfa.minAccountActivationDt < sa.ServiceableDate then lfa.minAccountActivationDt
	                                            else sa.ServiceableDate
											end
	  FROM #TempServiceLocation         sa
	  JOIN #TempLocationFirstActivation lfa on  lfa.LocationId = sa.LocationId
	                                        and lfa.minAccountActivationDt < sa.ServiceableDate
	;

	UPDATE sa
	   SET IsServiceable = 1
	  FROM #TempServiceLocation sa
	  WHERE sa.ServiceableDate < '99991231'
	;

------------------------------------------------------------------------------------
-- Step 6 - Inserting new records from #TempServiceLocation to DimServiceLocationT1
------------------------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step06');
	SET @ExecutionMsg = 'Insert into DimServiceLocationT1 Table all the new records coming from #TempServiceLocation';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;


	INSERT INTO dbo.DimServiceLocationT1(DimServiceLocationKey
	                                    ,DimServiceLocationNaturalKey
										,DimServiceLocationNaturalKeyFields
	                                    ,DimServiceLocationId
										,LocationId
										,ServiceLocationFullAddress
										,Latitude
										,Longitude
										,DimMarketKey
										,DimProjectKey
										,ProjectCode
										,CabinetName
										,DistributionCenter
										,IsMdu
										,IsBulk
										,VetroCircuitId
										,IsServiceable
										,ServiceableDate
										,NonServiceableReason
										,IsDataServiceable
										,IsPhoneServiceable
										,EarliestAccountActivationDate
										,FiberTechnology
										,DefaultNetworkDelivery
										,FundType
										,FundId
										,IsMarketable
										,PremiseType
										,CensusTract
										,CensusBlock
										,CensusStateCode
										,CensusCountyCode
										,ServiceLocationCity
										,ServiceLocationCassCity
										,ServiceLocationState
										,ServiceLocationStateAbbreviation
										,ServiceLocationCountry
										,ServiceLocationCountryAbbreviation
										,ServiceLocationMetroArea
										,ServiceLocationTaxAreaCode
										,ServiceLocationTaxArea
										,ServiceLocationCountyJurisdiction
										,ServiceLocationDistrictJurisdiction
										,ServiceLocationZone
										,ServiceLocationDefaultZone
										,ServiceLocationRegion_WireCenter
										,ServiceLocationHouseNumber
										,ServiceLocationHouseSuffix
										,ServiceLocationApartment
										,ServiceLocationFloor
										,ServiceLocationRoom
										,ServiceLocationLocation
										,ServiceLocationPostalCode
										,ServiceLocationPostalCodePlus4
										,ServiceLocationStreet
										,ServiceLocationPreDirectional
										,ServiceLocationStreetSuffix
										,ServiceLocationPostDirectional
										,ServiceLocationRegionCode
										,ServiceLocationStatusReason
										,ServiceLocationStatus
										,ServiceLocationCreatedBy
										,ServiceLocationCreatedOn
										,ServiceLocationComment
										,ServiceLocationDescription
										,MetaEffectiveStartDatetime
										,MetaEffectiveEndDatetime
										,MetaInsertDatetime
										,MetaCurrRecInd
										,MetaOperationCode
										,MetaEtlProcessId
										,MetaSourceSystemCode)
SELECT	 tsl.DimServiceLocationKey
        ,tsl.DimServiceLocationNaturalKey
		,tsl.DimServiceLocationNaturalKeyFields
        ,tsl.DimServiceLocationId
		,tsl.LocationId
		,tsl.ServiceLocationFullAddress
		,tsl.Latitude
		,tsl.Longitude
		,coalesce(tsl.DimMarketKey,0)
		,coalesce(tsl.DimProjectKey,0)
		,tsl.ProjectCode
		,tsl.CabinetName
		,tsl.DistributionCenter
		,tsl.IsMdu
		,tsl.IsBulk
		,tsl.VetroCircuitId
		,tsl.IsServiceable
		,tsl.ServiceableDate
		,tsl.NonServiceableReason
		,tsl.IsDataServiceable
		,tsl.IsPhoneServiceable
		,tsl.EarliestAccountActivationDate
		,tsl.FiberTechnology
		,tsl.DefaultNetworkDelivery
		,tsl.FundType
		,tsl.FundId
	    ,tsl.IsMarketable
		,tsl.PremiseType
		,tsl.CensusTract
		,tsl.CensusBlock
		,tsl.CensusStateCode
		,tsl.CensusCountyCode
		,tsl.ServiceLocationCity
		,tsl.ServiceLocationCassCity
		,tsl.ServiceLocationState
		,tsl.ServiceLocationStateAbbreviation
		,tsl.ServiceLocationCountry
		,tsl.ServiceLocationCountryAbbreviation
		,tsl.ServiceLocationMetroArea
		,tsl.ServiceLocationTaxAreaCode
		,tsl.ServiceLocationTaxArea
		,tsl.ServiceLocationCountyJurisdiction
		,tsl.ServiceLocationDistrictJurisdiction
		,tsl.ServiceLocationZone
		,tsl.ServiceLocationDefaultZone
		,tsl.ServiceLocationRegion_WireCenter
		,tsl.ServiceLocationHouseNumber
		,tsl.ServiceLocationHouseSuffix
		,tsl.ServiceLocationApartment
		,tsl.ServiceLocationFloor
		,tsl.ServiceLocationRoom
		,tsl.ServiceLocationLocation
		,tsl.ServiceLocationPostalCode
		,tsl.ServiceLocationPostalCodePlus4
		,tsl.ServiceLocationStreet
		,tsl.ServiceLocationPreDirectional
		,tsl.ServiceLocationStreetSuffix
		,tsl.ServiceLocationPostDirectional
		,tsl.ServiceLocationRegionCode
		,tsl.ServiceLocationStatusReason
		,tsl.ServiceLocationStatus
		,tsl.ServiceLocationCreatedBy
		,tsl.ServiceLocationCreatedOn
		,tsl.ServiceLocationComment
		,tsl.ServiceLocationDescription
		,tsl.MetaEffectiveStartDatetime
		,tsl.MetaEffectiveEndDatetime
		,tsl.MetaInsertDatetime
		,tsl.MetaCurrRecInd
		,tsl.MetaOperationCode
		,tsl.MetaEtlProcessId
		,tsl.MetaSourceSystemCode
  FROM #TempServiceLocation tsl
  LEFT JOIN dbo.DimServiceLocationT1 dsl
  ON tsl.DimServiceLocationId = dsl.DimServiceLocationId
  WHERE dsl.DimServiceLocationId IS NULL


------------------------------------------------------------------------------------
-- Step 7 - Update existing records from DimServiceLocationT1
------------------------------------------------------------------------------------
SET @ExecutionStep = concat(@EtlName,'|' , 'Step07');
SET @ExecutionMsg = 'Update Existing rows in DimServiceLocationT1 Table using fresh data from #TempServiceLocation';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;




	UPDATE dbo.DimServiceLocationT1
	SET LocationId = tsl.LocationId
	    ,DimServiceLocationNaturalKey = tsl.DimServiceLocationNaturalKey
		,ServiceLocationFullAddress = tsl.ServiceLocationFullAddress
		,Latitude = tsl.Latitude
		,Longitude =  tsl.Longitude
		,DimMarketKey = tsl.DimMarketKey
		,DimProjectKey = tsl.DimProjectKey
		,ProjectCode = tsl.ProjectCode
		,CabinetName = tsl.CabinetName
		,DistributionCenter = tsl.DistributionCenter
		,IsMdu = tsl.IsMdu
		,IsBulk = tsl.IsBulk
		,VetroCircuitId = tsl.VetroCircuitId
		,IsServiceable = tsl.IsServiceable
		,ServiceableDate = tsl.ServiceableDate
		,NonServiceableReason = tsl.NonServiceableReason
		,IsDataServiceable = tsl.IsDataServiceable
		,IsPhoneServiceable = tsl.IsPhoneServiceable
		,EarliestAccountActivationDate = tsl.EarliestAccountActivationDate
		,FiberTechnology = tsl.FiberTechnology
		,DefaultNetworkDelivery = tsl.DefaultNetworkDelivery
		,FundType = tsl.FundType
		,FundId = tsl.FundId
		,IsMarketable = tsl.IsMarketable
		,PremiseType = tsl.PremiseType
		,CensusTract = tsl.CensusTract
		,CensusBlock = tsl.CensusBlock
		,CensusStateCode = tsl.CensusStateCode
		,CensusCountyCode = tsl.CensusCountyCode
		,ServiceLocationCity = tsl.ServiceLocationCity
		,ServiceLocationCassCity = tsl.ServiceLocationCassCity
		,ServiceLocationState = tsl.ServiceLocationState
		,ServiceLocationStateAbbreviation = tsl.ServiceLocationStateAbbreviation
		,ServiceLocationCountry = tsl.ServiceLocationCountry
		,ServiceLocationCountryAbbreviation = tsl.ServiceLocationCountryAbbreviation
		,ServiceLocationMetroArea = tsl.ServiceLocationMetroArea
		,ServiceLocationTaxAreaCode = tsl.ServiceLocationTaxAreaCode
		,ServiceLocationTaxArea = tsl.ServiceLocationTaxArea
		,ServiceLocationCountyJurisdiction = tsl.ServiceLocationCountyJurisdiction
		,ServiceLocationDistrictJurisdiction = tsl.ServiceLocationDistrictJurisdiction
		,ServiceLocationZone = tsl.ServiceLocationZone
		,ServiceLocationDefaultZone = tsl.ServiceLocationDefaultZone
		,ServiceLocationRegion_WireCenter = tsl.ServiceLocationRegion_WireCenter
		,ServiceLocationHouseNumber = tsl.ServiceLocationHouseNumber
		,ServiceLocationHouseSuffix = tsl.ServiceLocationHouseSuffix
		,ServiceLocationApartment = tsl.ServiceLocationApartment
		,ServiceLocationFloor = tsl.ServiceLocationFloor
		,ServiceLocationRoom = tsl.ServiceLocationRoom
		,ServiceLocationLocation = tsl.ServiceLocationLocation
		,ServiceLocationPostalCode = tsl.ServiceLocationPostalCode
		,ServiceLocationPostalCodePlus4 = tsl.ServiceLocationPostalCodePlus4
		,ServiceLocationStreet = tsl.ServiceLocationStreet
		,ServiceLocationPreDirectional = tsl.ServiceLocationPreDirectional
		,ServiceLocationStreetSuffix = tsl.ServiceLocationStreetSuffix
		,ServiceLocationPostDirectional = tsl.ServiceLocationPostDirectional
		,ServiceLocationRegionCode = tsl.ServiceLocationRegionCode
		,ServiceLocationStatusReason = tsl.ServiceLocationStatusReason
		,ServiceLocationStatus = tsl.ServiceLocationStatus
		,ServiceLocationCreatedBy = tsl.ServiceLocationCreatedBy
		,ServiceLocationCreatedOn = tsl.ServiceLocationCreatedOn
		,ServiceLocationComment = tsl.ServiceLocationComment
		,ServiceLocationDescription = tsl.ServiceLocationDescription
		,MetaEffectiveStartDatetime = tsl.MetaEffectiveStartDatetime
		,MetaEffectiveEndDatetime = tsl.MetaEffectiveEndDatetime
		,MetaCurrRecInd = tsl.MetaCurrRecInd
		, MetaOperationCode = 'U'
		,MetaEtlProcessId = tsl.MetaEtlProcessId
		,MetaSourceSystemCode = tsl.MetaSourceSystemCode -- all columns, op code U
	FROM #TempServiceLocation tsl
    JOIN dbo.DimServiceLocationT1 dsl
    ON tsl.DimServiceLocationId = dsl.DimServiceLocationId
	WHERE dsl.LocationId <> tsl.LocationId
		OR dsl.ServiceLocationFullAddress <> tsl.ServiceLocationFullAddress
		OR dsl.Latitude <> tsl.Latitude
		OR dsl.Longitude <>  tsl.Longitude
		OR dsl.DimMarketKey <> tsl.DimMarketKey
		OR dsl.DimProjectKey <> tsl.DimProjectKey
		OR dsl.ProjectCode COLLATE DATABASE_DEFAULT <> tsl.ProjectCode COLLATE DATABASE_DEFAULT
		OR dsl.CabinetName <> tsl.CabinetName
		OR dsl.DistributionCenter <> tsl.DistributionCenter
		OR dsl.IsMdu <> tsl.IsMdu
		OR dsl.IsBulk <> tsl.IsBulk
		OR dsl.VetroCircuitId COLLATE DATABASE_DEFAULT <> tsl.VetroCircuitId COLLATE DATABASE_DEFAULT
		OR dsl.IsServiceable <> tsl.IsServiceable
		OR dsl.ServiceableDate <> tsl.ServiceableDate
		OR dsl.NonServiceableReason COLLATE DATABASE_DEFAULT <> tsl.NonServiceableReason COLLATE DATABASE_DEFAULT
		OR dsl.IsDataServiceable <> tsl.IsDataServiceable
		OR dsl.IsPhoneServiceable <> tsl.IsPhoneServiceable
		OR dsl.FiberTechnology COLLATE DATABASE_DEFAULT <> tsl.FiberTechnology COLLATE DATABASE_DEFAULT
		OR dsl.DefaultNetworkDelivery COLLATE DATABASE_DEFAULT <> tsl.DefaultNetworkDelivery COLLATE DATABASE_DEFAULT
		OR dsl.FundType COLLATE DATABASE_DEFAULT <> tsl.FundType COLLATE DATABASE_DEFAULT
		OR dsl.FundId COLLATE DATABASE_DEFAULT <> tsl.FundId COLLATE DATABASE_DEFAULT
		OR dsl.IsMarketable <> tsl.IsMarketable
		OR dsl.PremiseType COLLATE DATABASE_DEFAULT <> tsl.PremiseType COLLATE DATABASE_DEFAULT
		OR dsl.CensusTract <> tsl.CensusTract
		OR dsl.CensusBlock <> tsl.CensusBlock
		OR dsl.CensusStateCode <> tsl.CensusStateCode
		OR dsl.CensusCountyCode <> tsl.CensusCountyCode
		OR dsl.ServiceLocationCity <> tsl.ServiceLocationCity
		OR dsl.ServiceLocationCassCity <> tsl.ServiceLocationCassCity
		OR dsl.ServiceLocationState <> tsl.ServiceLocationState
		OR dsl.ServiceLocationStateAbbreviation <> tsl.ServiceLocationStateAbbreviation
		OR dsl.ServiceLocationCountry = tsl.ServiceLocationCountry
		OR dsl.ServiceLocationCountryAbbreviation <> tsl.ServiceLocationCountryAbbreviation
		OR dsl.ServiceLocationMetroArea <> tsl.ServiceLocationMetroArea
		OR dsl.ServiceLocationTaxAreaCode <> tsl.ServiceLocationTaxAreaCode
		OR dsl.ServiceLocationTaxArea <> tsl.ServiceLocationTaxArea
		OR dsl.ServiceLocationCountyJurisdiction <> tsl.ServiceLocationCountyJurisdiction
		OR dsl.ServiceLocationDistrictJurisdiction <> tsl.ServiceLocationDistrictJurisdiction
		OR dsl.ServiceLocationZone <> tsl.ServiceLocationZone
		OR dsl.ServiceLocationDefaultZone <> tsl.ServiceLocationDefaultZone
		OR dsl.ServiceLocationRegion_WireCenter <> tsl.ServiceLocationRegion_WireCenter
		OR dsl.ServiceLocationHouseNumber <> tsl.ServiceLocationHouseNumber
		OR dsl.ServiceLocationHouseSuffix <> tsl.ServiceLocationHouseSuffix
		OR dsl.ServiceLocationApartment <> tsl.ServiceLocationApartment
		OR dsl.ServiceLocationFloor <> tsl.ServiceLocationFloor
		OR dsl.ServiceLocationRoom <> tsl.ServiceLocationRoom
		OR dsl.ServiceLocationLocation <> tsl.ServiceLocationLocation
		OR dsl.ServiceLocationPostalCode <> tsl.ServiceLocationPostalCode
		OR dsl.ServiceLocationPostalCodePlus4 <> tsl.ServiceLocationPostalCodePlus4
		OR dsl.ServiceLocationStreet <> tsl.ServiceLocationStreet
		OR dsl.ServiceLocationPreDirectional <> tsl.ServiceLocationPreDirectional
		OR dsl.ServiceLocationStreetSuffix <> tsl.ServiceLocationStreetSuffix
		OR dsl.ServiceLocationPostDirectional <> tsl.ServiceLocationPostDirectional
		OR dsl.ServiceLocationRegionCode <> tsl.ServiceLocationRegionCode
		OR dsl.ServiceLocationStatusReason <> tsl.ServiceLocationStatusReason
		OR dsl.ServiceLocationStatus <> tsl.ServiceLocationStatus
		OR dsl.ServiceLocationCreatedBy <> tsl.ServiceLocationCreatedBy
		OR dsl.ServiceLocationCreatedOn <> tsl.ServiceLocationCreatedOn
		OR dsl.ServiceLocationComment <> tsl.ServiceLocationComment
		OR dsl.ServiceLocationDescription <> tsl.ServiceLocationDescription
		OR dsl.MetaEffectiveStartDatetime <> tsl.MetaEffectiveStartDatetime
		OR dsl.MetaEffectiveEndDatetime <> tsl.MetaEffectiveEndDatetime
		OR dsl.MetaCurrRecInd <> tsl.MetaCurrRecInd
		OR dsl.MetaEtlProcessId <> tsl.MetaEtlProcessId
		OR dsl.MetaSourceSystemCode <> tsl.MetaSourceSystemCode

------------------------------------------------------------------------------------
-- Stop Logging
------------------------------------------------------------------------------------

	SET @ExecutionMsg = 'Data Load is completed sucessfully!';

    SET @ExecutionMsg = 'Successful Execution (' + @Version + ')'
	EXECUTE @RC = info.ExecutionLogStop
	   @LogID
	  ,@V_TargetSchema
	  ,@V_Table
	  ,@V_CurrentTimestamp
	  ,NULL
	  ,@ExecutionMsg;

	END TRY


---------------------------------------------------------
-- Log error
---------------------------------------------------------    

BEGIN CATCH
 
        SET @ExecutionMsg = 'FAILURE: '
		                              + ' || Error Number : '  + CAST(ERROR_NUMBER() AS VARCHAR(MAX))
                                      + ' , Error Severity : ' + CAST(ERROR_SEVERITY() AS VARCHAR(MAX))
                                      + ' , Error State : '    + CAST(ERROR_STATE() AS VARCHAR(MAX))
                                      + ' , Error Line : '     + CAST(ERROR_LINE() AS VARCHAR(MAX))
                                      + ' , Error Message : '  + ERROR_MESSAGE() + '.'
        EXECUTE @RC = info.ExecutionLogError
           @LogID
		  ,@V_TargetSchema
		  ,@V_Table
		  ,NULL
          ,@ExecutionMsg 
        RETURN;
END CATCH



END
GO
