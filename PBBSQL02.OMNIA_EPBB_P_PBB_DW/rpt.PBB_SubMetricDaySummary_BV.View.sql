USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_SubMetricDaySummary_BV]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





 CREATE view  [rpt].[PBB_SubMetricDaySummary_BV] as 
 
-- Month or MTD
select replace(cast(cast(StartDate as date) as varchar(10)),'-','') YearMonthDay
       , coalesce(nullif(AccountMarket,''),'South AL') AccountMarket
	   , coalesce(dp.AddressType,'No Project') ProjectType
        , sum(case when smd.MetaEffectiveStartDate <   ym.StartDate   and smd.MetaEffectiveEndDate >= ym.StartDate and (smd.SubscriberBeginCount+smd.SubscriberGainCount+smd.SubscriberMoveInCount)>0   and smd.MetaEffectiveEndDate >=  ym.StartDate  then 1 
                  when smd.MetaEffectiveStartDate =   ym.StartDate   and smd.SubscriberBeginCount > 0 then 1
	              else 0 end) BeginCount    -- Active on the 1st

       , sum(case when smd.MetaEffectiveStartDate =   ym.StartDate   then smd.SubscriberGainCount    else 0 end)       Gain  

       , sum(case when smd.MetaEffectiveEndDate   =   ym.StartDate   then smd.SubscriberLossCount    else 0 end)*-1    Loss

       , sum(case when smd.MetaEffectiveStartDate =   ym.StartDate   then smd.SubscriberMoveInCount  else 0 end)       MoveIn

       , sum(case when smd.MetaEffectiveEndDate   =   ym.StartDate   then smd.SubscriberMoveOutCount else 0 end)*-1    MoveOut

       , sum(case when smd.MetaEffectiveStartDate <=  ym.StartDate   and smd.MetaEffectiveEndDate   =  ym.StartDate  and smd.SubscriberEndCount>0   then 1
                  when smd.MetaEffectiveStartDate <=  ym.StartDate   and smd.MetaEffectiveEndDate   >  ym.StartDate  and (smd.SubscriberEndCount+smd.SubscriberlossCount+smd.SubscriberMoveOutCount)>0     then 1
                  else 0 end)                                                                                                                                                                                   EndCount  -- Active on the EOM

  from omnia_epbb_p_pbb_dw.rpt.PBB_SubMetricDaily_BV smd
  join ( select Distinct d.DimDateId StartDate from pbbpdw01.zzz.DimDate d where d.DimDateId <= dateadd(d,-1,getdate()) and d.DimDateId > eomonth(dateadd(m,-1,getdate())) )    ym  on 1=1
  left join PBBPDW01..DimServiceLocationT1 dsl on dsl.DimServiceLocationId = smd.DimServiceLocationId
  left join PBBPDW01..DimProjectT1         dp  on dp.DimProjectKey         = dsl.DimProjectKey
  where 1=1 --and --coalesce(dp.AddressType,'No Project') ='LEGACY'
  group by replace(cast(cast(StartDate as date) as varchar(10)),'-','') , coalesce(Nullif(AccountMarket,''),'South AL')  , coalesce(dp.AddressType,'No Project')
  --order by coalesce(nullif(AccountMarket,''),'South AL') ,  replace(cast(cast(StartDate as date) as varchar(10)),'-','') , ProjectType
 
GO
