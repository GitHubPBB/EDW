USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_FactProjectPenetration_EXT]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[PBB_Populate_FactProjectPenetration_EXT]
	(@CycleDate date)
AS


BEGIN

-- DECLARE @CycleDate date='20231201'
DECLARE @MaxKey int=0;
DECLARE @RunDatetime datetime = getdate();
DECLARE @CycleDt date;

SELECT @CycleDt = case when @CycleDate is not null then dateadd(d,-1,cast(@CycleDate as date)) else cast(getdate() as date) end;

SELECT @MaxKey = coalesce(max(FactProjectPenetrationId),0) FROM [PBBPDW01].dbo.FactProjectPenetration  ;

 


/*
WITH 
CRMAddresses 

  AS (  SELECT cus_ProjectCode,count(*) CrmAddressCount
		  FROM  [PBBPDW01].transient.[chr_serviceLocationBase] c   -- CRM Address per project
		 WHERE cus_ProjectCode is not null
		   AND cus_ProjectCode NOT IN ('PC-Duplicate - Do Not Use','PC-UNIVERSAL')
	     GROUP BY cus_ProjectCode
  )
		SELECT * , Row_Number() over (order by CrmAddressCount desc) CrmAddressRank  FROM CRMAddresses ;
*/

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


-- 
 
DROP TABLE if exists #TempProjects1; 

WITH PeneDetails AS (
	SELECT dp.DimProjectKey
	     , dp.DimMarketKey
	     , dp.ProjectServiceableDate ServiceableDate
         , case when ProjectServiceableDate ='99991231' then -1 else datediff(m,cast(ProjectServiceableDate as date),dateadd(d,-1,cast(getdate() as date))) end ProjectAgeMonths
		 , dp.CompetitiveType
	     , cus_ProjectNameName                                                                    ProjectCode
	     , coalesce(cus_CompetitiveAddresses,0)                                                   CompetitiveAddresses
		 , coalesce(cus_UnderservedAddresses,0)                                                   UnderServedAddresses
		 , coalesce(cus_CompetitiveAddresses,0) +coalesce(cus_UnderservedAddresses,0)             TotalServiceableAddresses
		 , coalesce(cus_ActiveCompetitiveCustomers,0)                                             CompetitiveCustomers
		 , coalesce(cus_ActiveUnderServedCustomers,0)                                             UnderServedCustomers
		 , coalesce(cus_ActiveCompetitiveCustomers,0) +coalesce(cus_ActiveUnderServedCustomers,0) TotalActiveCustomers
    FROM [transient].[cus_externalprojectpenetration] epp
    JOIN [PBBPDW01].dbo.DimProjectT1 dp on dp.ProjectCode = epp.cus_projectNameName COLLATE DATABASE_DEFAULT 
)
, PeneCalc AS (
    SELECT pd.*
	     , case when CompetitiveAddresses      > 0.00 then cast(round(CompetitiveCustomers*100.0/CompetitiveAddresses,2)      as decimal(5,2)) else 0 end CompetitivePenetration
	     , case when UnderServedAddresses      > 0.00 then cast(round(UnderServedCustomers*100.0/UnderServedAddresses,2)      as decimal(5,2)) else 0 end UnderServedPenetration
	     , case when TotalServiceableAddresses > 0.00 then cast(round(TotalActiveCustomers*100.0/TotalServiceableAddresses,2) as decimal(5,2)) else 0 end TotalPenetration
	  FROM PeneDetails pd
)
SELECT *
  INTO #TempProjects1
  FROM PeneCalc
;

-- select * from #TempProjects1

DROP TABLE if exists #TempProjects2;

select (@MaxKey + Row_Number() over (order by DimProjectKey)) FactProjectPenetrationId
     , tp2.DimProjectKey
     , tp2.DimMarketKey
	 , dateadd(d,-1,@CycleDate) DimDate
     , case when tp2.ProjectAgeMonths is null then -1 else tp2.ProjectAgeMonths end ProjectAgeMonths
	 , tp2.CompetitiveAddresses   CompetitiveAddressCount
	 , tp2.UnderServedAddresses   UnderServedAddressCount
	 , tp2.totalServiceableAddresses   ServiceableAddressCount
	 , 0 ActiveCompetitiveRESCount
	 , 0 ActiveCompetitiveBUSCount
	 , CompetitiveCustomers
	 , 0 ActiveUnderServedRESCount
	 , 0 ActiveUnderServedBUSCount
	 , UnderServedCustomers
	 , 0 CurrentMonthlyBilledAvgMRC
	 , CompetitivePenetration
	 , UnderServedPenetration
	 , TotalPenetration
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
	        when tp2.CompetitiveType = 'Non-Competitive' then 
				 case when TotalPenetration/100 >  coalesce(pgrU.GreenGoalPct,pgrUM.GreenGoalPct) then 'Green'
					  when TotalPenetration/100 <= coalesce(pgrU.RedGoalPct,pgrUM.RedGoalPct)     then 'Red'
					  else 'Yellow'
				  end 
	        when tp2.CompetitiveType = 'Hybrid'     then 
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

	 , tp2.CompetitiveType
	 , tp2.ProjectCode
  into #TempProjects2
  from #TempProjects1 tp2
  left join [PBBPDW01].dbo.ProjectGrowthRamp  pgrU on pgrU.ProjectAddressType      = 'Underserved' and tp2.UnderServedAddresses > 0  and pgrU.ProjectAgeMonths = tp2.ProjectAgeMonths 
  left join [PBBPDW01].dbo.ProjectGrowthRamp  pgrC on pgrC.ProjectAddressType      = 'Competitive' and tp2.CompetitiveAddresses > 0  and pgrC.ProjectAgeMonths = tp2.ProjectAgeMonths 
  left join [PBBPDW01].dbo.ProjectGrowthRamp  pgrH  on pgrH.ProjectAddressType     = 'Hybrid'      and TotalPenetration         >= 0 and pgrH.ProjectAgeMonths = tp2.ProjectAgeMonths 

  left join [PBBPDW01].dbo.ProjectGrowthRamp  pgrCM  on pgrCM.ProjectAddressType   = 'Competitive' and TotalPenetration         >= 0 and pgrCM.ProjectAgeMonths  = 36 AND tp2.ProjectAgeMonths > 36
  left join [PBBPDW01].dbo.ProjectGrowthRamp  pgrHM  on pgrHM.ProjectAddressType   = 'Hybrid'      and TotalPenetration         >= 0 and pgrHM.ProjectAgeMonths  = 36 AND tp2.ProjectAgeMonths > 36
  left join [PBBPDW01].dbo.ProjectGrowthRamp  pgrUM  on pgrUM.ProjectAddressType   = 'Underserved' and UnderServedPenetration   >= 0 and pgrUM.ProjectAgeMonths  = 36 AND tp2.ProjectAgeMonths > 36
;

--select * from [PBBPDW01].dbo.ProjectGrowthRamp 
-- select * from #TempProjects2

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
	 , x.CompetitiveCustomers
	 , x.ActiveUnderServedRESCount
	 , x.ActiveUnderServedBUSCount
	 , x.UnderServedCustomers
	 , x.CurrentMonthlyBilledAvgMRC
	 , x.CompetitivePenetration
	 , x.UnderServedPenetration
	 , x.TotalPenetration
	 , x.GrowthGoalTotalColor GrowthGoalCompetitiveColor
	 , x.GrowthGoalTotalColor GrowthGoalUnderServedColor
	 , x.GrowthGoalTotalColor
	  ,x.GrowthRampRedGoalPct
	  ,x.GrowthRampGreenGoalPct
	  ,0 Connects
	  ,0 Disconnects
	 , case when x.TotalPenetration is not null and x.GrowthGoalTotalColor =  'Green' then cast(round(((x.GrowthRampGreenGoalPct * x.ServiceableAddressCount)*1.00/100 - (x.CompetitiveCustomers+x.UnderServedCustomers) + .49),0) as smallint)
	        when x.TotalPenetration is not null and x.GrowthGoalTotalColor <> 'Green' then cast(round(((x.GrowthRampGreenGoalPct * x.ServiceableAddressCount)*1.00/100 - (x.CompetitiveCustomers+x.UnderServedCustomers) - .49),0) as smallint)
	        else null
			end  GetToGreenCustomerCount
  FROM #TempProjects2                  x
  LEFT JOIN dbo.FactProjectPenetration y ON  x.DimProjectKey = y.DimProjectId 
                                         AND x.DimDate      = y.DimDate
  WHERE y.DimProjectId is null

;

 

END
GO
