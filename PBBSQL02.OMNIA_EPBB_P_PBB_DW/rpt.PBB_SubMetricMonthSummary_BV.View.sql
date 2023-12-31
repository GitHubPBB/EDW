USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_SubMetricMonthSummary_BV]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




 CREATE view  [rpt].[PBB_SubMetricMonthSummary_BV] as 
 
-- Month or MTD
select concat(year(ym.StartDate),right(concat('0',month(ym.StartDate)),2) ) YearMonth
       , coalesce(nullif(AccountMarket,''),'South AL') AccountMarket
	   , coalesce(dp.AddressType,'No Project') ProjectType
       , sum(case when smd.MetaEffectiveStartDate =  ym.StartDate and smd.MetaEffectiveEndDate   >= ym.StartDate and smd.SubscriberBeginCount=1 then 1
                  when smd.MetaEffectiveStartDate <  ym.StartDate and smd.MetaEffectiveEndDate   >= ym.StartDate and (smd.SubscriberBeginCount+smd.SubscriberGainCount+smd.SubscriberMoveInCount)>0 then 1
                  else 0 end)                                                                                                                                                                              BeginCount    -- Active on the 1st

       , sum(case when smd.MetaEffectiveStartDate < dateadd(d,1,eomonth(ym.StartDate))    and smd.MetaEffectiveStartDate >= ym.StartDate and smd.MetaEffectiveEndDate >= ym.StartDate    then smd.SubscriberGainCount    else 0 end)     Gain

       , sum(case when smd.MetaEffectiveEndDate   >= ym.StartDate                                              and smd.MetaEffectiveEndDate <  dateadd(d,1,eomonth(ym.StartDate))     then smd.SubscriberLossCount    else 0 end)*-1  Loss

       , sum(case when smd.MetaEffectiveStartDate < dateadd(d,1,eomonth(ym.StartDate))   and smd.MetaEffectiveStartDate >= ym.StartDate and smd.MetaEffectiveEndDate >= ym.StartDate    then smd.SubscriberMoveInCount  else 0 end)     MoveIn

       , sum(case when smd.MetaEffectiveEndDate   >= ym.StartDate and smd.MetaEffectiveEndDate   >= ym.StartDate and smd.MetaEffectiveEndDate   < dateadd(d,1,eomonth(ym.StartDate))    then smd.SubscriberMoveOutCount else 0 end)*-1  MoveOut

       , sum(case when smd.MetaEffectiveStartDate < dateadd(d,1,eomonth(ym.StartDate))    and smd.MetaEffectiveEndDate   = eomonth(ym.StartDate)   and smd.SubscriberEndCount>0   then 1
                  when smd.MetaEffectiveStartDate < dateadd(d,1,eomonth(ym.StartDate))    and smd.MetaEffectiveEndDate   >= dateadd(d,1,eomonth(ym.StartDate))  and (smd.SubscriberEndCount+smd.SubscriberlossCount+smd.SubscriberMoveOutCount)>0                   then 1
                  else 0 end)                                                                                                                                                                              EndCount  -- Active on the EOM

  from omnia_epbb_p_pbb_dw.rpt.PBB_SubMetricDaily_BV smd
  join ( select * from ( values ('20230101'),('20230201'),('20230301'),('20230401'),('20230501'),('20230601'),('20230701'),('20230801'),('20230901'),('20231001'),('20231101'),('20231201') ) as TempYearMonth(StartDate) where StartDate <= getdate() )    ym  on 1=1
  left join PBBPDW01..DimServiceLocationT1 dsl on dsl.DimServiceLocationId = smd.DimServiceLocationId
  left join PBBPDW01..DimProjectT1         dp  on dp.DimProjectKey = dsl.DimProjectKey
  where    concat(year(StartDate),right(concat('0',month(StartDate)),2) )  >= '202301'
  group by concat(year(ym.StartDate),right(concat('0',month(ym.StartDate)),2) )  , coalesce(Nullif(AccountMarket,''),'South AL')  , coalesce(dp.AddressType,'No Project')
 
GO
