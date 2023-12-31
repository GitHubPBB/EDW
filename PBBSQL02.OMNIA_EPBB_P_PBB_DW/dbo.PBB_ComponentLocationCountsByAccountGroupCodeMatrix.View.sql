USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_ComponentLocationCountsByAccountGroupCodeMatrix]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PBB_ComponentLocationCountsByAccountGroupCodeMatrix]
AS
	--select * from [dbo].[PBB_ComponentLocationCountsByAccountGroupCodeMatrix] order by ComponentType, ComponentCode
	SELECT CASE
			 WHEN _ci.CatalogItemIsData = 'Yes'
			 THEN 'Data'
			 WHEN _ci.CatalogItemIsPhone = 'Yes'
			 THEN 'Phone'
			 WHEN _ci.CatalogItemIsCable = 'Yes'
			 THEN CASE
					WHEN _ci.CatalogItemIsRF = 'Yes'
					THEN 'Video(RF)' ELSE 'Video(IP)'
				 END
			 WHEN _ci.CatalogItemIsPromo = 'Yes'
			 THEN 'Promo'
			 WHEN _ci.CatalogItemIsSmartHome = 'Yes'
			 THEN 'SmartHome'
			 WHEN _ci.CatalogItemIsPointGuard = 'Yes'
			 THEN 'PointGuard' ELSE 'Unknown/Other'
		  END AS ComponentType
		 ,ci.ComponentCode
		 ,ci.ComponentName
		 ,isnull([ALARES],0) AS [ALARES]
		 ,isnull([BLDBUS],0) AS [BLDBUS]
		 ,isnull([BLDRES],0) AS [BLDRES]
		 ,isnull([BLFWC],0) AS [BLFWC]
		 ,isnull([BRIBUS],0) AS [BRIBUS]
		 ,isnull([BRIGOV],0) AS [BRIGOV]
		 ,isnull([BRIRES],0) AS [BRIRES]
		 ,isnull([CPCBUS],0) AS [CPCBUS]
		 ,isnull([CPCGOV],0) AS [CPCGOV]
		 ,isnull([CPCRES],0) AS [CPCRES]
		 ,isnull([DUFBUS],0) AS [DUFBUS]
		 ,isnull([DUFRES],0) AS [DUFRES]
		 ,isnull([FBSRES],0) AS [FBSRES]
		 ,isnull([HAGBUS],0) AS [HAGBUS]
		 ,isnull([HAGRES],0) AS [HAGRES]
		 ,isnull([ISLBUS],0) AS [ISLBUS]
		 ,isnull([ISLRES],0) AS [ISLRES]
		 ,isnull([MCHRES],0) AS [MCHRES]
		 ,isnull([MICBUS],0) AS [MICBUS]
		 ,isnull([NGABUS],0) AS [NGABUS]
		 ,isnull([NGARES],0) AS [NGARES]
		 ,isnull([NYKBUS],0) AS [NYKBUS]
		 ,isnull([NYKRES],0) AS [NYKRES]
		 ,isnull([OHIBUS],0) AS [OHIBUS]
		 ,isnull([OHIFWR],0) AS [OHIFWR]
		 ,isnull([OHIRES],0) AS [OHIRES]
		 ,isnull([OPLBUS],0) AS [OPLBUS]
		 ,isnull([OPLRES],0) AS [OPLRES]
		 ,isnull([OPLWO],0) AS [OPLWO]
		 ,isnull([SWGBUS],0) AS [SWGBUS]
		 ,isnull([SWGRES],0) AS [SWGRES]
		 ,isnull([TALBUS],0) AS [TALBUS]
		 ,isnull([TALFWR],0) AS [TALFWR]
		 ,isnull([TALRES],0) AS [TALRES]
		 ,isnull([WHSBVU],0) AS [WHSBVU]
		 ,isnull([NONE],0) AS [NONE]
		 ,ci.DimCatalogItemId
		 ,cast(ci.ProductComponentID AS INT) AS ProductComponentID
	FROM
		(
		    SELECT CASE
					WHEN ac.AccountGroupCode = ''
					THEN 'NONE' ELSE ac.AccountGroupCode
				 END AS AccountGroupCode
				,ci.DimCatalogItemId
				,count(DISTINCT [DimServiceLocationId]) AS [Location Count]
		    FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
			    JOIN DimCustomerItem ON sli.DimCustomerItemId = DimCustomerItem.DimCustomerItemId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccountCategory] ac ON ac.DimAccountCategoryId = sli.DimAccountCategoryId
		    WHERE [Activation_DimDateId] <= getdate()
				AND ([Deactivation_DimDateId] > getdate()
					OR [Deactivation_DimDateId] IS NULL)
				and (sli.EffectiveStartDate <= getDate()
					and sli.EffectiveEndDate > getdate())
				and DimCustomerItem.ItemStatus <> 'I'
				and DimCustomerItem.ItemStatus <> ' '
		    GROUP BY ac.AccountGroupCode
				  ,ci.DimCatalogItemId
		) AS SourceTable pivot(sum([Location Count]) FOR AccountGroupCode IN([ALARES]
															   ,[BLDBUS]
															   ,[BLDRES]
															   ,[BLFWC]
															   ,[BRIBUS]
															   ,[BRIGOV]
															   ,[BRIRES]
															   ,[CPCBUS]
															   ,[CPCGOV]
															   ,[CPCRES]
															   ,[DUFBUS]
															   ,[DUFRES]
															   ,[FBSRES]
															   ,[HAGBUS]
															   ,[HAGRES]
															   ,[ISLBUS]
															   ,[ISLRES]
															   ,[MCHRES]
															   ,[MICBUS]
															   ,[NGABUS]
															   ,[NGARES]
															   ,[NYKBUS]
															   ,[NYKRES]
															   ,[OHIBUS]
															   ,[OHIFWR]
															   ,[OHIRES]
															   ,[OPLBUS]
															   ,[OPLRES]
															   ,[OPLWO]
															   ,[SWGBUS]
															   ,[SWGRES]
															   ,[TALBUS]
															   ,[TALFWR]
															   ,[TALRES]
															   ,[WHSBVU]
															   ,[NONE])) AS PivotTable
		INNER JOIN DimCatalogItem ci ON ci.DimCatalogItemId = PivotTable.DimCatalogItemId
		INNER JOIN DimCatalogItem_pbb _ci ON _ci.DimCatalogItemId = PivotTable.DimCatalogItemId
	WHERE ci.ComponentCode <> ''
GO
