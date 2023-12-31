USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_DistributionCenter]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  Todd Boyer	2022-10-12	Initial version
--
--
  
CREATE PROCEDURE [dbo].[PBB_Populate_DistributionCenter]
	@CycleDate date
AS


BEGIN
 
    -- Declare @CycleDate date='20230828';
    DECLARE @CycleDt date;
	SELECT @CycleDt = case when @CycleDate is not null then dateadd(d,-1,cast(@CycleDate as date)) else cast(getdate() as date) end;


	TRUNCATE TABLE dbo.pbb_DistributionCenter;
	DROP TABLE if exists #MDUAddresses;
	DROP TABLE if exists #AcctsAtMDU;
	DROP TABLE if exists #ActvAcctLRC;
	DROP TABLE if exists #ActvAcctBill;
	DROP TABLE if exists #TenantMetric;
	DROP TABLE if exists #BulkOwnerMetric;
	DROP TABLE if exists #ActvAcctAddr;

	-- 1. Distribution Center Addresses
	SELECT Distinct dsl.DimServiceLocationId
	     , dsl.LocationId
		 , dsl.ServiceLocationFullAddress
	     , dc.cus_DistributionCenterName
	     , ab.AccountNumber  as MDUAccountCode
		 , case when csl.cus_Serviceable = '972050000' then 'Y' else 'N' end ServiceableAddress
		 , case when ab.AccountNumber is not null then 'Bulk' else 'MDU' end BulkMduCode
	  INTO #MDUAddresses
	  FROM Transient.cus_DistributionCenterBase         dc   
	  JOIN Transient.chr_servicelocation                csl  on dc.cus_distributioncenterId   = csl.cus_ServiceLocationsId
	  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation dsl  on dsl.locationid                = csl.chr_masterlocationid
	  LEFT JOIN Transient.AccountBase                   ab   ON ab.AccountId                  = dc.cus_BulkBillingAccount    -- Get the BULK master account
	;

	-- select  * from #MDUAddresses where cus_DistributionCenterName = 'CA - Edge West' order by cus_DistributionCentername, DimServiceLocationId
	-- select  * from #MDUAddresses where cus_DistributionCenterName = 'SA - Fish Camp Cottages' order by cus_DistributionCentername, DimServiceLocationId
	-- select  * from #MDUAddresses where cus_DistributionCenterName = 'SA- Spyglass Townhomes' order by cus_DistributionCentername, DimServiceLocationId
	-- select  * from #MDUAddresses order by cus_DistributionCenterName , ServiceLocationFullAddress
	-- select distinct cus_DistributionCenterName from #MDUAddresses order by 1


	-- What Accounts active at location
	-- declare @CycleDt date='20230801';

  -- 2. Accounts at MDU
  WITH MDUActives AS 

  ( -- declare @CycleDt date='20230315';
	 SELECT mda.cus_distributioncentername, mda.MDUAccountCode, dc.AccountCode, x.DimAccountId, dsl.LocationId, x.DimServiceLocationId
          , dac.AccountTypeCode, sum(x.ItemPrice) ItemPrice
				              FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x
							  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation      dsl  on x.DimServiceLocationId = dsl.DimServiceLocationId							 
							  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccount              dc   ON x.DimAccountId         = dc.DimAccountId 
											                                              AND coalesce(AccountCode,'')  <> ''
							  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCustomerProduct      dcp  ON dcp.DimCustomerProductId = x.DimCustomerProductId 
							  LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccountCategory dac  on dac.DimAccountCategoryId = x.DimAccountCategoryId
							  JOIN #MDUAddresses                                     mda  on mda.DimServiceLocationId = x.DimServiceLocationId
				             WHERE 1=1
							   AND cast(x.EffectiveStartDate as date) <= @CycleDt
							   AND cast(x.EffectiveEndDate as date)   >  @CycleDt
							   AND x.Deactivation_DimDateId > @CycleDt 
							   AND right(x.SourceId,2) <> '.N' 
	 GROUP BY mda.cus_distributioncentername, mda.MDUAccountCode, dc.AccountCode, x.DimAccountId, dsl.LocationId, x.DimServiceLocationId, dac.AccountTypeCode
	 ) 
	 select * INTO #AcctsAtMDU 
	 from MDUActives
	 order by 1,2,3
	 ;

	 -- select * from #AcctsAtMDU order by 1
	 -- select * from #AcctsAtMDU where cus_distributioncentername='CA - Edge West'


	-- 3. Calculate Bulk Charge

	DROP TABLE if exists #TempMDUTotalCharge;

	-- declare @CycleDt date='20230801';
	WITH MDUBulkCharge AS (
			SELECT mda.cus_distributioncentername, mda.MDUAccountCode, x.DimAccountId
			     , sum(case when aam.DimAccountId is null then x.ItemPrice else 0 end) BulkPrice
				 , sum(case when aam.DimAccountId is null then 0 else x.ItemPrice end) ItemPrice
									  FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x					 
									  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccount              dc   ON x.DimAccountId         = dc.DimAccountId 
																								  AND coalesce(AccountCode,'')  <> ''
									  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCustomerProduct      dcp  ON dcp.DimCustomerProductId = x.DimCustomerProductId
																								  AND dcp.ProductStatusCode <> 'I'
									  LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccountCategory dac  on dac.DimAccountCategoryId = x.DimAccountCategoryId
									  JOIN (select distinct MDUAccountcode,cus_DistributionCenterName from #MDUAddresses where BulkMduCode='Bulk') mda  
										   on  mda.MDUAccountCode  collate database_default = dc.AccountCode collate database_default 
									  LEFT JOIN #AcctsAtMDU                                  aam  on aam.DimServiceLocationId = x.DimServiceLocationId
									 WHERE 1=1
									   AND cast(x.EffectiveStartDate as date) <= @CycleDt
									   AND cast(x.EffectiveEndDate as date)   >  @CycleDt 
									   AND x.Deactivation_DimDateId > @CycleDt  -- tb 23/08/25
									   AND right(x.SourceId,2) <> '.N' 
			group by mda.cus_distributioncentername, mda.MDUAccountCode, x.DimAccountId 
	)
	select * into #TempMDUTotalCharge from MDUBulkCharge
	;

	-- select * from #TempMDUTotalCharge



	-- 4. Bulk per unit Calculation
	
	drop table if exists #BulkOwnerMetric;

    SELECT DimServiceLocationId, cus_DistributionCentername, AccountCode, 'Y' BulkOwnerFlag, Sum(coalesce(ItemPrice,0)) BilledChargeAmount , max(coalesce(ItemPrice,0)) MDURecurringAmount
	  INTO #BulkOwnerMetric
	  FROM #AcctsAtMDU aab 
	 WHERE AccountCode COLLATE Latin1_General_CI_AS  = MDUAccountCode COLLATE Latin1_General_CI_AS  
	 GROUP BY  DimServiceLocationId,cus_DistributionCentername,AccountCode
	 ;
	-- select * from #BulkOwnerMetric order by 2,1


	WITH BulkAlloc AS 
	       ( SELECT *, MDURecurringAmount / LocationCount AS UnitAmount FROM 
	         (SELECT AccountCode, sum(BilledChargeAmount) BilledChargeAmount, max(t.ItemPrice) MDURecurringAmount , count(*) LocationCount
	                     FROM #BulkOwnerMetric b
						 JOIN #TempMDUTotalCharge  t on b.AccountCode collate database_default= t.MDUAccountCode collate database_default
						WHERE  BulkOwnerFlag = 'Y'
						GROUP BY AccountCode having sum(BilledChargeAmount) = 0
			 ) x
	)
    UPDATE #BulkOwnerMetric
	   SET BilledChargeAmount = UnitAmount
	  FROM BulkAlloc 
	 WHERE BulkAlloc.AccountCode = #BulkOwnerMetric.AccountCode
	   AND #BulkOwnerMetric.BilledChargeAmount = 0
	;

	-- drop table #TenantMetric
    SELECT DimServiceLocationId, cus_distributioncentername, AccountCode, Sum(ItemPrice) BilledChargeAmount 
	  INTO #TenantMetric
	  FROM #AcctsAtMDU aab 
	 WHERE AccountCode COLLATE Latin1_General_CI_AS   <> coalesce(MDUAccountCode COLLATE Latin1_General_CI_AS  ,'')
	 GROUP BY DimServiceLocationId, cus_distributioncentername, AccountCode
	; 
	-- select * from #TenantMetric order by 2,3

	-- drop table #ActvAcctAddr

    SELECT x.DimServiceLocationId, x.cus_distributioncentername
		    , sum(     coalesce(bom.BulkAccounts,0) +
			           coalesce(d.DirectAccounts,0) +
					   coalesce(t.TenantAccounts,0) )                                                                   ttlAccounts
			, sum(     coalesce(bom.BulkAccounts,0) +
			           coalesce(d.DirectAccounts,0) )                                                                   BulkDirectAccounts
			, sum(coalesce(t.TenantAccounts,0)  )                                                                       TenantAccounts                                                                            
			, sum(coalesce(bom.BilledChargeAmount,0) + coalesce(d.BilledChargeAmount,0))                                MRCBulkDirectAmt
			, sum(coalesce(t.BilledChargeAmount,0) )                                                                    MRCTenantAmt
		INTO #ActvAcctAddr
		FROM (select distinct DimServiceLocationId, Cus_DistributionCenterName from #AcctsAtMDU )  x
		LEFT JOIN (select DimServiceLocationId, sum(ItemPrice) BilledChargeAmount, count(*) TenantAccounts
		             from #AcctsAtMDU 
					 where AccountCode collate database_default <> MDUAccountCode collate database_default
					   and MDUAccountCode is not null
					 group by DimServiceLocationId
				  ) t on t.DimServiceLocationId = x.DimServiceLocationId		
		LEFT JOIN (select DimServiceLocationId, sum(ItemPrice) BilledChargeAmount, count(*) DirectAccounts
		             from #AcctsAtMDU 
					 where 1=1
					   and MDUAccountCode is  null
					 group by DimServiceLocationId
				  ) d on d.DimServiceLocationId = x.DimServiceLocationId
		LEFT JOIN (select *,1 BulkAccounts from #BulkOwnerMetric) bom on bom.DimServiceLocationId = x.DimServiceLocationId
		--LEFT JOIN #TenantMetric    tm  on tm.DimServiceLocationId  = x.DimServiceLocationId
		LEFT JOIN (select distinct cus_distributionCenterName,AccountCode from #BulkOwnerMetric ) bo on bo.cus_distributioncentername = x.cus_distributioncentername

		GROUP by x.DimServiceLocationId , x.cus_distributioncentername
	;
 

  -- select * from dbo.#ActvAcctAddr where dimservicelocationid = 1232031; select * from #TenantMetric  where DimServiceLocationid = 1232031; select * from #BulkOwnerMetric where DimServiceLocationid = 1232031;
  
  -- select * from dbo.#ActvAcctAddr where cus_distributioncentername = 'SA- Spyglass Townhomes'
  -- select distinct DimAccountId from [omnia_epbb_p_pbb_dw].dbo.factcustomeritem where dimservicelocationid  = 1232031 and '20230331' between effectivestartdate and effectiveenddate and right(sourceid,1)<>'N'
  -- select * from  [omnia_epbb_p_pbb_dw].dbo.dimaccount where dimaccountid in (740102,739559)
---------------------

-- delete from dbo.PBB_DistributionCenter

INSERT INTO dbo.PBB_DistributionCenter

SELECT dc.cus_distributionCenterName  DistributionCenter
	 , [cus_Area].Value CusArea
     , coalesce(dad.MDUName,dc.cus_distributionCenterName ) MDUName
     , dslp.pbb_LocationProjectCode
     , dsl.ServiceLocationFullAddress
	 , csl.chr_RegionIdName
	 , dsl.ServiceLocationStatus 
	 , statuscode.Value CusStatus
	 , dc.cus_ContactName
	 , dc.cus_ComplexName
	 , dc.cus_Rates
	 , dslp.pbb_LocationIsServiceable   LocationIsServiceable
	 , dslp.pbb_Fiber                   Fiber
	 , dslp.pbb_FixedWireless           FixedWireless
	 , dslp.pbb_DefaultNetworkDelivery  DefaultNetworkDelivery
	 , coalesce(cast(dslp.pbb_LocationServiceableDate as date),dc.cus_CabinetActualServiceable ) ServiceableDate
	 , fsl.LocationID
	 , fsl.DimServiceLocationId
	 , case when aaa.DimServiceLocationId is not null then 'Y' else 'N' end ActiveAccountFlag
	 , dc.cus_HomesPassedorUnits
	 , coalesce(aaa.BulkDirectAccounts,0)+coalesce(aaa.TenantAccounts,0) ttlAccounts
	 , coalesce(aaa.BulkDirectAccounts,0) BulkDirectAccounts
	 , coalesce(aaa.TenantAccounts,0) TenantAccounts

	 , cast((coalesce(MRCBulkDirectAmt,0.00)+coalesce(MRCTenantAmt,0.00)/
	         case when coalesce(BulkDirectAccounts,0)+coalesce(TenantAccounts,0)=0 then 1 else  coalesce(BulkDirectAccounts,0)+coalesce(TenantAccounts,0) 
			  end)  as decimal(9,2)) [MRC Avg Amt]

	 , coalesce(MRCBulkDirectAmt,0.00)+coalesce(MRCTenantAmt,0.00) [MRC Total Amt]
	 , cast(MRCBulkDirectAmt/case when coalesce(BulkDirectAccounts,0)=0 then 1 else coalesce(BulkDirectAccounts,1) end as decimal(9,2)) [MRC Avg Bulk/Direct Amt]
	 , coalesce(MRCBulkDirectAmt,0.00) [MRC Total Bulk/Direct Amt]
	 , cast(MRCTenantAmt/case when coalesce(TenantAccounts,0)=0 then 1 else coalesce(TenantAccounts,1) end as decimal(9,2)) [MRC Avg Tenant Amt]
	 , coalesce(MRCTenantAmt,0.00) [MRC Total Tenant Amt]
	 , [cus_bulkordirect].Value BulkOrDirect
	 , dad.Cabinet
	 , dad.HostName
	 , WireCenterRegion
	 , dc.cus_CabinetActivated
	 , dc.cus_CabinetScheduled
	 , dc.cus_MDUConstructionReadiness
	 , dc.cus_MDUDesignStarted
	 , dc.cus_MDUDesignComplete
	 , dc.cus_MDUConstructionStarted
	 , dc.cus_MDUConstructionComplete
	 , dc.cus_CabinetExpectedConstructionCompletion
	 , dc.cus_CabinetActualConstructionComplete
	 , dc.cus_CabinetActualServiceable
	 , [cus_roeagreement].Value ROEAgreement
	 , cus_competitivestatus.Value CompetitiveStatus
	-- select *
 -- INTO dbo.PBB_DistributionCenter
  FROM transient.cus_DistributionCenterBase                         dc    
  LEFT JOIN transient.chr_servicelocation                           csl  on dc.cus_distributioncenterId   = csl.cus_ServiceLocationsId
                                                                    and csl.StatusCode = 1
  LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation                                  dsl  ON dsl.locationid                = csl.chr_masterlocationid
  LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.FactServiceLocation                                 fsl  ON fsl.DimServiceLocationId      = dsl.DimServiceLocationID
  LEFT JOIN (select DimServiceLocationId
             ,MAX(sl.cus_cabinet) as Cabinet
			 ,MAX(Net.Hostname)   as HostName
			 ,MAX(DimServiceLocation.ServiceLocationRegion_WireCenter) AS WirecenterRegion
			 ,MAX(isnull(dc.cus_distributioncentername,'')) as MDUName
			 
			FROM  [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation  
			left join [OMNIA_EPBB_P_PBB_DW].dbo.PBB_AddressNetworkCircuitID   NET             on DimServiceLocation.LocationId = net.srvlocation_locationid
			left join Transient.chr_servicelocation                           sl              on DimServiceLocation.locationid = sl.chr_masterlocationid
			left join Transient.cus_distributioncenterBase                    dc              on dc.cus_distributioncenterId   = sl.cus_ServiceLocationsId
			GROUP BY DimServiceLocationId
	   )                                                       dad  ON dad.DimServiceLocationId                    = fsl.DimServiceLocationId
  LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation_PBB                         dslp ON dslp.LocationId                             = dsl.LocationId 
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','cus_bulkordirect')      as [cus_bulkordirect] on [cus_bulkordirect].[JoinOnValue] = dc.[cus_bulkordirect]
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','cus_area')              as [cus_area] on [cus_area].[JoinOnValue] = dc.[cus_area]
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','cus_roeagreement')      as [cus_roeagreement] on [cus_roeagreement].[JoinOnValue] = dc.[cus_roeagreement] --ORDER BY 1, dsl.ServiceLocationStreet ,2
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','statuscode')            as [statuscode] on [statuscode].[JoinOnValue] = dc.[statuscode]
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','cus_competitivestatus') as [cus_competitivestatus] on [cus_competitivestatus].[JoinOnValue] = dc.[cus_competitivestatus]
  LEFT JOIN #ActvAcctAddr                                      aaa  ON aaa.DimServiceLocationId                    = dsl.DimServiceLocationId
  ;

-- select * from dbo.PBB_DistributionCenter where DistributionCenter ='AL-CHAMPION (AUBURN CONDOS)' order by 1

  -- 
END
GO
