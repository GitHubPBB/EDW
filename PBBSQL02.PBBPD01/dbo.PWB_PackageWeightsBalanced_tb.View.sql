USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PWB_PackageWeightsBalanced_tb]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[PWB_PackageWeightsBalanced_tb] AS 
WITH PkgTtl AS (
		select productoffering,packagecomponent, PackageComponentCode, pricelist,coalesce(priceplan,'') PricePlan , cast(round(StandardRate,2) as decimal(12,2)) StandardRate
			 , sum(case when DisperseAmount >= 0 then cast(DisperseAmount   as decimal(12,2)) else 0 end)  DisperseTtl
			 , sum(cast(DisperseAmount   as decimal(12,2)))  DisperseAll
			 , sum(case when DisperseAmount <> 0 then 1 else 0 end) DisperseCount
			 , sum(case when DisperseWeight <> 0 then 1 else 0 end) WeightedCount
			 , count(*) ComponentCount
		from PBBSQL01.[OMNIA_EPBB_P_PBB_CM].[dbo].[PWB_PackageWeights]
		where   coalesce(PricePlan,'') <> 'TEST'
		  and NOT (Component='Affordable Connectivity Program' )
		 -- and NOT (PackageComponentCode like '%*%')
		group by productoffering,packagecomponent,PackageComponentCode, pricelist,coalesce(priceplan,'')  , cast(round(StandardRate,2) as decimal(12,2))
)
, BalancedPkg AS (select distinct ProductOffering, PackageComponent, PackageComponentCode, PriceList, PricePlan, StandardRate, DisperseTtl, DisperseAll, DisperseCount, WeightedCount, ComponentCount
                       , case when StandardRate=DisperseAll then 'Y' else 'N' end DispersedAllFlag
					   , (StandardRate - DisperseAll) DisperseBalance
                    FROM PkgTtl
)
SELECT distinct *  
     , CASE --when PackageComponentCode like '%*%' then 'N'
	        when Weightedcount=1 and DispersedAllFlag='N' then 'Y'
	     --   when Weightedcount=1 and DispersedAllFlag='N' AND DisperseBalance>=0 then 'Y'
	        when DispersedAllFlag = 'Y' then 'Y'
			when ComponentCount = 1 then 'Y'
			else 'N'
			end Allocateable
FROM BalancedPkg 
GO
