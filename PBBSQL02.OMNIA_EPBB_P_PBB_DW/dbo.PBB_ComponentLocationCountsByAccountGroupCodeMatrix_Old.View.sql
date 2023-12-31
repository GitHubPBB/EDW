USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_ComponentLocationCountsByAccountGroupCodeMatrix_Old]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dbo].[PBB_ComponentLocationCountsByAccountGroupCodeMatrix_Old]
as

	-- select * from [dbo].[PBB_ComponentLocationCountsByAccountGroupCodeMatrix] order by ComponentType, ComponentCode
	select case
			 when _ci.CatalogItemIsData = 'Yes'
			 then 'Data'
			 when _ci.CatalogItemIsPhone = 'Yes'
			 then 'Phone'
			 when _ci.CatalogItemIsCable = 'Yes'
			 then case
					when _ci.CatalogItemIsRF = 'Yes'
					then 'Video(RF)' else 'Video(IP)'
				 end
			 when _ci.CatalogItemIsPromo = 'Yes'
			 then 'Promo'
			 when _ci.CatalogItemIsSmartHome = 'Yes'
			 then 'SmartHome'
			 when _ci.CatalogItemIsPointGuard = 'Yes'
			 then 'PointGuard' else 'Unknown/Other'
		  end as ComponentType
		 ,ci.ComponentCode
		 ,ci.ComponentName
		 ,isnull([BLDBUS],0) as [BLDBUS]
		 ,isnull([BLDRES],0) as [BLDRES]
		 ,isnull([BRIBUS],0) as [BRIBUS]
		 ,isnull([BRIRES],0) as [BRIRES]
		 ,isnull([CPCBUS],0) as [CPCBUS]
		 ,isnull([CPCRES],0) as [CPCRES]
		 ,isnull([DUFBUS],0) as [DUFBUS]
		 ,isnull([DUFRES],0) as [DUFRES]
		 ,isnull([HAGBUS],0) as [HAGBUS]
		 ,isnull([HAGRES],0) as [HAGRES]
		 ,isnull([SWGBUS],0) as [SWGBUS]
		 ,isnull([SWGRES],0) as [SWGRES]
		 ,isnull([TALRES],0) as [TALRES]
		 ,isnull([WHSBVU],0) as [WHSBVU]
		 ,isnull([NONE],0) as [NONE]
		 ,ci.DimCatalogItemId
		 ,cast(ci.ProductComponentID as int) as ProductComponentID
	from
		(
		    select case
					when ac.AccountGroupCode = ''
					then 'NONE' else ac.AccountGroupCode
				 end as AccountGroupCode
				,ci.DimCatalogItemId
				,count(distinct [DimServiceLocationId]) as [Location Count]
		    from [OMNIA_EPBB_P_PBB_DW].[dbo].[FactServiceLocationItem_pbb] sli
			    join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci on ci.DimCatalogItemId = sli.DimCatalogItemId
			    join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccountCategory] ac on ac.DimAccountCategoryId = sli.DimAccountCategoryId
		    where [pbb_LocationItemActivation_DimDateId] <= getdate()
				and ([pbb_LocationItemDeactivation_DimDateId] > getdate()
					or [pbb_LocationItemDeactivation_DimDateId] is null)
		    group by ac.AccountGroupCode
				  ,ci.DimCatalogItemId
		) as SourceTable pivot(sum([Location Count]) for AccountGroupCode in([BLDBUS]
															   ,[BLDRES]
															   ,[BRIBUS]
															   ,[BRIRES]
															   ,[CPCBUS]
															   ,[CPCRES]
															   ,[DUFBUS]
															   ,[DUFRES]
															   ,[HAGBUS]
															   ,[HAGRES]
															   ,[SWGBUS]
															   ,[SWGRES]
															   ,[TALRES]
															   ,[WHSBVU]
															   ,[NONE])) as PivotTable
		inner join DimCatalogItem ci on ci.DimCatalogItemId = PivotTable.DimCatalogItemId
		inner join DimCatalogItem_pbb _ci on _ci.DimCatalogItemId = PivotTable.DimCatalogItemId
	where ci.ComponentCode <> ''
GO
