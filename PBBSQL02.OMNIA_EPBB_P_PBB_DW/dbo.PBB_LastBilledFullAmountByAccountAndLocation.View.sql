USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_LastBilledFullAmountByAccountAndLocation]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from [dbo].[PBB_LastBilledFullAmountByAccountAndLocation] where LocationID=4257286 or AccountCode = '100506250'
CREATE view [dbo].[PBB_LastBilledFullAmountByAccountAndLocation]
As
	select BillingRunId
		 ,AccountGroupCode
		 ,AccountCode
		 ,LocationId
		 ,BilledAmount
	from
		(
		    select br.BillingRunID / 100 as BillingRunID
				,ac.AccountGroupCode
				,a.AccountCode
				,sl.LocationId
				,sum(isnull(fbc.[BilledChargeAmount],0)) + sum(isnull(fbc.[BilledChargeDiscountAmount],0)) as BilledAmount
				,row_number() over(partition by a.AccountCode
										 ,sl.LocationId
				 order by br.BillingRunID / 100 desc) as rownumber
		    from [OMNIA_EPBB_P_PBB_DW].[dbo].[FactBilledCharge] fbc
			    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimBilledCharge] bc on bc.DimBilledChargeId = fbc.DimBilledChargeId
			    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimBillingRun] br on br.DimBillingRunId = fbc.DimBillingRunId
			    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccount] a on a.DimAccountId = fbc.DimAccountId
			    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccountCategory] ac on ac.DimAccountCategoryId = fbc.DimAccountCategoryId
			    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] cai on cai.DimCatalogItemId = fbc.DimCatalogItemId
			    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogPrice] cap on cap.DimCatalogPriceId = fbc.DimCatalogPriceId
			    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimServiceLocation] sl on sl.DimServiceLocationId = fbc.DimServiceLocationId
		    where cap.CatalogPriceBillingMethod = N'Prebill'
				and bc.BilledChargeFractionalization in('Full')
		    group by br.BillingRunID / 100
				  ,ac.AccountGroupCode
				  ,a.AccountCode
				  ,sl.LocationId
		    --having sum(isnull(fbc.[BilledChargeAmount],0)) + sum(isnull(fbc.[BilledChargeDiscountAmount],0)) > 0
		) d
	where rownumber < 2
GO
