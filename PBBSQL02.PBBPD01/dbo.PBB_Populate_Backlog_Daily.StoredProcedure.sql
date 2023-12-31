USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_Backlog_Daily]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  Todd Boyer	2022-10-12	Initial version
--
--
  
create PROCEDURE [dbo].[PBB_Populate_Backlog_Daily]
AS


BEGIN
 
	TRUNCATE TABLE dbo.pbb_DistributionCenter;
	DROP TABLE if exists #MDUAddresses;
	DROP TABLE if exists #AcctsAtMDU;
	DROP TABLE if exists #ActvAcctLRC;
	DROP TABLE if exists #ActvAcctBill;
	DROP TABLE if exists #TenantMetric;
	DROP TABLE if exists #BulkOwnerMetric;
	DROP TABLE if exists #ActvAcctAddr;

	SELECT Distinct dsl.DimServiceLocationId
	     , dsl.LocationId
	     , dc.cus_DistributionCenterName
	     , ab.AccountNumber  as MDUAccountCode
	  INTO #MDUAddresses
	  FROM Transient.cus_DistributionCenterBase  dc   
	  JOIN Transient.chr_servicelocation         csl  on dc.cus_distributioncenterId   = csl.cus_ServiceLocationsId
	  JOIN dbo.DimServiceLocation                dsl  on dsl.locationid                = csl.chr_masterlocationid
	  LEFT JOIN Transient.AccountBase            ab   ON ab.AccountId                  = dc.cus_BulkBillingAccount    -- Get the BULK master account
	;

	-- select distinct cus_DistributionCenterName from #MDUAddresses
	
	SELECT * INTO #AcctsAtMDU FROM (
		SELECT ma.*, fsla.DimAccountid, da.AccountCode, row_number() over (partition by ma.DimServiceLocationId order by da.DimAccountId desc) row_cnt
			FROM #MDUAddresses     ma
	  		LEFT JOIN dbo.PBB_ServiceLocationAccountALL  fsla on  fsla.DimServiceLocationId = ma.DimServiceLocationId
															  and fsla.LocationAccountDeactivationDate > getdate()
			LEFT JOIN dbo.DimAccount                     da   on da.DimAccountId           = fsla.dimAccountId
															  and coalesce(da.AccountStatus,'')   <>'Inactive'
		WHERE 1=1 --(MDUAccountCode is not null or fsla.DimAccountId <> 0)
	) z
	WHERE NOT (row_cnt > 1 and DimAccountId = 0)
	;
	
	-- select * from #AcctsAtMDU ORDER BY 3 

    SELECT * INTO #ActvAcctLRC from (
        SELECT aam.cus_DistributionCenterName, aam.DimAccountId, aam.MDUAccountcode
		    , da.AccountCode, aam.DimServiceLocationId , aam.LocationId
			, left(a.BRAccountId,8) BRAccountId
			, row_number() over (partition by aam.DimAccountId, aam.DimServiceLocationId order by left(a.BRAccountId,8)  desc) row_cnt
		from #AcctsAtMDU                aam  
		join dbo.DimAccount             da  on da.DimAccountId   = aam.DimAccountid
		left join dbo.FactBilledAccount a   on aam.DimAccountId  = a.DimAccountId
		                                        and cast(left(BRAccountId,8) as date) >= cast(dateadd(m,-1,getdate()) as date)
 
		where 1=1
		and coalesce(aam.DimAccountId,0) <> 0
	) x where row_cnt =1
	;
	
	-- select * from #ActvAcctLRC

    SELECT x.DimAccountId
		, cus_DistributionCenterName
		, coalesce(y.MDUAccountCode COLLATE Latin1_General_CI_AS, y.AccountCode COLLATE Latin1_General_CI_AS)  MDUAccountCode
		, y.AccountCode
		, y.BRAccountid
		, coalesce(x.RecurringAmount,0) RecurringAmount
		, coalesce(z.DimServiceLocationId, y.DimServiceLocationId)  DimServiceLocationId
		, case when da.AccountCode COLLATE Latin1_General_CI_AS= y.MDUAccountCode  COLLATE Latin1_General_CI_AS  then 'Y' 
				else 'N' end                                         BulkOwnerFlag
		, sum(coalesce(z.BilledChargeAmount,0.00))                  BilledChargeAmount
		, sum(coalesce(bacct.Amount,0.00)  )                         ItemPrice
	INTO #ActvAcctBill 
	FROM #ActvAcctLRC                y 
	join dbo.DimAccount             da on da.DimAccountId = y.DimAccountId
		                                   and trim(coalesce(da.AccountStatusCode,'')) <> 'I'
	LEFT join dbo.FactBilledAccount x  on  x.DimAccountId  = y.DimAccountId 
		                                   and left(x.BRAccountId,8)  = y.BRAccountId
 					   
	LEFT join (SELECT c.AccountCode
		            , i.LocationId
		            , sum(sip.Amount) Amount
		        FROM Transient.CusAccount          c 
				JOIN Transient.SrvService          s  on  s.AccountId = c.AccountId
				JOIN Transient.SrvItem             i  on  i.ServiceId = s.Serviceid 
				LEFT JOIN Transient.SrvItemPrice sip  on  sip.ItemId = i.ItemId
						                                  and sip.EndDate is null
				GROUP BY c.AccountCode, i.Locationid
				) Bacct  on Bacct.AccountCode = y.AccountCode 
					    and Bacct.LocationId  = y.LocationId

	LEFT join FactBilledCharge      z on  x.DimAccountId         = z.DimAccountId
		                                and left(x.BRAccountId,8)  = left(z.BRChargeID,8)
										and y.AccountCode COLLATE Latin1_General_CI_AS <> y.MDUAccountCode COLLATE Latin1_General_CI_AS
    group by x.DimAccountId
		, cus_DistributionCenterName
		, coalesce(y.MDUAccountCode COLLATE Latin1_General_CI_AS, y.AccountCode  COLLATE Latin1_General_CI_AS)
		, y.AccountCode
		, y.BRAccountid
		, x.RecurringAmount
		, coalesce(z.DimServiceLocationId, y.DimServiceLocationId)
		, case when da.AccountCode COLLATE Latin1_General_CI_AS = y.MDUAccountCode COLLATE Latin1_General_CI_AS   then 'Y' 
				else 'N' end
	;

	-- select * from #ActvAcctBill

    SELECT AccountCode, DimServiceLocationId, Sum(coalesce(ItemPrice,0)) BilledChargeAmount 
	  INTO #BulkOwnerMetric
	  FROM #ActvAcctBill aab 
	 WHERE AccountCode COLLATE Latin1_General_CI_AS  = MDUAccountCode COLLATE Latin1_General_CI_AS  
	 GROUP BY AccountCode, DimServiceLocationId
	 ;

    SELECT AccountCode, DimServiceLocationId, Sum(RecurringAmount) BilledChargeAmount 
	  INTO #TenantMetric
	  FROM #ActvAcctBill aab 
	 WHERE AccountCode COLLATE Latin1_General_CI_AS   <> coalesce(MDUAccountCode COLLATE Latin1_General_CI_AS  ,'')
	 GROUP BY AccountCode, DimServiceLocationId
	;

	--

    SELECT x.DimServiceLocationId 
		    , Count( coalesce(bom.AccountCode,0) + coalesce(tm.AccountCode,0) ) ttlAccounts
			, sum(case when bom.AccountCode is not null then 1 else 0 end)                                              BulkDirectAccounts
			, sum(case when tm.AccountCode  is not null then 1 else 0 end)                                              TenantAccounts                                                                            
			, sum(case when bom.AccountCode is not null then coalesce(bom.BilledChargeAmount,0) else 0 end)             MRCBulkDirectAmt
			, sum(case when tm.AccountCode  is not null then coalesce(tm.BilledChargeAmount,0)  else 0 end)             MRCTenantAmt
		INTO #ActvAcctAddr
		FROM (
				select fci.DimServiceLocationId 
				from  (	SELECT Distinct dsl.DimServiceLocationId 
							FROM Transient.cus_DistributionCenterBase   dc  
							JOIN Transient.chr_servicelocation          csl  on dc.cus_distributioncenterId   = csl.cus_ServiceLocationsId
							JOIN dbo.DimServiceLocation                 dsl  on dsl.locationid                = csl.chr_masterlocationid
				        ) ma     
				join dbo.FactCustomerItem fci   ON  ma.DimServiceLocationId = fci.DimServiceLocationId   
				                                AND fci.EffectiveEndDate > getdate() 
				join dbo.DimAccount       dc    ON  fci.DimAccountId        = dc.DimAccountId
				                                AND dc.AccountStatusCode <> 'I'
												AND coalesce(AccountCode,'')  <> ''
				group by fci.DimServiceLocationId 
			    ) x
		LEFT JOIN #BulkOwnerMetric bom on bom.DimServiceLocationId = x.DimServiceLocationId
		LEFT JOIN #TenantMetric    tm  on tm.DimServiceLocationId  = x.DimServiceLocationId

		GROUP by x.DimServiceLocationId  
	;

	
  -- select * from dbo.#ActvAcctAddr


---------------------


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
	 , cast(dslp.pbb_LocationServiceableDate as date) ServiceableDate
	 , fsl.LocationID
	 , fsl.DimServiceLocationId
	 , case when aaa.DimServiceLocationId is not null then 'Y' else 'N' end ActiveAccountFlag
	 , dc.cus_HomesPassedorUnits
	 , coalesce(BulkDirectAccounts,0)+coalesce(TenantAccounts,0) ttlAccounts
	 , coalesce(BulkDirectAccounts,0) BulkDirectAccounts
	 , coalesce(TenantAccounts,0) TenantAccounts

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
  LEFT JOIN dbo.DimServiceLocation                                  dsl  ON dsl.locationid                = csl.chr_masterlocationid
  LEFT JOIN dbo.FactServiceLocation                                 fsl  ON fsl.DimServiceLocationId      = dsl.DimServiceLocationID
  LEFT JOIN (select DimServiceLocationId
             ,MAX(sl.cus_cabinet) as Cabinet
			 ,MAX(Net.Hostname)   as HostName
			 ,MAX(DimServiceLocation.ServiceLocationRegion_WireCenter) AS WirecenterRegion
			 ,MAX(isnull(dc.cus_distributioncentername,'')) as MDUName
			 
			FROM  dbo.DimServiceLocation  
			left join PBB_AddressNetworkCircuitID                             NET             on DimServiceLocation.LocationId = net.srvlocation_locationid
			left join Transient.chr_servicelocation                           sl              on DimServiceLocation.locationid = sl.chr_masterlocationid
			left join Transient.cus_distributioncenterBase                    dc              on dc.cus_distributioncenterId   = sl.cus_ServiceLocationsId
			GROUP BY DimServiceLocationId
	   )                                                       dad  ON dad.DimServiceLocationId                    = fsl.DimServiceLocationId
  LEFT JOIN dbo.DimServiceLocation_PBB                         dslp ON dslp.LocationId                             = dsl.LocationId 
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','cus_bulkordirect')      as [cus_bulkordirect] on [cus_bulkordirect].[JoinOnValue] = dc.[cus_bulkordirect]
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','cus_area')              as [cus_area] on [cus_area].[JoinOnValue] = dc.[cus_area]
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','cus_roeagreement')      as [cus_roeagreement] on [cus_roeagreement].[JoinOnValue] = dc.[cus_roeagreement] --ORDER BY 1, dsl.ServiceLocationStreet ,2
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','statuscode')            as [statuscode] on [statuscode].[JoinOnValue] = dc.[statuscode]
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','cus_competitivestatus') as [cus_competitivestatus] on [cus_competitivestatus].[JoinOnValue] = dc.[cus_competitivestatus]
  LEFT JOIN #ActvAcctAddr                                      aaa  ON aaa.DimServiceLocationId                    = dsl.DimServiceLocationId
  ;

-- select * from dbo.PBB_DistributionCenter order by 1

  -- 
END
GO
