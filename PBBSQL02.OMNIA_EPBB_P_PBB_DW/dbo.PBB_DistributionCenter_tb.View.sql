USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_DistributionCenter_tb]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[PBB_DistributionCenter_tb] as

WITH MDUAddresses AS (
	SELECT Distinct dsl.DimServiceLocationId, dsl.LocationId, dc.cus_DistributionCenterName, ab.AccountNumber COLLATE Latin1_General_CI_AS  as MDUAccountCode
	  FROM pbbsql01.pbb_P_MSCRM.dbo.cus_DistributionCenterBase     dc   with (NOLOCK)
	  JOIN pbbsql01.[PBB_P_MSCRM].dbo.chr_servicelocation          csl  with (NOLOCK) on dc.cus_distributioncenterId   = csl.cus_ServiceLocationsId
	  JOIN dbo.DimServiceLocation                                  dsl  on dsl.locationid                              = csl.chr_masterlocationid
	  LEFT JOIN pbbsql01.[PBB_P_MSCRM].[dbo].[AccountBase]         ab   ON ab.AccountId = dc.cus_BulkBillingAccount 
     -- where cus_DistributionCenterName = 'CA - Harbor Pointe Condos'
    -- where cus_DistributionCenterName = 'Casa Del Marina'
)
-- select * from MDUAddresses order by 3
,AcctsAtMDU AS (
    SELECT * FROM (
	SELECT ma.*, fsla.DimAccountid, da.AccountCode, row_number() over (partition by ma.DimServiceLocationId order by da.DimAccountId desc) row_cnt
		FROM MDUAddresses ma
	  	LEFT JOIN dbo.PBB_ServiceLocationAccountALL  fsla on fsla.DimServiceLocationId = ma.DimServiceLocationId
		                                                  and fsla.LocationAccountDeactivationDate > getdate()
		LEFT JOIN dbo.DimAccount                     da   on da.DimAccountId           = fsla.dimAccountId
		                                                  and coalesce(da.AccountStatus,'')   <>'Inactive'
	WHERE 1=1 --(MDUAccountCode is not null or fsla.DimAccountId <> 0)
	) z
	  WHERE NOT (row_cnt > 1 and DimAccountId = 0)
)
--  select * from AcctsAtMDU order by cus_DistributionCenterName,DimServiceLocationId,Locationid, row_cnt

,ActvAcctLRC AS (
        select * from (
         select aam.cus_DistributionCenterName, aam.DimAccountId, aam.MDUAccountcode
		      , da.AccountCode, aam.DimServiceLocationId , aam.LocationId
			  , left(a.BRAccountId,8) BRAccountId
			  , row_number() over (partition by aam.DimAccountId, aam.DimServiceLocationId order by left(a.BRAccountId,8)  desc) row_cnt
		   from AcctsAtMDU                 aam  
		   join dbo.DimAccount             da  on da.DimAccountId   = aam.DimAccountid
		   left join dbo.FactBilledAccount a   on aam.DimAccountId  = a.DimAccountId
		                                          and cast(left(BRAccountId,8) as date) >= cast(dateadd(m,-1,getdate()) as date)
 
		  where 1=1
		    and coalesce(aam.DimAccountId,0) <> 0
		) x where row_cnt =1

	--	  group by aam.cus_DistributionCenterName, aam.DimAccountId , aam.MDUAccountcode
	--	      , da.AccountCode, aam.DimServiceLocationId, aam.LocationId
)
-- select * from ActvAcctLRC order by cus_DistributionCenterName,MDUAccountCode,accountcode

,   ActvAcctBill AS (     -- 1 ROW per Address / Account combo  with money
         select x.DimAccountId
		      , cus_DistributionCenterName
		      , coalesce(y.MDUAccountCode, y.AccountCode)                            MDUAccountCode
		      , y.AccountCode
		      , y.BRAccountid
		      , coalesce(x.RecurringAmount,0) RecurringAmount
			  , coalesce(z.DimServiceLocationId, y.DimServiceLocationId)  DimServiceLocationId
			  , case when da.AccountCode = y.MDUAccountCode    then 'Y' 
					 else 'N' end                                         BulkOwnerFlag
			  , sum(coalesce(z.BilledChargeAmount,0.00))                  BilledChargeAmount
			  , sum(coalesce(bacct.Amount,0.00)  )                         ItemPrice
		   from ActvAcctLRC           y 
		   join dbo.DimAccount        da on da.DimAccountId = y.DimAccountId
		                                 and trim(coalesce(da.AccountStatusCode,'')) <> 'I'
		   LEFT join dbo.FactBilledAccount x  on  x.DimAccountId  = y.DimAccountId 
		                                 and left(x.BRAccountId,8)  = y.BRAccountId
 					   
		   left join (SELECT c.AccountCode
		                   , i.LocationId
		                   , sum(sip.Amount) Amount
		                FROM PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.CusAccount c with (NOLOCK)
						JOIN PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvService s with (NOLOCK) on  s.AccountId = c.AccountId
						JOIN PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvItem    i with (NOLOCK) on  i.ServiceId = s.Serviceid 
						LEFT JOIN PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvItemPrice sip with (NOLOCK) on  sip.ItemId = i.ItemId
						                                                                   and sip.EndDate is null
					   GROUP BY c.AccountCode, i.Locationid
					  ) Bacct  on  Bacct.AccountCode = y.AccountCode 
					           and Bacct.LocationId  = y.LocationId

		   left join FactBilledCharge      z on  x.DimAccountId         = z.DimAccountId
		                                     and left(x.BRAccountId,8)  = left(z.BRChargeID,8)
										 	 and y.AccountCode <> y.MDUAccountCode
          group by x.DimAccountId
		      , cus_DistributionCenterName
		      , coalesce(y.MDUAccountCode, y.AccountCode)
		      , y.AccountCode
		      , y.BRAccountid
		      , x.RecurringAmount
			  , coalesce(z.DimServiceLocationId, y.DimServiceLocationId)
			  , case when da.AccountCode = y.MDUAccountCode    then 'Y' 
					 else 'N' end
)
-- select * from ActvAcctBill order by cus_DistributionCenterName, DimAccountId

, BulkOwnerMetric AS (
          SELECT AccountCode, DimServiceLocationId, Sum(coalesce(ItemPrice,0)) BilledChargeAmount 
		    FROM ActvAcctBill aab 
		   WHERE AccountCode = MDUAccountCode 
		   GROUP BY AccountCode, DimServiceLocationId
		   /*
          SELECT mdu.MDUAccountCode AccountCode, mdu.DimServiceLocationId, Sum(coalesce(ItemPrice,0)) BilledChargeAmount 
		    FROM MDUAddresses mdu
			LEFT JOIN ActvAcctBill aab on  mdu.MDUAccountCode       = aab.AccountCode
			                           and mdu.DimServiceLocationId = aab.DimServiceLocationId
		   WHERE AccountCode is not null
		   GROUP BY mdu.MDUAccountCode, mdu.DimServiceLocationId
		   */
)
--  select * from BulkOwnerMetric

, TenantMetric AS (
 
          SELECT AccountCode, DimServiceLocationId, Sum(RecurringAmount) BilledChargeAmount 
		    FROM ActvAcctBill aab 
		   WHERE AccountCode <> coalesce(MDUAccountCode ,'')
		   GROUP BY AccountCode, DimServiceLocationId
		   
)
--  select * from TenantMetric

, ActvAcctAddr AS (     --- 1 ROW Per Address
      SELECT x.DimServiceLocationId 
		       , Count( coalesce(bom.AccountCode,0) + coalesce(tm.AccountCode,0) ) ttlAccounts
			   , sum(case when bom.AccountCode is not null then 1 else 0 end)                                              BulkDirectAccounts
			   , sum(case when tm.AccountCode  is not null then 1 else 0 end)                                              TenantAccounts                                                                            
			   , sum(case when bom.AccountCode is not null then coalesce(bom.BilledChargeAmount,0) else 0 end)             MRCBulkDirectAmt
			   , sum(case when tm.AccountCode  is not null then coalesce(tm.BilledChargeAmount,0)  else 0 end)             MRCTenantAmt
		    FROM (
				 select fci.DimServiceLocationId 
				   from  (	SELECT Distinct dsl.DimServiceLocationId 
							  FROM pbbsql01.pbb_P_MSCRM.dbo.cus_DistributionCenterBase     dc   with (NOLOCK)
							  JOIN pbbsql01.[PBB_P_MSCRM].dbo.chr_servicelocation          csl  with (NOLOCK) on dc.cus_distributioncenterId   = csl.cus_ServiceLocationsId
							  JOIN dbo.DimServiceLocation                                  dsl  on dsl.locationid                              = csl.chr_masterlocationid
				         ) ma     
				   join dbo.FactCustomerItem fci   ON  ma.DimServiceLocationId = fci.DimServiceLocationId   
				                                   AND fci.EffectiveEndDate > getdate() 
				   join dbo.DimAccount       dc    ON  fci.DimAccountId        = dc.DimAccountId
				                                   AND dc.AccountStatusCode <> 'I'
												   AND coalesce(AccountCode,'')  <> ''
				  group by fci.DimServiceLocationId 
			     ) x
			LEFT JOIN BulkOwnerMetric bom on bom.DimServiceLocationId = x.DimServiceLocationId
			LEFT JOIN TenantMetric    tm  on tm.DimServiceLocationId  = x.DimServiceLocationId

		   GROUP by x.DimServiceLocationId  

)
--  select * from ActvAcctAddr

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
  FROM pbbsql01.pbb_P_MSCRM.dbo.cus_DistributionCenterBase          dc   with (NOLOCK)
  JOIN pbbsql01.[PBB_P_MSCRM].dbo.chr_servicelocation               csl  with (NOLOCK) on dc.cus_distributioncenterId   = csl.cus_ServiceLocationsId
                                                                         and csl.StatusCode = 1
  JOIN dbo.DimServiceLocation                                       dsl  ON dsl.locationid                = csl.chr_masterlocationid
  JOIN dbo.FactServiceLocation                                      fsl  ON fsl.DimServiceLocationId      = dsl.DimServiceLocationID
  LEFT JOIN (select top 50 DimServiceLocationId
             ,MAX(sl.cus_cabinet) as Cabinet
			 ,MAX(Net.Hostname)   as HostName
			 ,MAX(DimServiceLocation.ServiceLocationRegion_WireCenter) AS WirecenterRegion
			 ,MAX(isnull(dc.cus_distributioncentername,'')) as MDUName
			 
			FROM  dbo.DimServiceLocation  
			left join PBB_AddressNetworkCircuitID                             NET             on DimServiceLocation.LocationId = net.srvlocation_locationid
			left join pbbsql01.[PBB_P_MSCRM].dbo.chr_servicelocation          sl with(NOLOCK) on DimServiceLocation.locationid = sl.chr_masterlocationid
			left join pbbsql01.[PBB_P_MSCRM].[dbo].cus_distributioncenterBase dc with(NOLOCK) on dc.cus_distributioncenterId   = sl.cus_ServiceLocationsId
			GROUP BY DimServiceLocationId
	   )                                                       dad  ON dad.DimServiceLocationId                    = fsl.DimServiceLocationId
  LEFT JOIN dbo.DimServiceLocation_PBB                         dslp ON dslp.LocationId                             = dsl.LocationId 
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','cus_bulkordirect')      as [cus_bulkordirect] on [cus_bulkordirect].[JoinOnValue] = dc.[cus_bulkordirect]
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','cus_area')              as [cus_area] on [cus_area].[JoinOnValue] = dc.[cus_area]
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','cus_roeagreement')      as [cus_roeagreement] on [cus_roeagreement].[JoinOnValue] = dc.[cus_roeagreement] --ORDER BY 1, dsl.ServiceLocationStreet ,2
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','statuscode')            as [statuscode] on [statuscode].[JoinOnValue] = dc.[statuscode]
  left join [dbo].[PBB_StringMapBaseJoin]('cus_distributioncenter','cus_competitivestatus') as [cus_competitivestatus] on [cus_competitivestatus].[JoinOnValue] = dc.[cus_competitivestatus]
  LEFT JOIN ActvAcctAddr                                       aaa  ON aaa.DimServiceLocationId                    = dsl.DimServiceLocationId


GO
