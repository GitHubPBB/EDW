USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_FactProjectPenetration]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[PBB_Populate_FactProjectPenetration]
	@CycleDate date
AS


BEGIN

-- select * into FactProjectPenetration_bk20231019 from FactProjectPenetration
-- DELETE from FactProjectPenetration where DimDate = '20231001';
-- DELETE from FactProjectPenetration where DimDate = '20230930';


-- DECLARE @CycleDate date='20231201'
DECLARE @MaxKey int=0;
DECLARE @RunDatetime datetime = getdate();
DECLARE @CycleDt date;

SELECT @CycleDt = case when @CycleDate is not null then dateadd(d,-1,cast(@CycleDate as date)) else cast(getdate() as date) end;
DECLARE @PrevCycleDt   date =   dateadd(m,-1,@CycleDt) ;
--DECLARE @PrevCycleDt date =   case when day(@CycleDt)=15 then  eomonth(dateadd(m,-1,@CycleDt)) else dateadd(d,15,eomonth(dateadd(m,-1,@CycleDt))) end;
--print @PrevCycleDt


SELECT @MaxKey = coalesce(max(FactProjectPenetrationId),0) FROM [PBBPDW01].dbo.FactProjectPenetration  ;

 -----------------

DROP TABLE if exists #TempProjectAge;
WITH 

ProjectAge 

  AS (  SELECT ProjectCode
             , datediff(m,cast(ProjectServiceableDate as date),dateadd(d,-1,@CycleDate)) ProjectAgeMonths
			 , cast(ProjectServiceableDate as date)  ServiceableDate
			 , dateadd(d,-1,@CycleDate) ThruDate
		  FROM  [PBBPDW01].dbo.DimProjectT1
		 WHERE coalesce(ProjectServiceableDate,'99991231') <> '99991231'
  )
 SELECT * into #TempProjectAge FROM ProjectAge order by 1;

 -- select * from #TempProjectAge order by ProjectCode

-- 
DROP TABLE if exists #TempProjectLocations;
WITH 
  ProjectLocations AS

 (	SELECT distinct dp.DimProjectKey, dp.DimProjectNaturalKey, csl.cus_ProjectCode, csl.chr_MasterLocationId LocationId
				             , case when dsl.ServiceLocationRegion_WireCenter like '%Urban%' then 'Urban' else 'Rural' end AddressType
							FROM Transient.chr_servicelocation          csl  
							JOIN [PBBPDW01].dbo.DimProjectT1            dp   on dp.ProjectCode = csl.cus_ProjectCode   COLLATE DATABASE_DEFAULT
							JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation    dsl  on dsl.locationid = csl.chr_masterlocationid
						   WHERE chr_ServiceLocationId is not null
						     AND csl.cus_Serviceable = '972050000'   -- Serviceable Check
						   --  AND Cus_ProjectCode = 'PC-CLAR2022 PROJECT #57 CAB - FNB004'
	 )       
 SELECT * into #TempProjectLocations FROM ProjectLocations;
 -- select * from #TempProjectLocations where DimProjectNaturalKey = 'WO-00514'
 -- select * from dimproject where DimProjectNaturalKey = 'WO-00069'
 -- select * from  Transient.chr_servicelocation   where cus_ProjectCode = 'PC-RHEA VALLEY'
 -- select * from #TempProjectLocations where cus_ProjectCode = 'PC-ABBS VALLEY PROJECT'

 -- declare @CycleDt date='20231001';
DROP TABLE if exists #TempProjects1;
 WITH ProjectActives AS 

 ( 
  SELECT  x.DimAccountId, dsl.LocationId, dac.AccountTypeCode, dac.AccountSegment, dacp.pbb_ReportingMarket, case when dsl.ServiceLocationRegion_WireCenter like '%Urban%' then 'Urban' else 'Rural' end AddressType
                , sum(x.ItemPrice) MRC
				              FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x
							  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation      dsl  on x.DimServiceLocationId = dsl.DimServiceLocationId							 
							  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccount              dc   ON x.DimAccountId         = dc.DimAccountId 
											                                              AND coalesce(AccountCode,'')  <> ''
							  JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimAccountCategory        dac  on x.DimAccountCategoryId = dac.DimAccountCategoryId
							  JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimAccountCategory_pbb    dacp on dacp.SourceId = dac.SourceId
				             WHERE 1=1
							   AND (  cast(x.EffectiveStartDate as date) <= @CycleDt
							       or (AccountCode in (select AccountCode from pbbpdw01.dbo.SAVE_SalesOrderChangedOrderDate ) 
								               and @CycleDate <='20231001'
									  )
							   )
							   AND cast(x.EffectiveEndDate   as date) >  @CycleDt
							   AND x.Deactivation_DimDateId           >  @CycleDt
							   AND right(x.SourceId,2) <> '.N' 
	group by  x.DimAccountId, dsl.LocationId, dac.AccountTypeCode, dac.AccountSegment, dacp.pbb_ReportingMarket, case when dsl.ServiceLocationRegion_WireCenter like '%Urban%' then 'Urban' else 'Rural' end
	 ) 
	select pl.DimProjectKey, pl.cus_ProjectCode, max(coalesce(pa.pbb_ReportingMarket,'')) ReportingMarket
				     , count(distinct pl.Locationid) ServiceableAddresses
					 , min(pl2.CompetitiveAddresses) CompetitiveAddresses
					 , min(pl2.UnderServedAddresses) UnderServedAddresses
				     , sum(case when (coalesce(pa.AccountTypeCode,'') = 'RES' or pa.AccountSegment like '%RES%') and pa.AddressType = 'Urban' then 1 else 0 end)  ActiveRESCompetitiveAccounts
				     , sum(case when (coalesce(pa.AccountTypeCode,'') = 'RES' or pa.AccountSegment like '%RES%') and pa.AddressType = 'Rural' then 1 else 0 end)  ActiveRESUnderServedAccounts
				     , sum(case when (coalesce(pa.AccountTypeCode,'') = 'BUS' or pa.AccountSegment like '%BUS%') and pa.AddressType = 'Urban' then 1 else 0 end)  ActiveBUSCompetitiveAccounts
				     , sum(case when (coalesce(pa.AccountTypeCode,'') = 'BUS' or pa.AccountSegment like '%BUS%') and pa.AddressType = 'Rural' then 1 else 0 end)  ActiveBUSUnderServedAccounts
					 , sum(case when pa.DimAccountId is not null and  coalesce(pa.AccountTypeCode,'') not in ('BUS','RES') and not pa.AccountSegment like '%RES%' and not pa.AccountSegment like '%BUS%'  then 1 else 0 end) NotBusRes 
					 , sum(case when pa.DimAccountId is not null and pa.AddressType not in ('Rural','Urban') then 1 else 0 end) NotUrbanRural
					-- , count(pa.DimAccountId) TotalActiveAccounts  -- tb 20230315
					 , SUM(  CASE WHEN  pa.DimAccountId IS NULL  THEN 0 ELSE 1 END)  TotalActiveAccounts -- sk 20230316
					 , min(coalesce(pag.ProjectAgeMonths,-1)) ProjectAgeMonths -- tb 20230315
					 , sum(mrc) mrc
	   into #TempProjects1
	   from #TempProjectLocations    pl
	   join (select cus_ProjectCode
	              , sum(case when AddressType = 'Urban' then 1 else 0 end) CompetitiveAddresses
	              , sum(case when AddressType = 'Urban' then 0 else 1 end) UnderServedAddresses
			    from #TempProjectLocations
				group by cus_ProjectCode
		) pl2
			on pl.cus_ProjectCode = pl2.cus_ProjectCode
	   left join ProjectActives     pa   ON pl.LocationId   = pa.LocationId
	   left join #TempProjectAge    pag  ON pag.ProjectCode = pl.cus_ProjectCode COLLATE DATABASE_DEFAULT
	   group by pl.DimProjectKey, pl.cus_ProjectCode 
	   order by pl.cus_ProjectCode
;

/*
declare @CycleDt date = '20230930', @CycleDate date ='20231001';
 WITH ProjectActives AS 

 ( 
  SELECT  x.DimAccountId, dsl.LocationId, dc.AccountCode, dac.AccountTypeCode, dacp.pbb_ReportingMarket, case when dsl.ServiceLocationRegion_WireCenter like '%Urban%' then 'Urban' else 'Rural' end AddressType
                , sum(x.ItemPrice) MRC
				              FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x
							  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation      dsl  on x.DimServiceLocationId = dsl.DimServiceLocationId							 
							  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccount              dc   ON x.DimAccountId         = dc.DimAccountId 
											                                              AND coalesce(AccountCode,'')  <> ''
							  JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimAccountCategory        dac  on x.DimAccountCategoryId = dac.DimAccountCategoryId
							  JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimAccountCategory_pbb    dacp on dacp.SourceId = dac.SourceId
				             WHERE 1=1
							   AND (  cast(x.EffectiveStartDate as date) <= @CycleDt
							       or (AccountCode in (select AccountCode from pbbpdw01.dbo.SAVE_SalesOrderChangedOrderDate ) 
								               and @CycleDate <='20231001'
									  )
							   )
							   AND cast(x.EffectiveEndDate   as date) >  @CycleDt
							   AND x.Deactivation_DimDateId           >  @CycleDt
							   AND right(x.SourceId,2) <> '.N' 
	group by  x.DimAccountId, dsl.LocationId, dc.AccountCode,dac.AccountTypeCode, dacp.pbb_ReportingMarket, case when dsl.ServiceLocationRegion_WireCenter like '%Urban%' then 'Urban' else 'Rural' end
	 ) 
	select pl.DimProjectKey, pl.cus_ProjectCode, pa.AccountCode, max(coalesce(pa.pbb_ReportingMarket,'')) ReportingMarket
				     , count(distinct pl.Locationid) ServiceableAddresses
					 , min(pl2.CompetitiveAddresses) CompetitiveAddresses
					 , min(pl2.UnderServedAddresses) UnderServedAddresses
				     , sum(case when coalesce(pa.AccountTypeCode,'') = 'RES' and pa.AddressType = 'Urban' then 1 else 0 end)  ActiveRESCompetitiveAccounts
				     , sum(case when coalesce(pa.AccountTypeCode,'') = 'RES' and pa.AddressType = 'Rural' then 1 else 0 end)  ActiveRESUnderServedAccounts
				     , sum(case when coalesce(pa.AccountTypeCode,'') = 'BUS' and pa.AddressType = 'Urban' then 1 else 0 end)  ActiveBUSCompetitiveAccounts
				     , sum(case when coalesce(pa.AccountTypeCode,'') = 'BUS' and pa.AddressType = 'Rural' then 1 else 0 end)  ActiveBUSUnderServedAccounts
					 , sum(case when coalesce(pa.AccountTypeCode,'') not in ('BUS','RES') or pa.AddressType not in ('Rural','Urban') then 1 else 0 end) NotBusResUrbanRural
					-- , count(pa.DimAccountId) TotalActiveAccounts  -- tb 20230315
					 , SUM(  CASE WHEN  pa.DimAccountId IS NULL  THEN 0 ELSE 1 END)  TotalActiveAccounts -- sk 20230316
					 , min(coalesce(pag.ProjectAgeMonths,-1)) ProjectAgeMonths -- tb 20230315
					 , sum(mrc) mrc
 
	   from #TempProjectLocations    pl
	   join (select cus_ProjectCode
	              , sum(case when AddressType = 'Urban' then 1 else 0 end) CompetitiveAddresses
	              , sum(case when AddressType = 'Urban' then 0 else 1 end) UnderServedAddresses
			    from #TempProjectLocations
				group by cus_ProjectCode
		) pl2
			on pl.cus_ProjectCode = pl2.cus_ProjectCode
	   left join ProjectActives     pa   ON pl.LocationId   = pa.LocationId
	   left join #TempProjectAge    pag  ON pag.ProjectCode = pl.cus_ProjectCode COLLATE DATABASE_DEFAULT 
	     
	   group by pl.DimProjectKey, pl.cus_ProjectCode , pa.AccountCode
	   HAVING max(coalesce(pa.pbb_ReportingMarket,''))  in ('North Georgia'
,'NorthEast GA - Fixed'
,'NorthEast GA - FTTH')
	   order by pl.cus_ProjectCode

*/

-- select * from #TempProjects1 where NotUrbanRural <> 0 or NotBusRes <> 0
-- select *,mrc/TotalactiveAccounts from #TempProjects1 order by 1

-- Calc Penetration Percents
DROP TABLE if exists #TempProjects2;
select * 
     ,  case when CompetitiveAddresses > 0 and (ActiveRESCompetitiveAccounts+ActiveBUSCompetitiveAccounts) > 0 
	         then cast((ActiveRESCompetitiveAccounts+ActiveBUSCompetitiveAccounts)*100.0/(CompetitiveAddresses*1.00) as decimal(5,2) )
			 end CompetitivePenetration

     ,  case when UnderServedAddresses > 0 and (ActiveRESUnderServedAccounts+ActiveBUSUnderServedAccounts) > 0 
	         then cast((ActiveRESUnderServedAccounts+ActiveBUSUnderServedAccounts)*100.0/(UnderServedAddresses*1.00) as decimal(5,2) )
			 end UnderServedPenetration

     ,  case when UnderServedAddresses+CompetitiveAddresses > 0 and ( ActiveRESCompetitiveAccounts+ActiveBUSCompetitiveAccounts+ ActiveRESUnderServedAccounts+ActiveBUSUnderServedAccounts) > 0
			 then cast( ( ActiveRESCompetitiveAccounts+ActiveBUSCompetitiveAccounts+ ActiveRESUnderServedAccounts+ActiveBUSUnderServedAccounts)*100.00/(ServiceableAddresses*1.00) as decimal(5,2) ) 
			 end TotalPenetration
  into #TempProjects2
  from #TempProjects1 tp1
    order by 1
	;


DROP TABLE if exists #TempProjects3;
-- Calc Penetration Goal Color
-- declare @MaxKey int=0, @CycleDate date=CAST('20231001' as date);
select (@MaxKey + Row_Number() over (order by dp.DimProjectKey)) FactProjectPenetrationId
     , dp.DimProjectKey
     , dp.DimMarketKey
	 ,dateadd(d,-1, @CycleDate) DimDate
     , case when tp2.ProjectAgeMonths is null then -1 else tp2.ProjectAgeMonths end ProjectAgeMonths
	 , tp2.CompetitiveAddresses   CompetitiveAddressCount
	 , tp2.UnderServedAddresses   UnderServedAddressCount
	 , tp2.ServiceableAddresses   ServiceableAddressCount
	 , ActiveREScompetitiveAccounts ActiveCompetitiveRESCount
	 , ActiveBUScompetitiveAccounts ActiveCompetitiveBUSCount
	 , ActiveRESCompetitiveAccounts+ActiveBUSCompetitiveAccounts ActiveCompetitiveCustomerCount
	 , ActiveRESUnderServedAccounts ActiveUnderServedRESCount
	 , ActiveBUSUnderServedAccounts ActiveUnderServedBUSCount
	 , ActiveRESUnderServedAccounts+ActiveBUSUnderServedAccounts ActiveUnderServedCustomerCount
	 , ActiveRESCompetitiveAccounts+ActiveBUSCompetitiveAccounts + ActiveRESUnderServedAccounts+ActiveBUSUnderServedAccounts  as ActiveTotalCustomerCount
	 , 0 CurrentMonthlyBilledAvgMRC
	 , CompetitivePenetration
	 , UnderServedPenetration
	 , coalesce(TotalPenetration,0) TotalPenetration
     , pgrC.RedGoalPct*100 CompetitiveRedGoalPct, pgrC.GreenGoalPct*100 CompetitiveGreenGoalPct

     , case when tp2.ProjectAgeMonths   is null                 then null
	        when tp2.ProjectAgeMonths  =  0 and coalesce(CompetitivePenetration,0) =0   then 'White'
	        when tp2.ProjectAgeMonths  =  0 and coalesce(CompetitivePenetration,0) >0   and CompetitiveType in ( 'Competitive','Hybrid') then 'Green'
	        when CompetitiveType not in ( 'Competitive')  and coalesce(CompetitivePenetration,0)=0          then 'White'
	        when CompetitiveType = 'Hybrid'               and coalesce(CompetitivePenetration,0)=0          then 'White'
	        when CompetitiveType in ( 'Competitive')      and CompetitivePenetration/100 >  coalesce(pgrc.GreenGoalPct,pgrCM.GreenGoalPct)  then 'Green'
	        when CompetitiveType in ( 'Hybrid')           and CompetitivePenetration/100 >  coalesce(pgrH.GreenGoalPct,pgrHM.GreenGoalPct)  then 'Green'
			when CompetitiveType in ( 'Competitive')      and CompetitivePenetration/100 <= coalesce(pgrc.RedGoalPct,pgrCM.RedGoalPct)      then 'Red'
			when CompetitiveType in ( 'Hybrid')           and CompetitivePenetration/100 <= coalesce(pgrH.RedGoalPct,pgrHM.RedGoalPct)      then 'Red'
			else 'Yellow'
			end GrowthGoalCompetitiveColor

     , pgrU.RedGoalPct*100 UnderServedRedGoalPct, pgrU.GreenGoalPct*100 UnderServedGreenGoalPct

     , case when tp2.ProjectAgeMonths   is null                then null
	        when tp2.ProjectAgeMonths  =  0 and coalesce(UnderServedPenetration,0) =0   then 'White'
	        when tp2.ProjectAgeMonths  =  0 and coalesce(UnderServedPenetration,0) =0 and CompetitiveType in ( 'Non-Competitive','Hybrid')  then 'Green'
	        when CompetitiveType = 'Competitive'          and  coalesce(UnderServedPenetration,0)=0 then 'White'
	        when CompetitiveType = 'Hybrid'               and  coalesce(UnderServedPenetration,0)=0 then 'White'
	        when CompetitiveType in ( 'Non-Competitive')  and UnderServedPenetration/100 >  coalesce(pgrU.GreenGoalPct,pgrUM.GreenGoalPct)  then 'Green'
	        when CompetitiveType in ( 'Hybrid')           and UnderServedPenetration/100 >  coalesce(pgrH.GreenGoalPct,pgrHM.GreenGoalPct)  then 'Green'
			when CompetitiveType in ( 'Non-Competitive')  and UnderServedPenetration/100 <= coalesce(pgrU.RedGoalPct,pgrUM.RedGoalPct)      then 'Red'
			when CompetitiveType in ( 'Hybrid')           and UnderServedPenetration/100 <= coalesce(pgrH.RedGoalPct,pgrHM.RedGoalPct)      then 'Red'
			else 'Yellow'
			end GrowthGoalUnderServedColor

     , case when tp2.ProjectAgeMonths   is null                then null
	        when tp2.ProjectAgeMonths  =  0 and coalesce(TotalPenetration,0) =0   then 'White'
	        when tp2.ProjectAgeMonths  =  0 and coalesce(TotalPenetration,0) >0   then 'Green'
	        when dp.CompetitiveType = 'Non-Competitive' then 
				 case when TotalPenetration/100 >  coalesce(pgrU.GreenGoalPct,pgrUM.GreenGoalPct) then 'Green'
					  when TotalPenetration/100 <= coalesce(pgrU.RedGoalPct,pgrUM.RedGoalPct)     then 'Red'
					  else 'Yellow'
				  end 
	        when dp.CompetitiveType = 'Hybrid'     then 
				 case when TotalPenetration/100 >  coalesce(pgrH.GreenGoalPct,pgrHM.GreenGoalPct) then 'Green'
					  when TotalPenetration/100 <= coalesce(pgrH.RedGoalPct,pgrHM.RedGoalPct)     then 'Red'
					  else 'Yellow'
				  end 
			else
				 case when TotalPenetration/100 >  coalesce(pgrc.GreenGoalPct,pgrCM.GreenGoalPct) then 'Green'
					  when TotalPenetration/100 <= coalesce(pgrc.RedGoalPct,pgrCM.RedGoalPct)     then 'Red'
					  else 'Yellow'
				  end 
			end GrowthGoalTotalColor

	 , case when tp2.ProjectAgeMonths = 0            then 0
	        when CompetitiveType = 'Competitive'     then coalesce(pgrC.RedGoalPct,pgrCM.RedGoalPct) *100
	        when CompetitiveType = 'Non-Competitive' then coalesce(pgrU.RedGoalPct,pgrUM.RedGoalPct) *100
			else coalesce(pgrH.RedGoalPct,pgrHM.RedGoalPct ) *100
			end GrowthRampRedGoalPct

	 , case when tp2.ProjectAgeMonths = 0            then 0
	        when CompetitiveType = 'Competitive'     then coalesce(pgrC.GreenGoalPct,pgrCM.GreenGoalPct) *100
	        when CompetitiveType = 'Non-Competitive' then coalesce(pgrU.GreenGoalPct,pgrUM.GreenGoalPct) *100
			else coalesce(pgrH.GreenGoalPct,pgrHM.GreenGoalPct) *100
			end GrowthRampGreenGoalPct

	 , dp.CompetitiveType
	 , dp.ProjectName 
  into #TempProjects3
  from #TempProjects2 tp2
  join dbo.DimProjectT1                       dp   on dp.ProjectCode = tp2.cus_ProjectCode COLLATE DATABASE_DEFAULT 
  left join [PBBPDW01].dbo.ProjectGrowthRamp  pgrU on pgrU.ProjectAddressType      = 'Underserved' and tp2.UnderServedAddresses > 0  and pgrU.ProjectAgeMonths = tp2.ProjectAgeMonths 
  left join [PBBPDW01].dbo.ProjectGrowthRamp  pgrC on pgrC.ProjectAddressType      = 'Competitive' and tp2.CompetitiveAddresses > 0  and pgrC.ProjectAgeMonths = tp2.ProjectAgeMonths 
  left join [PBBPDW01].dbo.ProjectGrowthRamp  pgrH on pgrH.ProjectAddressType      = 'Hybrid'      and TotalPenetration         >= 0 and pgrH.ProjectAgeMonths = tp2.ProjectAgeMonths 

  left join [PBBPDW01].dbo.ProjectGrowthRamp  pgrCM  on pgrCM.ProjectAddressType   = 'Competitive' and TotalPenetration         >= 0 and pgrCM.ProjectAgeMonths  = 36 AND tp2.ProjectAgeMonths > 36
  left join [PBBPDW01].dbo.ProjectGrowthRamp  pgrHM  on pgrHM.ProjectAddressType   = 'Hybrid'      and TotalPenetration         >= 0 and pgrHM.ProjectAgeMonths  = 36 AND tp2.ProjectAgeMonths > 36
  left join [PBBPDW01].dbo.ProjectGrowthRamp  pgrUM  on pgrUM.ProjectAddressType   = 'Underserved' and UnderServedPenetration   >= 0 and pgrUM.ProjectAgeMonths  = 36 AND tp2.ProjectAgeMonths > 36
;

-- select * from [PBBPDW01].dbo.ProjectGrowthRamp 
-- select * from #TempProjects3 where dimmarketkey in ( 19,33,34) order by ProjectName


INSERT INTO dbo.FactProjectPenetration (
	   [FactProjectPenetrationId]
      ,[DimProjectId]
      ,[DimMarketId]
      ,[DimDate]
      ,[ProjectAgeMonths]
      ,[CompetitiveAddressCount]
      ,[UnderservedAddressCount]
      ,[ServiceableAddressCount]
      ,[ActiveCompetitiveRESCount]
      ,[ActiveCompetitiveBUSCount]
      ,[ActiveCompetitiveCustomerCount]
      ,[ActiveUnderServedRESCount]
      ,[ActiveUnderServedBUSCount]
      ,[ActiveUnderservedCustomerCount]
	  ,[ActiveTotalCustomerCount]
      ,[CurrentMonthBilledAvgMRC]
      ,[CompetitivePenetration]
      ,[UnderservedPenetration]
      ,[TotalPenetration]
      ,[GrowthGoalCompetitiveColor]
      ,[GrowthGoalUnderServedColor]
      ,[GrowthGoalTotalColor]
	  ,GrowthRampRedGoalPct
	  ,GrowthRampGreenGoalPct
	  ,ConnectCount
	  ,DisconnectCount
	  ,GetToGreenCustomerCount
)
SELECT x.FactProjectPenetrationId
     , x.DimProjectKey
	 , x.DimMarketKey
	 , x.DimDate
	 , x.ProjectAgeMonths
	 , x.CompetitiveAddressCount
	 , x.UnderServedAddressCount
	 , x.ServiceableAddressCount
	 , x.ActiveCompetitiveRESCount
	 , x.ActiveCompetitiveBUSCount
	 , x.ActiveCompetitiveCustomerCount
	 , x.ActiveUnderServedRESCount
	 , x.ActiveUnderServedBUSCount
	 , x.ActiveUnderServedCustomerCount
	 , x.ActiveTotalCustomerCount
	 , x.CurrentMonthlyBilledAvgMRC
	 , x.CompetitivePenetration
	 , x.UnderServedPenetration
	 , coalesce(x.TotalPenetration,0) TotalPenetration
	 , x.GrowthGoalTotalColor GrowthGoalCompetitiveColor
	 , x.GrowthGoalTotalColor GrowthGoalUnderServedColor
	 , x.GrowthGoalTotalColor
	  ,x.GrowthRampRedGoalPct
	  ,x.GrowthRampGreenGoalPct
	  ,0 ConnectCount
	  ,0 DisconnectCount
	  --,0 GetToGreenCustomerCount
      , case when x.TotalPenetration is not null and x.GrowthGoalTotalColor =  'Green' then cast(round(((x.GrowthRampGreenGoalPct * x.ServiceableAddressCount)*1.00/100 - (x.ActiveTotalCustomerCount) + .49),0) as smallint)
			 when x.TotalPenetration is not null and x.GrowthGoalTotalColor <> 'Green' then cast(round(((x.GrowthRampGreenGoalPct * x.ServiceableAddressCount)*1.00/100 - (x.ActiveTotalCustomerCount) - .49),0) as smallint)
			else null
			end  GetToGreenCustomerCount
  -- select *
  FROM #TempProjects3                  x
  LEFT JOIN dbo.FactProjectPenetration y ON  x.DimProjectKey = y.DimProjectId 
                                         AND x.DimDate       = y.DimDate
  WHERE y.DimProjectId is null
    AND coalesce(x.DimProjectKey,0) <> 4248
  ORDER BY x.DimProjectKey
;
 
 -- select * from #TempProjects3 where dimProjectKey =32


---------  MRC MRC MRC



-- DECLARE @CycleDt date='20230930';
DROP TABLE if exists #TempProjectAccts;
-- Accounts LocationId
WITH AcctsInProject AS
   ( SELECT x.DimAccountId, dc.AccountCode, dsl.LocationId
          , min(dac.AccountTypeCode) AccountTypeCode
          , min(case when dsl.ServiceLocationRegion_WireCenter like '%Urban%' then 'Urban' else 'Rural' end) AddressType
		  , sum(ItemPrice*ItemQuantity) FCIPrice
				              FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x
							  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation      dsl on x.DimServiceLocationId = dsl.DimServiceLocationId							 
							  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccount              dc  ON x.DimAccountId         = dc.DimAccountId 
											                                             AND coalesce(AccountCode,'')  <> ''
							  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCustomerProduct      dcp ON dcp.DimCustomerProductId = x.DimCustomerProductId
							                                                             AND dcp.ProductStatusCode = 'A'
							  LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccountCategory dac on dac.DimAccountCategoryId = x.DimAccountCategoryId
				             WHERE 1=1
							   AND (  cast(x.EffectiveStartDate as date) <= @CycleDt
							       or (AccountCode in (select AccountCode from pbbpdw01.dbo.SAVE_SalesOrderChangedOrderDate ) 
								               and @CycleDate <'20231001'
									  )
								)
							   AND cast(x.EffectiveStartDate as date) <= @CycleDt
							   AND right(x.SourceId,2) <> '.N'
	  GROUP BY x.DimAccountId, dc.AccountCode, dsl.LocationId 
	)
select * into #TempProjectAccts from AcctsInProject
;
-- select top 1000 * from #TempProjectAccts 

DROP TABLE if exists #TempFactBilled;
-- Accounts and Invoices
WITH FactBilled AS (
		SELECT ba.DimAccountId, da.AccountCode, ba.RecurringAmount, ba.DiscountAmount, ba.NetAmount, br.BillingYearMonth, br.BillingCycle
		     , br.PreBillFromDate, br.PreBillThruDate
		     , row_number() over (partition by ba.DimAccountId order by PreBillThruDate desc) row_num
		  FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactBilledAccount  ba
		  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimBillingRun      br on br.Dimbillingrunid = ba.dimbillingrunid
		  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccount         da on da.DimAccountId    = ba.DimAccountId    
		 WHERE ba.DimAccountId in (Select DimAccountId from #TempProjectAccts)
) 
SELECT * INTO #TempFactBilled FROM FactBilled
;


DROP TABLE if exists #TempAcctsProject;
WITH AcctProject AS (
-- Locations in Projects
SELECT coalesce(wob.chr_WO_number  ,wob.chr_name) NaturalKey
     , chr_masterlocationid LocationId
     , chr_RegionIdName
     , cus_ProjectName 
	 , cus_CabinetNameName
	 , cus_Serviceable
	 , cus_projectCode
	 , cus_project
   FROM  [PBBPDW01].[transient].chr_workorder wob   
   JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation_pbb dsl  on replace(dsl.pbb_LocationProjectCode,'PC-','') COLLATE DATABASE_DEFAULT  = upper(replace(wob.chr_name,'PC-',''))  COLLATE DATABASE_DEFAULT 
                                                                    and coalesce(pbb_LocationProjectCode,'') <> ''
																	and pbb_LocationProjectCode <> 'Unknown'
																	and pbb_LocationProjectCode <> 'PC-Duplicate - Do Not Use'
   JOIN [PBBPDW01].[transient].[chr_servicelocation] csl on csl.chr_masterlocationid = dsl.LocationId
   JOIN DimProjectT1                                       dp  on dp.DimProjectNaturalKey = coalesce(wob.chr_WO_number  ,wob.chr_name) COLLATE DATABASE_DEFAULT


  WHERE cus_ProjectName is not null
)
select * into #TempAcctsProject from AcctProject
;
-- select * from #TempAcctsProject




-- DECLARE @CycleDt date='20230930';
DROP TABLE if exists #TempProjectMRCDetail;
WITH fpp as ( select *, row_number() over (partition by dimprojectid order by dimdate desc) row_cnt from dbo.FactProjectPenetration )
select  fpp1.FactProjectPenetrationId
     , tfb.DimAccountId
	 , tfb.AccountCode
	 , AccountTypeCode
	 , tpa.AddressType
	 , FCIPrice
	 , tfb.RecurringAmount
	 , tfb.DiscountAmount
	 , tfb.NetAmount
	 , BillingYearMonth
	 , BillingCycle
	 , PreBillFromDate
	 , PreBillThruDate
	 , ap.LocationId
	 , ap.NaturalKey 
	 , dp.CompetitiveType
	 , dp.DimProjectKey
	 , dp.ProjectName
	 , (dateadd(m,-1  ,fpp1.DimDate))  XactionFromDate
	 , fpp1.DimDate XactionThruDate
into #TempProjectMRCDetail
FROM #TempProjectAccts      tpa
left join #TempFactBilled   tfb  on tfb.DimAccountId = tpa.DimAccountId 
left join #TempAcctsProject ap   on ap.LocationId = tpa.LocationId
left join dbo.DimProjectT1  dp   on dp.DimProjectNaturalKey = ap.NaturalKey COLLATE DATABASE_DEFAULT
left join fpp               fpp1 on fpp1.DimProjectId = dp.DimProjectKey and PreBillFromDate <= fpp1.DimDate
                                 and PreBillFromDate > (dateadd(m,-1  ,fpp1.DimDate)) 
where 1=1
    and fpp1.DimDate = @CycleDt
	--and dp.DimProjectId = 125 
;

-- select * from #TempProjectMrcDETAil order by ProjectName ,AccountCode      where DimProjectId=125


/*
WITH ProjAvgMRC AS (select DimProjectKey, FactProjectPenetrationId
                         , sum(RecurringAmount) TtlRecurringAmt
						 , count(*) CountRecurringAmt
						-- , sum(RecurringAmount)/count(*) AvgRecurringAmt 
						 , sum(FCIPrice)/count(*) AvgRecurringAmt 
                      from #TempProjectMrcDETAil  
                     group by DimProjectKey, FactProjectPenetrationId 
					-- order by 1
				  )
*/
UPDATE fpp
   SET CurrentMonthBilledAvgMRC = case when coalesce(tp.mrc,0) <> 0 and TotalActiveAccounts >0 then mrc/TotalActiveAccounts else 0 end
  FROM dbo.FactProjectPenetration fpp 
  JOIN #TempProjects1             tp  on tp.DimProjectKey = fpp.DimProjectId
   AND fpp.DimDate = @CycleDt
;


-- alter table factProjectPenetration add   AccountType varchar(20)
WITH ProjAcctType AS (
SELECT x.FactProjectPenetrationId, DimProjectKey, ProjectName
     , coalesce(BUS_Count,0) BUS_Count
     , coalesce(RES_Count,0) RES_Count
	 , case when coalesce(BUS_Count,0) =0 and coalesce(RES_Count,0) > 0 THEN 'Residential'
	        when coalesce(BUS_Count,0) >0 and coalesce(RES_Count,0) = 0 THEN 'Commercial'
	        when coalesce(BUS_Count,0) >0 and coalesce(RES_Count,0) > 0 THEN 'Mixed'
	        ELSE 'Unknown'
			END AccountType
  FROM (SELECT distinct FactProjectPenetrationId, DimProjectKey, ProjectName from  #TempProjectMrcDETAil)  x
  LEFT JOIN (SELECT FactProjectPenetrationId,count(*) BUS_Count FROM #TempProjectMrcDETAil WHERE AccountTypeCode = 'BUS' GROUP BY  FactProjectPenetrationId) y on y.FactProjectPenetrationId = x.FactProjectPenetrationId 
  LEFT JOIN (SELECT FactProjectPenetrationId,count(*) RES_Count FROM #TempProjectMrcDETAil WHERE AccountTypeCode = 'RES' GROUP BY  FactProjectPenetrationId) z on z.FactProjectPenetrationId = x.FactProjectPenetrationId 
  -- GROUP BY x.FactProjectPenetrationId
 -- ORDER BY ProjectName
)
UPDATE dbo.FactProjectPenetration 
   SET AccountType = pat.AccountType
  FROM ProjAcctType pat
 WHERE pat.FactProjectPenetrationId = FactProjectPenetration.FactProjectPenetrationId
;

-- Account Type MDU
-- Declare @CycleDt date = '20230930';
  DROP TABLE if exists #MDUAddresses;
	SELECT Distinct dsl.DimServiceLocationId
	     , dsl.LocationId
		 , dsl.ServiceLocationFullAddress
	     , dc.cus_DistributionCenterName
	     , ab.AccountNumber  as MDUAccountCode
	  INTO #MDUAddresses
	  FROM Transient.cus_DistributionCenterBase  dc   
	  JOIN Transient.chr_servicelocation         csl  on dc.cus_distributioncenterId   = csl.cus_ServiceLocationsId
	  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation                dsl  on dsl.locationid                = csl.chr_masterlocationid
	  LEFT JOIN Transient.AccountBase            ab   ON ab.AccountId                  = dc.cus_BulkBillingAccount    -- Get the BULK master account
	;
	 
	DROP TABLE if exists #AcctsAtMDU;
	SELECT * INTO #AcctsAtMDU FROM (
		SELECT ma.*, fsla.DimAccountid, da.AccountCode, row_number() over (partition by ma.DimServiceLocationId order by da.DimAccountId desc) row_cnt
			FROM #MDUAddresses     ma
	  		LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.PBB_ServiceLocationAccountALL  fsla on  fsla.DimServiceLocationId = ma.DimServiceLocationId
															  and fsla.LocationAccountDeactivationDate > @CycleDt
			LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccount                     da   on da.DimAccountId           = fsla.dimAccountId
															  and coalesce(da.AccountStatus,'')   <>'Inactive'
		WHERE 1=1 --(MDUAccountCode is not null or fsla.DimAccountId <> 0)
	) z
	WHERE NOT (row_cnt > 1 and DimAccountId = 0)
	;

	WITH MduProject AS (
			SELECT Distinct DimProjectKey FROM #TempProjectLocations pl JOIN #AcctsAtMDU aam on aam.LocationId = pl.LocationId WHERE MDUAccountCode IS NOT NULL 
	)
	UPDATE dbo.FactProjectPenetration
	   SET AccountType = 'MDU'
	  FROM MduProject m
	 WHERE m.DimProjectKey = FactProjectPenetration.DimProjectId
	  ;

---------   Connect / Disconnects
 

 -- Declare @CycleDt date = '20230930',   @PrevCycleDt date='20230831'; 


DROP TABLE if exists #TempProjects1Current;
WITH ProjectActives AS (

SELECT Distinct DimProjectKey, ProjectCode, AccountCode, LocationId FROM (

SELECT   DimProjectKey, cus_ProjectCode ProjectCode, da.AccountCode, pl.LocationId, fci.*,dcp.ProductName, dcp.ProductStatusCode --, dci.ItemStatus, dci.ItemDeactivationDate
  FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] fci
  JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount         da  on da.DimAccountId = fci.DimAccountId
  join [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation dsl on dsl.DimServiceLocationId = fci.DimServiceLocationId
  join (
  	SELECT distinct dp.DimProjectKey, dp.DimProjectNaturalKey, csl.cus_ProjectCode, csl.chr_MasterLocationId LocationId
				             , case when dsl.ServiceLocationRegion_WireCenter like '%Urban%' then 'Urban' else 'Rural' end AddressType
							FROM [PBBPDW01].Transient.chr_servicelocation        csl  
							JOIN [PBBPDW01].dbo.DimProjectT1                     dp   on dp.ProjectCode = csl.cus_ProjectCode   COLLATE DATABASE_DEFAULT
							JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation    dsl  on dsl.locationid = csl.chr_masterlocationid
						   WHERE chr_ServiceLocationId is not null
						     AND csl.cus_Serviceable = '972050000'   -- Serviceable Check
						   --  AND Cus_ProjectCode = 'PC-ALMA PROJECT - MIALMACOURTCABT'
  ) pl on pl.LocationId = dsl.LocationId
  JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimCustomerProduct dcp on  dcp.DimCustomerProductId = fci.DimCustomerProductId 
                                                        --  AND dcp.ProductStatusCode = 'A'
 -- JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimCustomerItem    dci on  dci.DimCustomerItemId = fci.DimCustomerItemId 
 --                                                         AND (coalesce(dci.ItemStatus,'A') = 'A' 
 --														       or coalesce(dci.ItemDeactivationDate,'99991231') > '20230228'
															  
 WHERE cast(fci.EffectiveEndDate   as date) >  @CycleDt
   AND cast(fci.EffectiveStartDate as date) <= @CycleDt
   AND fci.Deactivation_DimDateId           >  @CycleDt
   AND right(fci.SourceId,2) <> '.N' 
 -- order by fci.ItemId, fci.EffectiveStartDate

  ) z
  )
  SELECT * INTO #TempProjects1Current
	   FROM ProjectActives     pa     
	   order by DimProjectKey, AccountCode, LocationId
;


DROP TABLE if exists #TempProjects1Previous;
 WITH ProjectActives2 AS (

SELECT Distinct DimProjectKey, ProjectCode, AccountCode, LocationId FROM (

SELECT   DimProjectKey, cus_ProjectCode ProjectCode, da.AccountCode, pl.LocationId, fci.* ,dcp.ProductName, dcp.ProductStatusCode --, dci.ItemStatus, dci.ItemDeactivationDate
  FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] fci
  JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount         da  on da.DimAccountId = fci.DimAccountId
  join [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation dsl on dsl.DimServiceLocationId = fci.DimServiceLocationId
  join (
  	SELECT distinct dp.DimProjectKey, dp.DimProjectNaturalKey, csl.cus_ProjectCode, csl.chr_MasterLocationId LocationId
				             , case when dsl.ServiceLocationRegion_WireCenter like '%Urban%' then 'Urban' else 'Rural' end AddressType
							FROM [PBBPDW01].Transient.chr_servicelocation        csl  
							JOIN [PBBPDW01].dbo.DimProjectT1                     dp   on dp.ProjectCode = csl.cus_ProjectCode   COLLATE DATABASE_DEFAULT
							JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation    dsl  on dsl.locationid = csl.chr_masterlocationid
						   WHERE chr_ServiceLocationId is not null
						     AND csl.cus_Serviceable = '972050000'   -- Serviceable Check
						   --  AND Cus_ProjectCode = 'PC-ALMA PROJECT - MIALMACOURTCABT'
  ) pl on pl.LocationId = dsl.LocationId
 JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimCustomerProduct dcp on dcp.DimCustomerProductId = fci.DimCustomerProductId  
 -- JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimCustomerItem    dci on dci.DimCustomerItemId = fci.DimCustomerItemId AND (coalesce(dci.ItemStatus,'A') = 'A' or coalesce(dci.ItemDeactivationDate,'99991231') > '20230228')
 WHERE cast(fci.EffectiveEndDate   as date) > @PrevCycleDt
   AND cast(fci.EffectiveStartDate as date) <=@PrevCycleDt
   AND fci.Deactivation_DimDateId           > @PrevCycleDt
   AND right(fci.SourceId,2) <> '.N'  

  ) z
)     
  SELECT * INTO #TempProjects1Previous 
    FROM ProjectActives2
;

/*
 select * from #TempProjects1Previous where ProjectCode = 'PC-BMH023 (South Oteslic) Project' order by AccountCode
 select * from #TempProjects1Current  where ProjectCode = 'PC-BMH023 (South Oteslic) Project' order by AccountCode  -- +3
*/


-- Declare @CycleDt date = '20230930';
WITH Disco AS (
select DimProjectKey,count(*) DiscoCount from (
		select x.* from #TempProjects1Previous x left join #TempProjects1Current  y on x.AccountCode = y.AccountCode and x.LocationId = y.LocationId where y.AccountCode is null
		) z
		group by DimProjectKey
)
UPDATE dbo.FactProjectPenetration 
   SET disconnectCount = DiscoCount
  FROM Disco
 WHERE Disco.DimProjectKey = FactProjectPenetration.DimprojectId
   AND FactProjectPenetration.DimDate = @CycleDt
;



-- Declare @CycleDt date = '20230930';
WITH Inst AS (
select DimProjectKey,count(*) InstCount from (
		select x.* from #TempProjects1Current  x left join #TempProjects1Previous y on x.AccountCode = y.AccountCode and x.LocationId = y.LocationId  where y.AccountCode is null
		) z
		group by DimProjectKey
)
UPDATE dbo.FactProjectPenetration 
   SET ConnectCount = InstCount
  FROM Inst
 WHERE Inst.DimProjectKey = FactProjectPenetration.DimprojectId
   AND FactProjectPenetration.DimDate = @CycleDt
;

 ----- TEST
 /*

 select top 5  * 
 from FactProjectPenetration fpp join dimprojectt1 dp on dp.DimProjectKey = fpp.DimProjectId
 where 1=1  and dimdate='20230930' - and coalesce(ActiveCompetitiveCustomerCount,0) <> coalesce(ActiveCompetitiveResCount,0)+coalesce(ActiveCompetitiveBusCount,0)

 
select dp.ProjectCode,x.DimProjectId, x.ConnectCount, x.DisconnectCount, x.ConnectCount-x.DisconnectCount NetCount
     , x.ActiveTotalCustomerCount-y.ActiveTotalCustomerCount ExpectedNetCount
     , y.ActiveTotalCustomerCount, x.ActiveTotalCustomerCount ActiveTotalCustomerCountJuly, y.DimDate, x.DimDate DimDateJuly
from FactProjectPenetration x
join FactProjectPenetration y on x.DimProjectId = y.DimProjectId and y.DimDate = dateadd(m,-1,x.DimDate)
join DimProject dp on dp.DimProjectId = x.DimProjectId
where x.DimDate = '20230731'

 */
 -----


END
GO
